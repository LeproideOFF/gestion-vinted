import 'package:isar/isar.dart';

part 'market_config.g.dart';

@collection
class MarketConfig {
  Id? id;

  @Index(unique: true, replace: true)
  late String name; // Vinted, Leboncoin, etc.
  
  late int colorValue; // Couleur personnalisée
  late bool isCustom; // Pour savoir si c'est un marché par défaut

  MarketConfig({
    this.id,
    required this.name,
    required this.colorValue,
    this.isCustom = true,
  });
}
