import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/isar_service.dart';
import '../domain/market_config.dart';

part 'market_provider.g.dart';

@Riverpod(keepAlive: true)
class MarketNotifier extends _$MarketNotifier {
  @override
  FutureOr<List<MarketConfig>> build() async {
    final isar = ref.read(isarServiceProvider);
    // On s'assure d'avoir Vinted et Leboncoin par défaut
    final markets = await isar.db.then((db) => db.marketConfigs.where().findAll());
    
    if (markets.isEmpty) {
      final defaultMarkets = [
        MarketConfig(name: 'Vinted', colorValue: const Color(0xFF00B5B5).value, isCustom: false),
        MarketConfig(name: 'Leboncoin', colorValue: const Color(0xFFFF6E14).value, isCustom: false),
      ];
      for (var m in defaultMarkets) {
        await isar.db.then((db) => db.writeTxn(() => db.marketConfigs.put(m)));
      }
      return defaultMarkets;
    }
    return markets;
  }

  Future<void> addMarket(String name, Color color) async {
    final isar = ref.read(isarServiceProvider);
    final config = MarketConfig(name: name, colorValue: color.value);
    await isar.db.then((db) => db.writeTxn(() => db.marketConfigs.put(config)));
    ref.invalidateSelf();
  }

  Future<void> deleteMarket(int id) async {
    final isar = ref.read(isarServiceProvider);
    await isar.db.then((db) => db.writeTxn(() => db.marketConfigs.delete(id)));
    ref.invalidateSelf();
  }
}

final selectedMarketProvider = StateProvider<String>((ref) => 'Vinted');
