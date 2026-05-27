import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../domain/vinted_article.dart';
import '../../../shared/glass_container.dart';

class StockQrDialog extends StatelessWidget {
  final VintedArticle article;

  const StockQrDialog({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ÉTIQUETTE DE STOCK',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: QrImageView(
                data: article.uuid,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              article.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'SKU: ${article.uuid.substring(0, 8)}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Logique d'impression ou partage
                    },
                    icon: const Icon(Icons.print_rounded),
                    label: const Text('IMPRIMER'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('FERMER'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
