import 'package:isar/isar.dart';

part 'settings_config.g.dart';

@collection
class SettingsConfig {
  Id? id;

  late String theme; // frost, deepOcean, royalGold, cyberNeon, leboncoin
  late bool useBiometrics;
  late String defaultMarket;
  late bool discordEnabled;
  late String? discordWebhookUrl;
  late String? discordBotName;
  late String? discordBotAvatar;
  late bool discordNotifySales;
  late bool discordNotifyFiscal;
  late bool discordNotifySync;
  late bool discordDailyReport;

  SettingsConfig({
    this.id,
    this.theme = 'frost',
    this.useBiometrics = true,
    this.defaultMarket = 'Vinted',
    this.discordEnabled = false,
    this.discordWebhookUrl,
    this.discordBotName = 'Empire Pro Bot',
    this.discordBotAvatar,
    this.discordNotifySales = true,
    this.discordNotifyFiscal = true,
    this.discordNotifySync = true,
    this.discordDailyReport = false,
  });
}
