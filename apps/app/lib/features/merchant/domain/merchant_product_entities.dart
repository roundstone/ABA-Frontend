// Domain entities for Merchant Product & Inventory Management.

enum MerchantProductStatus {
  active('Active'),
  draft('Draft'),
  archived('Archived');

  const MerchantProductStatus(this.label);
  final String label;

  static MerchantProductStatus fromString(String? value) {
    if (value == null) return MerchantProductStatus.active;
    final normalized = value.toLowerCase().trim();
    if (normalized == 'draft') return MerchantProductStatus.draft;
    if (normalized == 'archived') return MerchantProductStatus.archived;
    return MerchantProductStatus.active;
  }
}

class MerchantProduct {
  const MerchantProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.price,
    required this.costPrice,
    required this.stock,
    this.lowStockThreshold = 5,
    this.imageUrl = '',
    this.description = '',
    this.status = MerchantProductStatus.active,
    this.isCommissionable = true,
    this.soldCount = 0,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String sku;
  final String category;
  final double price;
  final double costPrice;
  final int stock;
  final int lowStockThreshold;
  final String imageUrl;
  final String description;
  final MerchantProductStatus status;
  final bool isCommissionable;
  final int soldCount;
  final DateTime updatedAt;

  bool get isOutOfStock => stock <= 0;
  bool get isLowStock => stock > 0 && stock <= lowStockThreshold;
  bool get isInStock => stock > lowStockThreshold;

  double get marginPercentage {
    if (price <= 0) return 0;
    return ((price - costPrice) / price) * 100;
  }

  MerchantProduct copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    double? price,
    double? costPrice,
    int? stock,
    int? lowStockThreshold,
    String? imageUrl,
    String? description,
    MerchantProductStatus? status,
    bool? isCommissionable,
    int? soldCount,
    DateTime? updatedAt,
  }) {
    return MerchantProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      status: status ?? this.status,
      isCommissionable: isCommissionable ?? this.isCommissionable,
      soldCount: soldCount ?? this.soldCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
