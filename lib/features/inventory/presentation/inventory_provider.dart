import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/isar_service.dart';
import '../domain/vinted_article.dart';

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
    await ref.read(isarServiceProvider).saveArticle(article);
  }

  Future<void> removeArticle(int id) async {
    await ref.read(isarServiceProvider).deleteArticle(id);
  }
}
