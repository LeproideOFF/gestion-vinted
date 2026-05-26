import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nsd/nsd.dart' as nsd;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';
import '../../inventory/domain/vinted_article.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../../../core/utils/file_service.dart';
import '../../../core/utils/discord_service.dart';
import '../../../core/utils/log_service.dart';

part 'sync_service.g.dart';

enum SyncStatus { idle, scanning, advertising, connecting, transferring, success, failure }

class SyncState {
  final SyncStatus status;
  final String? message;
  final String? pin;

  SyncState({required this.status, this.message, this.pin});
}

const String syncEodMarker = '###EMPIRE_PRO_SYNC_END###';

@riverpod
class SyncNotifier extends _$SyncNotifier {
  nsd.Registration? _registration;
  nsd.Discovery? _discovery;
  ServerSocket? _serverSocket;
  bool _isProcessing = false;
  
  @override
  SyncState build() => SyncState(status: SyncStatus.idle);

  Future<void> startAdvertising() async {
    await stop();
    state = SyncState(status: SyncStatus.advertising, pin: '1234');
    LogService.log('SYNC: Starting advertising on port 4545');
    
    try {
      _registration = await nsd.register(
        const nsd.Service(name: 'VintedSync', type: '_vintedsync._tcp', port: 4545),
      );

      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4545, shared: true);
      _serverSocket!.listen(_handleConnection);
    } catch (e) {
      LogService.log('SYNC_ERR: Advertising failed: $e');
      state = SyncState(status: SyncStatus.failure, message: 'Erreur démarrage : $e');
    }
  }

  Future<void> startDiscovery() async {
    await stop();
    state = SyncState(status: SyncStatus.scanning);
    LogService.log('SYNC: Starting discovery');
    
    try {
      _discovery = await nsd.startDiscovery('_vintedsync._tcp');
      _discovery!.addListener(() {
        if (_discovery!.services.isNotEmpty && state.status == SyncStatus.scanning) {
          final service = _discovery!.services.first;
          LogService.log('SYNC: Device found: ${service.name}');
          _connectToService(service);
          // On ne stoppe pas la discovery tout de suite pour laisser le temps à la connexion
        }
      });
    } catch (e) {
      LogService.log('SYNC_ERR: Discovery failed: $e');
      state = SyncState(status: SyncStatus.failure, message: 'Erreur recherche : $e');
    }
  }

  void _handleConnection(Socket socket) {
    if (_isProcessing) {
      LogService.log('SYNC: Already processing a connection, ignoring.');
      socket.close();
      return;
    }
    
    LogService.log('SYNC: Connection received from ${socket.remoteAddress.address}');
    state = SyncState(status: SyncStatus.transferring, message: 'Réception en cours...');
    List<int> bytes = [];
    final markerBytes = utf8.encode(syncEodMarker);
    
    socket.listen((data) async {
      bytes.addAll(data);
      
      // Recherche du marqueur dans les derniers octets reçus (plus robuste)
      if (bytes.length >= markerBytes.length) {
        // On cherche le marqueur dans les 100 derniers octets pour être sûr
        final searchRange = bytes.length > 100 ? 100 : bytes.length;
        final lastBytes = bytes.sublist(bytes.length - searchRange);
        
        int matchIndex = -1;
        for (int i = 0; i <= lastBytes.length - markerBytes.length; i++) {
          bool found = true;
          for (int j = 0; j < markerBytes.length; j++) {
            if (lastBytes[i + j] != markerBytes[j]) {
              found = false;
              break;
            }
          }
          if (found) {
            matchIndex = bytes.length - searchRange + i;
            break;
          }
        }
        
        if (matchIndex != -1 && !_isProcessing) {
          _isProcessing = true;
          LogService.log('SYNC: EOD Marker found at index $matchIndex. Processing total ${bytes.length} bytes.');
          final rawBytes = bytes.sublist(0, matchIndex);
          _processReceivedData(socket, rawBytes);
        }
      }
    }, onError: (e) {
      LogService.log('SYNC_ERR: Socket error during reception: $e');
      state = SyncState(status: SyncStatus.failure, message: 'Erreur socket : $e');
      _isProcessing = false;
      socket.close();
    }, onDone: () {
      if (!_isProcessing) {
        LogService.log('SYNC: Socket closed without finding marker.');
        state = SyncState(status: SyncStatus.failure, message: 'Connexion interrompue');
      }
    });
  }

  Future<void> _processReceivedData(Socket socket, List<int> rawBytes) async {
    try {
      LogService.log('SYNC: Decoding ${rawBytes.length} bytes of JSON data');
      final String rawContent = utf8.decode(rawBytes);
      final Map<String, dynamic> fullData = json.decode(rawContent);
      final List<dynamic> articlesJson = fullData['articles'];
      final Map<String, dynamic> imagesData = fullData['images'];

      LogService.log('SYNC: Received ${articlesJson.length} articles and ${imagesData.length} image sets');

      final isar = ref.read(isarServiceProvider);
      final localArticles = await isar.getAllArticles();
      final directory = await getApplicationDocumentsDirectory();

      int updatedCount = 0;
      for (var jsonArt in articlesJson) {
        final article = VintedArticle.fromJson(jsonArt);
        List<String> newLocalPaths = [];
        if (imagesData.containsKey(article.uuid)) {
          List<dynamic> base64Images = imagesData[article.uuid];
          for (var b64 in base64Images) {
            final imageBytes = base64Decode(b64);
            final fileName = '${article.uuid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final file = File('${directory.path}/$fileName');
            await file.writeAsBytes(imageBytes);
            newLocalPaths.add(file.path);
          }
        }
        article.photoPaths = newLocalPaths;

        final existingIndex = localArticles.indexWhere((l) => l.uuid == article.uuid);
        if (existingIndex != -1) {
          final merged = localArticles[existingIndex].merge(article);
          await isar.saveArticle(merged);
        } else {
          await isar.saveArticle(article);
        }
        updatedCount++;
      }

      LogService.log('SYNC: Successfully saved $updatedCount articles. Sending ACK.');
      socket.write('ACK');
      await socket.flush();
      await socket.close();

      state = SyncState(status: SyncStatus.success, message: '$updatedCount articles synchronisés !');
      _isProcessing = false;
      
      try {
        ref.read(discordServiceProvider.notifier).sendSyncNotification(
          deviceName: 'Appareil distant',
          count: updatedCount,
        );
      } catch (_) {}
    } catch (e) {
      LogService.log('SYNC_ERR: Data processing failed: $e');
      state = SyncState(status: SyncStatus.failure, message: 'Erreur traitement : $e');
      _isProcessing = false;
      try {
        socket.write('ERROR');
        await socket.flush();
      } catch (_) {}
      socket.close();
    }
  }

  Future<void> _connectToService(nsd.Service service) async {
    if (state.status == SyncStatus.connecting || state.status == SyncStatus.transferring) return;
    
    state = SyncState(status: SyncStatus.connecting);
    LogService.log('SYNC: Connecting to ${service.host}:${service.port}');
    try {
      final socket = await Socket.connect(service.host, service.port!, timeout: const Duration(seconds: 15));
      state = SyncState(status: SyncStatus.transferring, message: 'Préparation des données...');

      final localArticles = await ref.read(isarServiceProvider).getAllArticles();
      LogService.log('SYNC: Preparing ${localArticles.length} articles for sending.');
      
      Map<String, List<String>> imagesBase64 = {};
      for (var a in localArticles) {
        List<String> b64List = [];
        for (var path in a.photoPaths) {
          final file = File(path);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            b64List.add(base64Encode(bytes));
          }
        }
        imagesBase64[a.uuid] = b64List;
      }

      final payload = json.encode({
        'articles': localArticles.map((e) => e.toJson()).toList(),
        'images': imagesBase64,
      });
      
      Completer<String> ackCompleter = Completer();
      socket.listen(
        (data) {
          final resp = utf8.decode(data);
          LogService.log('SYNC: Received response from host: $resp');
          if (!ackCompleter.isCompleted) ackCompleter.complete(resp);
        },
        onDone: () { 
          LogService.log('SYNC: Socket closed by host.');
          if (!ackCompleter.isCompleted) ackCompleter.complete('CLOSED'); 
        },
        onError: (e) { 
          LogService.log('SYNC_ERR: Socket error during wait for ACK: $e');
          if (!ackCompleter.isCompleted) ackCompleter.completeError(e); 
        },
      );

      LogService.log('SYNC: Sending payload (${payload.length} chars) + Marker');
      state = SyncState(status: SyncStatus.transferring, message: 'Envoi en cours...');
      socket.write(payload);
      socket.write(syncEodMarker);
      await socket.flush();
      
      final response = await ackCompleter.future.timeout(
        const Duration(seconds: 120),
        onTimeout: () => 'TIMEOUT',
      );

      if (response == 'ACK') {
        LogService.log('SYNC: Sync validated by host.');
        state = SyncState(status: SyncStatus.success, message: 'Synchronisation validée !');
        try {
          ref.read(discordServiceProvider.notifier).sendSyncNotification(
            deviceName: 'Cet appareil',
            count: localArticles.length,
          );
        } catch (_) {}
      } else {
        LogService.log('SYNC_ERR: Validation failed: $response');
        state = SyncState(status: SyncStatus.failure, message: 'Erreur validation : $response');
      }

      await socket.close();
    } catch (e) {
      LogService.log('SYNC_ERR: Connection/Send failed: $e');
      state = SyncState(status: SyncStatus.failure, message: 'Erreur : $e');
    }
  }

  Future<void> stop() async {
    LogService.log('SYNC: Stopping all services');
    _isProcessing = false;
    try {
      if (_registration != null) {
        await nsd.unregister(_registration!);
        _registration = null;
      }
      if (_discovery != null) {
        await nsd.stopDiscovery(_discovery!);
        _discovery = null;
      }
    } catch (e) {}
    await _serverSocket?.close();
    _serverSocket = null;
    state = SyncState(status: SyncStatus.idle);
  }
}
