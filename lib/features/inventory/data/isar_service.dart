import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/vinted_article.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    print('DB_LOG: Opening database...');
    final dir = await getApplicationDocumentsDirectory();
    print('DB_LOG: Documents directory: ${dir.path}');
    if (Isar.instanceNames.isEmpty) {
      print('DB_LOG: Creating new Isar instance');
      final isar = await Isar.open(
        [VintedArticleSchema],
        directory: dir.path,
        inspector: false,
      );
      print('DB_LOG: Isar instance created');
      return isar;
    }
    print('DB_LOG: Returning existing Isar instance');
    return Isar.getInstance()!;
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
