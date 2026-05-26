import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/inventory/data/isar_service.dart';
import '../../features/inventory/presentation/inventory_provider.dart';
import 'settings_config.dart';
import 'package:isar/isar.dart';

part 'settings_provider.g.dart';

enum GlassTheme { frost, deepOcean, royalGold, cyberNeon, leboncoin }

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  @override
  FutureOr<Map<String, dynamic>> build() async {
    final isar = ref.watch(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst();

    if (settings == null) {
      final defaultSettings = SettingsConfig();
      await db.writeTxn(() => db.settingsConfigs.put(defaultSettings));
      return {
        'theme': GlassTheme.frost,
        'market': 'Vinted',
        'useBiometrics': true,
        'discordEnabled': false,
        'discordWebhookUrl': null,
        'discordBotName': 'Empire Pro Bot',
        'discordBotAvatar': null,
        'discordNotifySales': true,
        'discordNotifyFiscal': true,
        'discordNotifySync': true,
        'discordDailyReport': false,
      };
    }

    return {
      'theme': GlassTheme.values.firstWhere((e) => e.name == settings.theme, orElse: () => GlassTheme.frost),
      'market': settings.defaultMarket,
      'useBiometrics': settings.useBiometrics,
      'discordEnabled': settings.discordEnabled,
      'discordWebhookUrl': settings.discordWebhookUrl,
      'discordBotName': settings.discordBotName,
      'discordBotAvatar': settings.discordBotAvatar,
      'discordNotifySales': settings.discordNotifySales,
      'discordNotifyFiscal': settings.discordNotifyFiscal,
      'discordNotifySync': settings.discordNotifySync,
      'discordDailyReport': settings.discordDailyReport,
    };
  }

  Future<void> setTheme(GlassTheme theme) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.theme = theme.name;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setBiometrics(bool value) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.useBiometrics = value;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordEnabled(bool value) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordEnabled = value;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordWebhookUrl(String? url) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordWebhookUrl = url;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordBotName(String name) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordBotName = name;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordBotAvatar(String? url) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordBotAvatar = url;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordNotifySales(bool value) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordNotifySales = value;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordNotifyFiscal(bool value) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordNotifyFiscal = value;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordNotifySync(bool value) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordNotifySync = value;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setDiscordDailyReport(bool value) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.discordDailyReport = value;
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }

  Future<void> setMarket(String market) async {
    final isar = ref.read(isarServiceProvider);
    final db = await isar.db;
    final settings = await db.settingsConfigs.where().findFirst() ?? SettingsConfig();
    settings.defaultMarket = market;
    
    if (market == 'Leboncoin') {
      settings.theme = GlassTheme.leboncoin.name;
    } else {
      settings.theme = GlassTheme.frost.name;
    }
    
    await db.writeTxn(() => db.settingsConfigs.put(settings));
    ref.invalidateSelf();
  }
}

class ThemeColors {
  static Color getPrimary(GlassTheme theme) {
    switch (theme) {
      case GlassTheme.deepOcean: return const Color(0xFF0050FF);
      case GlassTheme.royalGold: return const Color(0xFFFFD700);
      case GlassTheme.cyberNeon: return const Color(0xFFFF00FF);
      case GlassTheme.leboncoin: return const Color(0xFFFF6E14);
      default: return const Color(0xFF00B5B5);
    }
  }

  static List<Color> getGradient(GlassTheme theme, bool isDark) {
    final primary = getPrimary(theme);
    return [primary.withOpacity(0.15), isDark ? Colors.black : Colors.white];
  }
}
