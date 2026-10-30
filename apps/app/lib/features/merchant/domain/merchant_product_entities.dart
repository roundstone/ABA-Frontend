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
    this.categoryId,
    this.subcategoryId,
    this.brandId,
    this.brandName,
    this.merchantId,
    required this.price,
    required this.costPrice,
    required this.stock,
    this.lowStockThreshold = 5,
    this.baseUnitOfMeasurement = 'piece',
    this.type = 1,
    this.reorderLevel = 10,
    this.reorderQuantity = 25,
    this.imageUrl = '',
    this.productImages = const [],
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
  final int? categoryId;
  final int? subcategoryId;
  final int? brandId;
  final String? brandName;
  final int? merchantId;
  int? get vendorId => merchantId;
  final double price;
  final double costPrice;
  final int stock;
  final int lowStockThreshold;
  final String baseUnitOfMeasurement;
  final int type;
  final int reorderLevel;
  final int reorderQuantity;
  final String imageUrl;
  final List<String> productImages;
  final String description;
  final MerchantProductStatus status;
  final bool isCommissionable;
  final int soldCount;
  final DateTime updatedAt;

  bool get isOutOfStock => stock <= 0;
  bool get isLowStock => stock > 0 && stock <= lowStockThreshold;
  bool get isInStock => stock > lowStockThreshold;
  bool get isActive => status == MerchantProductStatus.active;

  double get marginPercentage {
    if (price <= 0) return 0;
    return ((price - costPrice) / price) * 100;
  }

  /// Converts this entity into the exact request body required by `POST /api/v1/products`
  Map<String, dynamic> toCreatePayload() {
    final imgs = productImages.isNotEmpty
        ? productImages
        : (imageUrl.trim().isNotEmpty
            ? [imageUrl.trim()]
            : <String>[
                'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=600&q=80',
              ]);

    return {
      if (categoryId != null) 'categoryId': categoryId,
      if (subcategoryId != null) 'subcategoryId': subcategoryId,
      'name': name.trim(),
      if (description.trim().isNotEmpty) 'description': description.trim(),
      if (brandId != null) 'brandId': brandId,
      'baseCostPrice': costPrice.toStringAsFixed(2),
      'baseSellingPrice': price.toStringAsFixed(2),
      'baseUnitOfMeasurement': baseUnitOfMeasurement.isNotEmpty ? baseUnitOfMeasurement : 'piece',
      'type': type,
      'reorderLevel': reorderLevel,
      'reorderQuantity': reorderQuantity,
      'isActive': status == MerchantProductStatus.active,
      'productImages': imgs,
    };
  }

  factory MerchantProduct.fromJson(Map<String, dynamic> json) {
    final rawSelling = json['base_selling_price'] ?? json['baseSellingPrice'] ?? json['price'];
    final parsedSelling = rawSelling != null ? double.tryParse(rawSelling.toString()) ?? 0.0 : 0.0;

    final rawCost = json['base_cost_price'] ?? json['baseCostPrice'] ?? json['costPrice'] ?? json['cost_price'];
    final parsedCost = rawCost != null ? double.tryParse(rawCost.toString()) ?? 0.0 : 0.0;

    final catId = (json['category_id'] as num?)?.toInt() ?? (json['categoryId'] as num?)?.toInt();
    final subCatId = (json['subcategory_id'] as num?)?.toInt() ?? (json['subcategoryId'] as num?)?.toInt();
    final bId = (json['brand_id'] as num?)?.toInt() ?? (json['brandId'] as num?)?.toInt();
    final mId = (json['merchant_id'] as num?)?.toInt() ??
        (json['merchantId'] as num?)?.toInt() ??
        (json['vendor_id'] as num?)?.toInt() ??
        (json['vendorId'] as num?)?.toInt();

    final catName = json['category'] is Map
        ? (json['category']['name'] as String? ?? 'General')
        : (json['category'] as String? ?? (catId != null ? 'Category $catId' : 'General'));

    final bName = json['brand'] is Map
        ? (json['brand']['name'] as String?)
        : (json['brand'] as String? ?? json['brandName'] as String?);

    final rawImages = json['productImages'] ?? json['images'] ?? json['product_images'];
    final imgs = <String>[];
    if (rawImages is List) {
      for (final it in rawImages) {
        if (it is String && it.trim().isNotEmpty) imgs.add(it.trim());
        if (it is Map) {
          final u = it['url'] ?? it['image_url'] ?? it['path'];
          if (u != null && u.toString().trim().isNotEmpty) imgs.add(u.toString().trim());
        }
      }
    }
    final singleImg = json['imageUrl'] ?? json['image_url'];
    if (singleImg != null && singleImg.toString().trim().isNotEmpty && !imgs.contains(singleImg.toString().trim())) {
      imgs.insert(0, singleImg.toString().trim());
    }

    final idStr = json['id']?.toString() ?? '';
    final skuStr = json['sku'] as String? ?? (idStr.isNotEmpty ? 'ABA-$idStr' : 'ABA-001');

    final bool isAct = json['isActive'] as bool? ??
        json['is_active'] as bool? ??
        (json['status']?.toString().toLowerCase() != 'draft');

    final rawType = (json['type'] as num?)?.toInt() ?? 1;
    final rLevel = (json['reorder_level'] as num?)?.toInt() ?? (json['reorderLevel'] as num?)?.toInt() ?? 10;
    final rQty = (json['reorder_quantity'] as num?)?.toInt() ?? (json['reorderQuantity'] as num?)?.toInt() ?? 25;
    final parsedStock = (json['stock'] as num?)?.toInt() ?? (json['totalStock'] as num?)?.toInt() ?? rQty;

    return MerchantProduct(
      id: idStr,
      name: json['name'] as String? ?? '',
      sku: skuStr,
      category: catName,
      categoryId: catId,
      subcategoryId: subCatId,
      brandId: bId,
      brandName: bName,
      merchantId: mId,
      price: parsedSelling,
      costPrice: parsedCost,
      stock: parsedStock,
      lowStockThreshold: rLevel,
      baseUnitOfMeasurement: json['base_unit_of_measurement'] as String? ?? json['baseUnitOfMeasurement'] as String? ?? 'piece',
      type: rawType,
      reorderLevel: rLevel,
      reorderQuantity: rQty,
      imageUrl: imgs.isNotEmpty ? imgs.first : (singleImg?.toString() ?? ''),
      productImages: imgs,
      description: json['description'] as String? ?? '',
      status: isAct ? MerchantProductStatus.active : MerchantProductStatus.draft,
      isCommissionable: json['isCommissionable'] as bool? ?? true,
      soldCount: (json['soldCount'] as num?)?.toInt() ?? (json['review_count'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  MerchantProduct copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    int? categoryId,
    int? subcategoryId,
    int? brandId,
    String? brandName,
    int? merchantId,
    double? price,
    double? costPrice,
    int? stock,
    int? lowStockThreshold,
    String? baseUnitOfMeasurement,
    int? type,
    int? reorderLevel,
    int? reorderQuantity,
    String? imageUrl,
    List<String>? productImages,
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
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      merchantId: merchantId ?? this.merchantId,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      baseUnitOfMeasurement: baseUnitOfMeasurement ?? this.baseUnitOfMeasurement,
      type: type ?? this.type,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      reorderQuantity: reorderQuantity ?? this.reorderQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      productImages: productImages ?? this.productImages,
      description: description ?? this.description,
      status: status ?? this.status,
      isCommissionable: isCommissionable ?? this.isCommissionable,
      soldCount: soldCount ?? this.soldCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
