import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/isar_service.dart';
import '../domain/vinted_article.dart';
import '../../../core/utils/discord_service.dart';

part 'inventory_provider.g.dart';

// On garde le service vivant pour ne pas rouvrir la DB sans arrêt
@Riverpod(keepAlive: true)
IsarService isarService(IsarServiceRef ref) {
  return IsarService();
}

@riverpod
Stream<List<VintedArticle>> inventoryList(InventoryListRef ref) {
  return ref.watch(isarServiceProvider).watchArticles();
}

@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addArticle(VintedArticle article) async {
    final isar = ref.read(isarServiceProvider);
    
    // On sauvegarde
    await isar.saveArticle(article);
    
    // Notification Discord optionnelle
    try {
      final discord = ref.read(discordServiceProvider.notifier);
      
      // On envoie la notification complète (on simplifie en ne cherchant pas l'ancien état pour éviter les bugs Isar)
      await discord.sendArticleNotification(article: article, isUpdate: false);

      if (article.status == 'Vendu') {
        await discord.sendSaleNotification(
          title: article.title,
          profit: article.netProfit,
          salePrice: article.sellingPrice,
        );

        final allArticles = await isar.getAllArticles();
        final totalSales = allArticles
            .where((a) => a.status == 'Vendu' && a.updatedAt.year == DateTime.now().year)
            .fold(0.0, (sum, a) => sum + a.sellingPrice);
        
        if (totalSales >= 2400) {
          await discord.sendFiscalAlert(totalSales: totalSales, limit: 3000);
        }
      }
    } catch (e) {
      // On ignore
    }
  }

  Future<void> removeArticle(int id) async {
    await ref.read(isarServiceProvider).deleteArticle(id);
  }
}
