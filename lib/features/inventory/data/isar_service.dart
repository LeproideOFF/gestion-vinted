import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/vinted_article.dart';
import '../domain/market_config.dart';
import '../../../core/theme/settings_config.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = dir.path;
    
    try {
      if (Isar.instanceNames.isEmpty) {
        return await Isar.open(
          [VintedArticleSchema, MarketConfigSchema, SettingsConfigSchema],
          directory: dbPath,
          inspector: false,
        );
      }
      return Isar.getInstance()!;
    } catch (e) {
      print('DB_LOG: Schema error, attempting recovery: $e');
      if (Isar.instanceNames.isNotEmpty) {
        await Isar.getInstance()?.close();
      }
      return await Isar.open(
        [VintedArticleSchema, MarketConfigSchema, SettingsConfigSchema],
        directory: dbPath,
        inspector: false,
      );
    }
  }

  // CRUD Articles
  Future<void> saveArticle(VintedArticle article) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.vintedArticles.put(article);
    });
  }

  Future<List<VintedArticle>> getAllArticles() async {
    final isar = await db;
    return await isar.vintedArticles.where().findAll();
  }

  Future<void> deleteArticle(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.vintedArticles.delete(id);
    });
  }

  Stream<List<VintedArticle>> watchArticles() async* {
    final isar = await db;
    yield* isar.vintedArticles.where().watch(fireImmediately: true);
  }
}
