import 'product_variant.dart';
import 'shop_category.dart';

// Curated commerce placeholder images when backend does not provide images
const List<String> _kDefaultProductImages = [
  'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
  'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600',
  'https://images.unsplash.com/photo-1623205863604-d62a5b56f1c4?w=600',
  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
  'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600',
  'https://images.unsplash.com/photo-1509695503492-413bc5d0fee6?w=600',
];

/// Domain entity representing a product in the ABA ERP store.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.category,
    required this.brand,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.images,
    this.description,
    this.discount,
    this.colors,
    this.sizes,
    this.tags,
    this.isFeatured = false,
    this.isNew = false,
    this.categoryId,
    this.brandId,
    this.vendorId,
    this.baseCostPrice,
    this.baseSellingPrice,
    this.baseUnitOfMeasurement,
    this.type,
    this.reorderLevel,
    this.reorderQuantity,
    this.isActive = true,
    this.categoryObj,
    this.variants = const [],
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String name;
  final String slug;
  final double price;
  final String category;
  final String brand;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> images;
  final String? description;
  final double? discount;
  final List<String>? colors;
  final List<String>? sizes;
  final List<String>? tags;
  final bool isFeatured;
  final bool isNew;

  // ERP backend properties
  final int? categoryId;
  final int? brandId;
  final int? vendorId;
  final double? baseCostPrice;
  final double? baseSellingPrice;
  final String? baseUnitOfMeasurement;
  final int? type;
  final int? reorderLevel;
  final int? reorderQuantity;
  final bool isActive;
  final ShopCategory? categoryObj;
  final List<ProductVariant> variants;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  String get imageUrl => images.isNotEmpty ? images.first : '';

  double get discountedPrice =>
      discount != null ? price * (1 - discount! / 100) : price;

  bool get hasDiscount => discount != null && discount! > 0;

  bool get inStock => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSellingPrice = json['base_selling_price'] ?? json['price'];
    final parsedSellingPrice = rawSellingPrice != null
        ? double.tryParse(rawSellingPrice.toString()) ?? 0.0
        : 0.0;

    final rawCostPrice = json['base_cost_price'] ?? json['cost_price'];
    final parsedCostPrice = rawCostPrice != null
        ? double.tryParse(rawCostPrice.toString())
        : null;

    final catId = (json['category_id'] as num?)?.toInt() ??
        (json['categoryId'] as num?)?.toInt();

    ShopCategory? parsedCategoryObj;
    if (json['category'] is Map) {
      parsedCategoryObj = ShopCategory.fromJson(
        Map<String, dynamic>.from(json['category'] as Map),
      );
    }

    final catName = parsedCategoryObj?.name ??
        (json['category'] is String
            ? json['category'] as String
            : (catId != null ? 'Category $catId' : 'General'));

    final bId = (json['brand_id'] as num?)?.toInt() ??
        (json['brandId'] as num?)?.toInt();
    final brandName = json['brand'] as String? ??
        (bId != null ? 'Brand $bId' : 'BuyNaija');

    final vId = (json['vendor_id'] as num?)?.toInt() ??
        (json['vendorId'] as num?)?.toInt();

    final parsedVariants = (json['variants'] as List<dynamic>?)
            ?.whereType<Map>()
            .map((v) => ProductVariant.fromJson(Map<String, dynamic>.from(v)))
            .toList() ??
        const <ProductVariant>[];

    final colorsList = <String>{};
    final sizesList = <String>{};
    for (final v in parsedVariants) {
      if (v.color != null && v.color!.isNotEmpty) colorsList.add(v.color!);
      if (v.size != null && v.size!.isNotEmpty) sizesList.add(v.size!);
    }
    if (json['colors'] is List) {
      colorsList.addAll((json['colors'] as List).map((e) => e.toString()));
    }
    if (json['sizes'] is List) {
      sizesList.addAll((json['sizes'] as List).map((e) => e.toString()));
    }

    List<String> imagesList = [];
    if (json['images'] is List) {
      imagesList = (json['images'] as List).map((e) => e.toString()).toList();
    } else if (json['image_url'] != null && json['image_url'].toString().isNotEmpty) {
      imagesList = [json['image_url'].toString()];
    }

    final prodId = (json['id'] as num?)?.toInt() ??
        int.tryParse(json['id']?.toString() ?? '') ??
        0;

    if (imagesList.isEmpty) {
      final imgIndex = (prodId.abs()) % _kDefaultProductImages.length;
      imagesList = [_kDefaultProductImages[imgIndex]];
    }

    final reorderQty = (json['reorder_quantity'] as num?)?.toInt();
    final stockVal = (json['stock'] as num?)?.toInt() ?? reorderQty ?? 20;

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      price: parsedSellingPrice,
      category: catName,
      brand: brandName,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (json['review_count'] as num?)?.toInt() ??
          (json['reviewCount'] as num?)?.toInt() ??
          12,
      stock: stockVal,
      images: imagesList,
      description: json['description'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      colors: colorsList.isNotEmpty ? colorsList.toList() : null,
      sizes: sizesList.isNotEmpty ? sizesList.toList() : null,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      isFeatured: json['is_featured'] as bool? ??
          (json['isFeatured'] as bool? ?? false),
      isNew: json['is_new'] as bool? ?? (json['isNew'] as bool? ?? false),
      categoryId: catId,
      brandId: bId,
      vendorId: vId,
      baseCostPrice: parsedCostPrice,
      baseSellingPrice: parsedSellingPrice,
      baseUnitOfMeasurement: json['base_unit_of_measurement'] as String?,
      type: (json['type'] as num?)?.toInt(),
      reorderLevel: (json['reorder_level'] as num?)?.toInt(),
      reorderQuantity: reorderQty,
      isActive: json['is_active'] as bool? ??
          (json['isActive'] as bool? ?? true),
      categoryObj: parsedCategoryObj,
      variants: parsedVariants,
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
        'name': name,
        'slug': slug,
        'base_selling_price': price.toStringAsFixed(2),
        if (baseCostPrice != null)
          'base_cost_price': baseCostPrice!.toStringAsFixed(2),
        if (categoryId != null) 'category_id': categoryId,
        'category': category,
        if (brandId != null) 'brand_id': brandId,
        'brand': brand,
        if (vendorId != null) 'vendor_id': vendorId,
        'rating': rating,
        'review_count': reviewCount,
        'stock': stock,
        'images': images,
        if (description != null) 'description': description,
        if (discount != null) 'discount': discount,
        if (colors != null) 'colors': colors,
        if (sizes != null) 'sizes': sizes,
        if (tags != null) 'tags': tags,
        'is_featured': isFeatured,
        'is_new': isNew,
        'is_active': isActive,
        'variants': variants.map((v) => v.toJson()).toList(),
      };
}
