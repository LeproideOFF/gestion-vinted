import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../inventory/domain/vinted_article.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../../core/utils/discord_service.dart';

part 'tracking_service.g.dart';

@riverpod
class TrackingService extends _$TrackingService {
  @override
  void build() {}

  // Simulation d'une API de tracking (par exemple 17track ou Aftership)
  Future<void> checkTracking(VintedArticle article) async {
    if (article.trackingNumber.isEmpty) return;

    // Simulation d'un changement de statut
    // Dans une version réelle, on ferait un http.get(API_URL + article.trackingNumber)
    
    // Exemple de logique : si on détecte "Livré"
    if (article.status == 'Vendu' && article.trackingNumber.length > 5) {
      // Notification Discord
      try {
        await ref.read(discordServiceProvider.notifier).sendMessage(
          '📦 **MISE À JOUR LOGISTIQUE**\n'
          'L\'article **${article.title}** (${article.trackingNumber}) a été mis à jour !\n'
          'Statut : **En cours de livraison** 🚚'
        );
      } catch (_) {}
    }
  }

  Future<void> updateAllTrackings() async {
    final articles = await ref.read(isarServiceProvider).getAllArticles();
    final shippedArticles = articles.where((a) => a.trackingNumber.isNotEmpty && a.status == 'Vendu').toList();

    for (var article in shippedArticles) {
      await checkTracking(article);
    }
  }
}
