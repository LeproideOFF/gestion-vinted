import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'inventory_provider.dart';
import '../../../shared/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuditModeScreen extends ConsumerStatefulWidget {
  const AuditModeScreen({super.key});

  @override
  ConsumerState<AuditModeScreen> createState() => _AuditModeScreenState();
}

class _AuditModeScreenState extends ConsumerState<AuditModeScreen> {
  String? _lastScan;
  String? _message;
  Color _statusColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(inventoryListProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Mode Audit de Stock')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final code = capture.barcodes.first.rawValue;
              if (code != null && code != _lastScan) {
                setState(() {
                  _lastScan = code;
                  final art = articles.firstWhere(
                    (a) => a.uuid == code || a.barcode == code,
                    orElse: () => throw 'Non trouvé',
                  );
                  _message = 'Trouvé: ${art.title}\nEmplacement: ${art.location}';
                  _statusColor = Colors.green;
                });
              }
            },
          ),
          Positioned(
            bottom: 50, left: 20, right: 20,
            child: GlassContainer(
              padding: const EdgeInsets.all(20),
              color: _statusColor.withOpacity(0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('SCANNEZ UN QR CODE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  const SizedBox(height: 10),
                  Text(_message ?? 'En attente de scan...', textAlign: TextAlign.center),
                ],
              ),
            ).animate(key: ValueKey(_lastScan)).shake(),
          ),
        ],
      ),
    );
  }
}
