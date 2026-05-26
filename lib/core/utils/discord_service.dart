import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../theme/settings_provider.dart';
import '../../features/inventory/domain/vinted_article.dart';

part 'discord_service.g.dart';

@riverpod
class DiscordService extends _$DiscordService {
  @override
  void build() {}

  Future<bool> _sendRaw(Map<String, dynamic> payload, {File? imageFile}) async {
    final settings = await ref.read(appSettingsProvider.future);
    final enabled = settings['discordEnabled'] as bool? ?? false;
    final webhookUrl = settings['discordWebhookUrl'] as String?;
    final botName = settings['discordBotName'] as String? ?? 'Empire Pro Bot';
    final botAvatar = settings['discordBotAvatar'] as String?;

    if (!enabled || webhookUrl == null || webhookUrl.isEmpty) {
      return false;
    }

    final fullPayload = {
      ...payload,
      'username': botName,
      if (botAvatar != null && botAvatar.isNotEmpty) 'avatar_url': botAvatar,
    };

    try {
      if (imageFile != null && await imageFile.exists()) {
        final request = http.MultipartRequest('POST', Uri.parse(webhookUrl));
        request.fields['payload_json'] = jsonEncode(fullPayload);
        
        final stream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();
        
        final multipartFile = http.MultipartFile(
          'file',
          stream,
          length,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        
        request.files.add(multipartFile);
        final response = await request.send();
        return response.statusCode >= 200 && response.statusCode < 300;
      } else {
        final response = await http.post(
          Uri.parse(webhookUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(fullPayload),
        );
        return response.statusCode >= 200 && response.statusCode < 300;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendMessage(String content) async => _sendRaw({'content': content});

  Future<bool> sendArticleNotification({
    required VintedArticle article,
    bool isUpdate = false,
  }) async {
    final settings = await ref.read(appSettingsProvider.future);
    final enabled = settings['discordEnabled'] as bool? ?? false;
    if (!enabled) return false;

    final titlePrefix = isUpdate ? '🔄 Article mis à jour' : '📦 Nouvel article ajouté';
    
    File? imageToUpload;
    if (article.photoPaths.isNotEmpty) {
      final file = File(article.photoPaths.first);
      if (await file.exists()) {
        imageToUpload = file;
      }
    }

    final embed = {
      'title': '$titlePrefix : ${article.title}',
      'color': isUpdate ? 0xFFAA00 : 0x00B5B5,
      'fields': [
        {'name': '🏷️ Marque', 'value': article.brand.isEmpty ? '-' : article.brand, 'inline': true},
        {'name': '📁 Catégorie', 'value': article.category.isEmpty ? '-' : article.category, 'inline': true},
        {'name': '✨ État', 'value': article.condition, 'inline': true},
        {'name': '🏪 Marché', 'value': article.market, 'inline': true},
        {'name': '📍 Emplacement', 'value': article.location.isEmpty ? '-' : article.location, 'inline': true},
        {'name': '📊 Statut', 'value': article.status, 'inline': true},
        
        {'name': '💰 FINANCES', 'value': '---', 'inline': false},
        {'name': '🏷️ Prix Vente', 'value': '${article.sellingPrice}€', 'inline': true},
        {'name': '📉 Prix Achat', 'value': '${article.purchasePrice}€', 'inline': true},
        {'name': '🚚 Frais Port', 'value': '${article.shippingCost}€', 'inline': true},
        {'name': '🏛️ Frais Plateforme', 'value': '${article.platformFees}€', 'inline': true},
        {'name': '🧼 Nettoyage', 'value': '${article.cleaningCost}€', 'inline': true},
        {'name': '🛠️ Réparation', 'value': '${article.repairCost}€', 'inline': true},
        {'name': '📦 Emballage', 'value': '${article.packagingCost}€', 'inline': true},
        {'name': '💎 PROFIT NET', 'value': '**${article.netProfit.toStringAsFixed(2)}€**', 'inline': true},

        {'name': '📝 LOGISTIQUE', 'value': '---', 'inline': false},
        {'name': '🔢 Code Barre', 'value': article.barcode.isEmpty ? '-' : article.barcode, 'inline': true},
        {'name': '📦 Suivi', 'value': article.trackingNumber.isEmpty ? '-' : article.trackingNumber, 'inline': true},
        {'name': '📓 Notes', 'value': article.notes.isEmpty ? '-' : article.notes, 'inline': false},
        {'name': '📖 Description', 'value': article.description.isEmpty ? '-' : article.description, 'inline': false},
      ],
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (imageToUpload != null) {
      embed['image'] = {'url': 'attachment://image.jpg'};
    }

    return _sendRaw({'embeds': [embed]}, imageFile: imageToUpload);
  }

  Future<bool> sendTestMessage() async {
    return sendMessage('🧪 Test du Webhook Empire Pro réussi ! Votre bot est correctement configuré.');
  }

  Future<bool> sendSaleNotification({
    required String title,
    required double profit,
    required double salePrice,
  }) async {
    final settings = await ref.read(appSettingsProvider.future);
    if (!(settings['discordNotifySales'] as bool? ?? true)) return false;

    final embed = {
      'title': '💰 VENDU !',
      'color': 0x00FF00,
      'fields': [
        {'name': 'Article', 'value': title, 'inline': false},
        {'name': 'Prix de vente', 'value': '${salePrice}€', 'inline': true},
        {'name': 'Bénéfice Net', 'value': '${profit.toStringAsFixed(2)}€', 'inline': true},
      ],
      'timestamp': DateTime.now().toIso8601String(),
    };
    return _sendRaw({'embeds': [embed]});
  }

  Future<bool> sendFiscalAlert({required double totalSales, required double limit}) async {
    final settings = await ref.read(appSettingsProvider.future);
    if (!(settings['discordNotifyFiscal'] as bool? ?? true)) return false;

    final progress = (totalSales / limit * 100).toInt();
    final embed = {
      'title': '⚠️ Alerte Seuil Fiscal',
      'color': 0xFFAA00,
      'description': 'Vous approchez du seuil fiscal annuel.',
      'fields': [
        {'name': 'Total Ventes', 'value': '${totalSales.toInt()}€ / ${limit.toInt()}€', 'inline': true},
        {'name': 'Progression', 'value': '$progress%', 'inline': true},
      ],
      'timestamp': DateTime.now().toIso8601String(),
    };
    return _sendRaw({'embeds': [embed]});
  }

  Future<bool> sendSyncNotification({required String deviceName, required int count}) async {
    final settings = await ref.read(appSettingsProvider.future);
    if (!(settings['discordNotifySync'] as bool? ?? true)) return false;

    final embed = {
      'title': '🔄 Synchronisation Réussie',
      'color': 0x00AAFF,
      'description': 'Données synchronisées avec succès.',
      'fields': [
        {'name': 'Appareil', 'value': deviceName, 'inline': true},
        {'name': 'Articles mis à jour', 'value': '$count', 'inline': true},
      ],
      'timestamp': DateTime.now().toIso8601String(),
    };
    return _sendRaw({'embeds': [embed]});
  }

  Future<bool> sendDailyReport({
    required int articlesAdded,
    required double totalSales,
    required double totalProfit,
    required String bestMarket,
  }) async {
    final embed = {
      'title': '📊 Rapport Journalier Empire Pro',
      'color': 0x5865F2,
      'fields': [
        {'name': 'Articles ajoutés', 'value': '$articlesAdded', 'inline': true},
        {'name': 'Ventes du jour', 'value': '${totalSales.toStringAsFixed(2)}€', 'inline': true},
        {'name': 'Profit du jour', 'value': '${totalProfit.toStringAsFixed(2)}€', 'inline': true},
        {'name': 'Top Marché', 'value': bestMarket, 'inline': false},
      ],
      'timestamp': DateTime.now().toIso8601String(),
    };
    return _sendRaw({'embeds': [embed]});
  }
}
