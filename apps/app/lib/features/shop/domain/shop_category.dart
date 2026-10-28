/// Domain entity representing a product category in the ABA ERP marketplace.
class ShopCategory {
  const ShopCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    this.parentCategory,
    this.imageUrl,
    this.productCount = 0,
    this.children = const [],
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String name;
  final String slug;
  final String? parentId;
  final ShopCategory? parentCategory;
  final String? imageUrl;
  final int productCount;
  final List<ShopCategory> children;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  bool get hasChildren => children.isNotEmpty;

  /// Returns true if this category or any of its subcategories matches [identifier].
  bool matches(String? identifier) {
    if (identifier == null || identifier.isEmpty) return false;
    final lower = identifier.toLowerCase().trim();
    if (id == identifier ||
        slug.toLowerCase() == lower ||
        name.toLowerCase() == lower) {
      return true;
    }
    return children.any((c) => c.matches(identifier));
  }

  factory ShopCategory.fromJson(Map<String, dynamic> json) {
    final rawSubs = json['subcategories'] ?? json['children'];
    final rawCount = json['productCount'] ?? json['product_count'];
    final parsedCount = (rawCount is num)
        ? rawCount.toInt()
        : int.tryParse(rawCount?.toString() ?? '0') ?? 0;

    final parentCat = json['category'] is Map
        ? ShopCategory.fromJson(Map<String, dynamic>.from(json['category'] as Map))
        : null;

    final parsedParentId = json['category_id']?.toString() ??
        json['categoryId']?.toString() ??
        parentCat?.id ??
        json['parent_id']?.toString() ??
        json['parentId']?.toString();

    return ShopCategory(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      parentId: parsedParentId,
      parentCategory: parentCat,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      productCount: parsedCount,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'].toString())
          : null,
      children: (rawSubs as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => ShopCategory.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    if (description != null) 'description': description,
    'is_active': isActive,
    if (parentId != null) 'category_id': int.tryParse(parentId!) ?? parentId,
    if (parentCategory != null) 'category': parentCategory!.toJson(),
    if (imageUrl != null) 'image_url': imageUrl,
    'product_count': productCount,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    if (deletedAt != null) 'deletedAt': deletedAt!.toIso8601String(),
    if (children.isNotEmpty)
      'children': children.map((c) => c.toJson()).toList(),
  };

  ShopCategory copyWith({
    String? id,
    String? name,
    String? slug,
    String? parentId,
    ShopCategory? parentCategory,
    String? imageUrl,
    int? productCount,
    List<ShopCategory>? children,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ShopCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      parentId: parentId ?? this.parentId,
      parentCategory: parentCategory ?? this.parentCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      productCount: productCount ?? this.productCount,
      children: children ?? this.children,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
