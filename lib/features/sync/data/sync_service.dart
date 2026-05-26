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

part 'sync_service.g.dart';

enum SyncStatus { idle, scanning, advertising, connecting, transferring, success, failure }

class SyncState {
  final SyncStatus status;
  final String? message;
  final String? pin;

  SyncState({required this.status, this.message, this.pin});
}

@riverpod
class SyncNotifier extends _$SyncNotifier {
  nsd.Registration? _registration;
  nsd.Discovery? _discovery;
  ServerSocket? _serverSocket;
  
  @override
  SyncState build() => SyncState(status: SyncStatus.idle);

  // Démarrer l'annonce (Hôte - Reçoit les données)
  Future<void> startAdvertising() async {
    await stop(); // Nettoyage préalable
    state = SyncState(status: SyncStatus.advertising, pin: '1234');
    
    _registration = await nsd.register(
      const nsd.Service(name: 'VintedSync', type: '_vintedsync._tcp', port: 4545),
    );

    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4545, shared: true);
    _serverSocket!.listen(_handleConnection);
  }

  // Démarrer le scan (Client - Envoie les données)
  Future<void> startDiscovery() async {
    await stop(); // Nettoyage préalable
    state = SyncState(status: SyncStatus.scanning);
    
    _discovery = await nsd.startDiscovery('_vintedsync._tcp');
    _discovery!.addListener(() {
      if (_discovery!.services.isNotEmpty) {
        final service = _discovery!.services.first;
        _connectToService(service);
        nsd.stopDiscovery(_discovery!);
      }
    });
  }

  void _handleConnection(Socket socket) {
    state = SyncState(status: SyncStatus.transferring);
    StringBuffer buffer = StringBuffer();
    
    socket.listen((data) async {
      buffer.write(utf8.decode(data));
    }, onDone: () async {
      try {
        final Map<String, dynamic> fullData = json.decode(buffer.toString());
        final List<dynamic> articlesJson = fullData['articles'];
        final Map<String, dynamic> imagesData = fullData['images']; // Map<Uuid, List<Base64>>

        final isar = ref.read(isarServiceProvider);
        final localArticles = await isar.getAllArticles();

        for (var jsonArt in articlesJson) {
          final article = VintedArticle.fromJson(jsonArt);
          
          // Récupérer et sauvegarder les images transmises
          List<String> newLocalPaths = [];
          if (imagesData.containsKey(article.uuid)) {
            List<dynamic> base64Images = imagesData[article.uuid];
            for (var b64 in base64Images) {
              final bytes = base64Decode(b64);
              final directory = await getApplicationDocumentsDirectory();
              final fileName = '${article.uuid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
              final file = File('${directory.path}/$fileName');
              await file.writeAsBytes(bytes);
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
        }

        state = SyncState(status: SyncStatus.success, message: '${articlesJson.length} articles synchronisés avec images !');
        
        // Notification Discord
        try {
          ref.read(discordServiceProvider.notifier).sendSyncNotification(
            deviceName: 'Appareil distant',
            count: articlesJson.length,
          );
        } catch (_) {}
      } catch (e) {
        state = SyncState(status: SyncStatus.failure, message: 'Erreur décodage: $e');
      }
    }, onError: (e) {
      state = SyncState(status: SyncStatus.failure, message: e.toString());
    });
  }

  Future<void> _connectToService(nsd.Service service) async {
    state = SyncState(status: SyncStatus.connecting);
    try {
      final socket = await Socket.connect(service.host, service.port!);
      state = SyncState(status: SyncStatus.transferring);

      final localArticles = await ref.read(isarServiceProvider).getAllArticles();
      
      // Préparer le paquet complet (Articles + Images en Base64)
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
      
      socket.write(payload);
      await socket.flush();
      await socket.close();

      state = SyncState(status: SyncStatus.success, message: 'Données et photos envoyées !');

      // Notification Discord
      try {
        ref.read(discordServiceProvider.notifier).sendSyncNotification(
          deviceName: 'Cet appareil (Envoi)',
          count: localArticles.length,
        );
      } catch (_) {}
    } catch (e) {
      state = SyncState(status: SyncStatus.failure, message: e.toString());
    }
  }

  Future<void> stop() async {
    try {
      if (_registration != null) {
        await nsd.unregister(_registration!);
        _registration = null;
      }
      if (_discovery != null) {
        await nsd.stopDiscovery(_discovery!);
        _discovery = null;
      }
    } catch (e) {
      print('Sync stop error (ignoring): $e');
    }
    await _serverSocket?.close();
    _serverSocket = null;
    state = SyncState(status: SyncStatus.idle);
  }
}
