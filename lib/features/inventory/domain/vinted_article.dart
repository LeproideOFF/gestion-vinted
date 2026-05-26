import 'package:isar/isar.dart';

part 'vinted_article.g.dart';

@collection
class VintedArticle {
  Id? id;

  @Index(unique: true, replace: true)
  late String uuid;

  String title = '';
  String description = '';
  String category = ''; 
  String brand = '';    
  String size = '';     
  String condition = 'Bon état';
  
  double purchasePrice = 0.0; 
  double sellingPrice = 0.0; 
  double shippingCost = 0.0; 
  double platformFees = 0.0; 
  double cleaningCost = 0.0;
  double repairCost = 0.0;
  double packagingCost = 0.0; 

  List<String> photoPaths = [];
  String status = 'A vendre';
  late DateTime updatedAt;
  late DateTime createdAt;
  
  bool isFavorite = false;
  String notes = '';
  String location = ''; 
  String barcode = ''; 
  String trackingNumber = ''; 
  String market = 'Vinted';

  VintedArticle({
    this.id,
    required this.uuid,
    required this.title,
    required this.description,
    this.category = '',
    this.brand = '',
    this.size = '',
    this.condition = 'Bon état',
    this.purchasePrice = 0.0,
    this.sellingPrice = 0.0,
    this.shippingCost = 0.0,
    this.platformFees = 0.0,
    this.cleaningCost = 0.0,
    this.repairCost = 0.0,
    this.packagingCost = 0.0,
    this.status = 'A vendre',
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
      uuid: json['uuid'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      size: json['size'] ?? '',
      condition: json['condition'] ?? 'Bon état',
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      platformFees: (json['platformFees'] as num?)?.toDouble() ?? 0.0,
      cleaningCost: (json['cleaningCost'] as num?)?.toDouble() ?? 0.0,
      repairCost: (json['repairCost'] as num?)?.toDouble() ?? 0.0,
      packagingCost: (json['packagingCost'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'A vendre',
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? json['updatedAt'] ?? DateTime.now().toIso8601String()),
      photoPaths: List<String>.from(json['photoPaths'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
      notes: json['notes'] ?? '',
      location: json['location'] ?? '',
      barcode: json['barcode'] ?? '',
      trackingNumber: json['trackingNumber'] ?? '',
      market: json['market'] ?? 'Vinted',
    );
  }
}
