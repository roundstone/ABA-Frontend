// Domain entity for ProductVariant matching backend /api/v1/products variants schema.

class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    required this.sku,
    this.barcode,
    required this.price,
    this.costPrice,
    this.variantCostPrice,
    this.variantSellingPrice,
    this.weight,
    this.attributes = const {},
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final int id;
  final int productId;
  final String name;
  final String sku;
  final String? barcode;
  final double price;
  final double? costPrice;
  final double? variantCostPrice;
  final double? variantSellingPrice;
  final double? weight;
  final Map<String, dynamic> attributes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  String? get color => attributes['color'] as String?;
  String? get size => attributes['size'] as String?;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'] ?? json['variant_selling_price'];
    final parsedPrice = rawPrice != null
        ? double.tryParse(rawPrice.toString()) ?? 0.0
        : 0.0;

    final rawCost = json['cost_price'] ?? json['variant_cost_price'];
    final parsedCost = rawCost != null
        ? double.tryParse(rawCost.toString())
        : null;

    final rawSellingPrice = json['variant_selling_price'];
    final parsedSellingPrice = rawSellingPrice != null
        ? double.tryParse(rawSellingPrice.toString())
        : null;

    final rawWeight = json['weight'];
    final parsedWeight = rawWeight != null
        ? double.tryParse(rawWeight.toString())
        : null;

    return ProductVariant(
      id: (json['id'] as num?)?.toInt() ?? 0,
      productId: (json['product_id'] as num?)?.toInt() ??
          (json['productId'] as num?)?.toInt() ??
          0,
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      barcode: json['barcode'] as String?,
      price: parsedPrice,
      costPrice: parsedCost,
      variantCostPrice: parsedCost,
      variantSellingPrice: parsedSellingPrice,
      weight: parsedWeight,
      attributes: json['attributes'] is Map
          ? Map<String, dynamic>.from(json['attributes'] as Map)
          : const {},
      isActive: json['is_active'] as bool? ?? (json['isActive'] as bool? ?? true),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'name': name,
        'sku': sku,
        'barcode': barcode,
        'price': price.toStringAsFixed(2),
        'cost_price': costPrice?.toStringAsFixed(2),
        'variant_cost_price': variantCostPrice?.toStringAsFixed(2),
        'variant_selling_price': variantSellingPrice?.toStringAsFixed(2),
        'weight': weight,
        'attributes': attributes,
        'is_active': isActive,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
      };
}
