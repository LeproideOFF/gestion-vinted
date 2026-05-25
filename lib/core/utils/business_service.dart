import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/inventory/domain/vinted_article.dart';

class BusinessService {
  static Future<void> exportInventoryToCSV(List<VintedArticle> articles) async {
    try {
      List<List<dynamic>> rows = [
        ['ID', 'Titre', 'Statut', 'Prix Achat', 'Frais Port', 'Frais Vinted', 'Emballage', 'Coût Total', 'Prix Vente', 'Profit Net', 'Emplacement', 'Code Barre', 'Numéro Suivi', 'Date Ajout']
      ];

      for (var a in articles) {
        rows.add([
          a.uuid, a.title, a.status, a.purchasePrice, a.shippingCost, a.platformFees, a.packagingCost, 
          a.totalPurchaseCost, a.sellingPrice, a.netProfit, a.location, a.barcode, a.trackingNumber, a.createdAt.toIso8601String()
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);
      
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/inventaire_vinted_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(path);
      await file.writeAsString(csv);
      
      // Partager ou ouvrir le fichier
      await Share.shareXFiles([XFile(path)], text: 'Export Inventaire Vinted');
      
    } catch (e) {
      print('Erreur lors de l\'export CSV: $e');
    }
  }

  static void shareArticle(VintedArticle article) {
    final text = '✨ ${article.title}\n💸 ${article.sellingPrice}€\n\n${article.description}\n\n📦 Envoi rapide garanti !';
    if (article.photoPaths.isNotEmpty) {
      Share.shareXFiles([XFile(article.photoPaths.first)], text: text);
    } else {
      Share.share(text);
    }
  }
}
