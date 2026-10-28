/// Popular Brand entity from `/api/v1/storefront/popular-brands`.
class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.slug,
    this.isVerified = false,
    this.productCount = 0,
    this.orderedQuantity = 0,
  });

  final int id;
  final String name;
  final String slug;
  final bool isVerified;
  final int productCount;
  final int orderedQuantity;

  factory Brand.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final idVal = rawId is num ? rawId.toInt() : int.tryParse(rawId?.toString() ?? '') ?? 0;
    final pc = json['productCount'] ?? json['product_count'];
    final parsedPc = pc is num ? pc.toInt() : int.tryParse(pc?.toString() ?? '') ?? 0;
    final oq = json['orderedQuantity'] ?? json['ordered_quantity'];
    final parsedOq = oq is num ? oq.toInt() : int.tryParse(oq?.toString() ?? '') ?? 0;

    return Brand(
      id: idVal,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? json['is_verified'] as bool? ?? false,
      productCount: parsedPc,
      orderedQuantity: parsedOq,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'isVerified': isVerified,
    'productCount': productCount,
    'orderedQuantity': orderedQuantity,
  };
}
