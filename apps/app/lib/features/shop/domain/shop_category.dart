/// Domain entity representing a product category in the ABA ERP marketplace.
class ShopCategory {
  const ShopCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
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
  final String? imageUrl;
  final int productCount;
  final List<ShopCategory> children;
  final String? description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  factory ShopCategory.fromJson(Map<String, dynamic> json) {
    return ShopCategory(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      parentId: json['parent_id']?.toString() ?? json['parentId']?.toString(),
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      productCount: (json['product_count'] ?? json['productCount'] ?? 0) as int,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'].toString())
          : null,
      children: (json['children'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(ShopCategory.fromJson)
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
    if (parentId != null) 'parent_id': parentId,
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
