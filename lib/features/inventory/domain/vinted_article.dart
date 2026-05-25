import 'package:isar/isar.dart';

part 'vinted_article.g.dart';

@collection
class VintedArticle {
  Id? id;

  @Index(unique: true, replace: true)
  late String uuid;

  late String title;
  late String description;
  late String category; 
  late String brand;    
  late String size;     
  late String condition;
  
  late double purchasePrice; 
  late double sellingPrice; 
  late double shippingCost; 
  late double platformFees; 
  late double cleaningCost;
  late double repairCost;
  late double packagingCost; 

  List<String> photoPaths = [];
  late String status;
  late DateTime updatedAt;
  late DateTime createdAt;
  
  bool isFavorite = false;
  late String notes;
  late String location; 
  late String barcode; 
  late String trackingNumber; 
  late String market; // Vinted, Leboncoin, eBay...

  VintedArticle({
    this.id,
    required this.uuid,
    required this.title,
    required this.description,
    this.category = '',
    this.brand = '',
    this.size = '',
    this.condition = 'Bon état',
    required this.purchasePrice,
    required this.sellingPrice,
    this.shippingCost = 0.0,
    this.platformFees = 0.0,
    this.cleaningCost = 0.0,
    this.repairCost = 0.0,
    this.packagingCost = 0.0,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    this.photoPaths = const [],
    this.isFavorite = false,
    this.notes = '',
    this.location = '',
    this.barcode = '',
    this.trackingNumber = '',
    this.market = 'Vinted',
  });

  double get totalPurchaseCost => purchasePrice + shippingCost + platformFees + cleaningCost + repairCost + packagingCost;
  double get netProfit => sellingPrice - totalPurchaseCost;
  double get ROI => totalPurchaseCost > 0 ? (netProfit / totalPurchaseCost) * 100 : 0.0;

  // Logique de fusion pour la synchronisation
  VintedArticle merge(VintedArticle other) {
    if (other.updatedAt.isAfter(updatedAt)) {
      return other;
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'description': description,
      'category': category,
      'brand': brand,
      'size': size,
      'condition': condition,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'shippingCost': shippingCost,
      'platformFees': platformFees,
      'cleaningCost': cleaningCost,
      'repairCost': repairCost,
      'packagingCost': packagingCost,
      'status': status,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'photoPaths': photoPaths,
      'isFavorite': isFavorite,
      'notes': notes,
      'location': location,
      'barcode': barcode,
      'trackingNumber': trackingNumber,
      'market': market,
    };
  }

  factory VintedArticle.fromJson(Map<String, dynamic> json) {
    return VintedArticle(
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      size: json['size'] ?? '',
      condition: json['condition'] ?? 'Bon état',
      purchasePrice: json['purchasePrice'] ?? 0.0,
      sellingPrice: json['sellingPrice'] ?? 0.0,
      shippingCost: json['shippingCost'] ?? 0.0,
      platformFees: json['platformFees'] ?? 0.0,
      cleaningCost: json['cleaningCost'] ?? 0.0,
      repairCost: json['repairCost'] ?? 0.0,
      packagingCost: json['packagingCost'] ?? 0.0,
      status: json['status'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt'] ?? json['updatedAt']),
      photoPaths: List<String>.from(json['photoPaths']),
      isFavorite: json['isFavorite'] ?? false,
      notes: json['notes'] ?? '',
      location: json['location'] ?? '',
      barcode: json['barcode'] ?? '',
      trackingNumber: json['trackingNumber'] ?? '',
      market: json['market'] ?? 'Vinted',
    );
  }
}
