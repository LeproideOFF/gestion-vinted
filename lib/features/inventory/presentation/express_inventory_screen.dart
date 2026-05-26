import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'inventory_provider.dart';
import '../../../shared/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../domain/vinted_article.dart';

class ExpressInventoryScreen extends ConsumerStatefulWidget {
  const ExpressInventoryScreen({super.key});

  @override
  ConsumerState<ExpressInventoryScreen> createState() => _ExpressInventoryScreenState();
}

class _ExpressInventoryScreenState extends ConsumerState<ExpressInventoryScreen> {
  final Set<String> _scannedUuids = {};
  String? _lastScan;
  bool _showMissing = false;

  @override
  Widget build(BuildContext context) {
    final articlesAsync = ref.watch(inventoryListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaire Express'),
        actions: [
          IconButton(
            icon: Icon(_showMissing ? Icons.visibility_off : Icons.list),
            onPressed: () => setState(() => _showMissing = !_showMissing),
          ),
        ],
      ),
      body: articlesAsync.when(
        data: (articles) {
          final toScan = articles.where((a) => a.status == 'A vendre').toList();
          final missing = toScan.where((a) => !_scannedUuids.contains(a.uuid)).toList();
          
          return Stack(
            children: [
              MobileScanner(
                onDetect: (capture) {
                  for (final barcode in capture.barcodes) {
                    final code = barcode.rawValue;
                    if (code != null) {
                      _processScan(code, toScan);
                    }
                  }
                },
              ),
              
              if (_showMissing)
                _buildMissingList(missing),

              _buildScanOverlay(toScan.length),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  void _processScan(String code, List<VintedArticle> articles) {
    final article = articles.where((a) => a.uuid == code || a.barcode == code).firstOrNull;
    if (article != null) {
      if (!_scannedUuids.contains(article.uuid)) {
        setState(() {
          _scannedUuids.add(article.uuid);
          _lastScan = article.title;
        });
      }
    }
  }

  Widget _buildMissingList(List<VintedArticle> missing) {
    return Positioned.fill(
      child: GlassContainer(
        color: Colors.black87,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'ARTICLES MANQUANTS',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: missing.length,
                itemBuilder: (context, index) {
                  final art = missing[index];
                  return ListTile(
                    title: Text(art.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('Emplacement: ${art.location}', style: const TextStyle(color: Colors.white70)),
                    leading: const Icon(Icons.inventory_2_outlined, color: Colors.red),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => setState(() => _showMissing = false),
                child: const Text('RETOUR AU SCAN'),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildScanOverlay(int total) {
    return Positioned(
      bottom: 50, left: 20, right: 20,
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '${_scannedUuids.length} / $total',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const Text('ARTICLES VÉRIFIÉS', style: TextStyle(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
            if (_lastScan != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('✅ $_lastScan', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ).animate(key: ValueKey(_lastScan)).scale().fadeIn(),
          ],
        ),
      ),
    );
  }
}
