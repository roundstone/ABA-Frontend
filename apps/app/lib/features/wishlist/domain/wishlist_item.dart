import '../../shop/domain/product.dart';

class WishlistItem {
  final int id;
  final int customerId;
  final String wishlistableType;
  final int wishlistableId;
  final Product? product;
  final DateTime createdAt;

  const WishlistItem({
    required this.id,
    required this.customerId,
    required this.wishlistableType,
    required this.wishlistableId,
    this.product,
    required this.createdAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    Product? parsedProduct;
    final wData = json['wishlistable'] ?? json['product'];
    if (wData is Map<String, dynamic>) {
      parsedProduct = Product.fromJson(wData);
    } else if (wData is Map) {
      parsedProduct = Product.fromJson(Map<String, dynamic>.from(wData));
    }

    return WishlistItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      customerId: (json['customer_id'] as num?)?.toInt() ??
          (json['customerId'] as num?)?.toInt() ??
          0,
      wishlistableType: (json['wishlistable_type'] ??
              json['wishlistableType'] ??
              'product')
          .toString(),
      wishlistableId: (json['wishlistable_id'] as num?)?.toInt() ??
          (json['wishlistableId'] as num?)?.toInt() ??
          0,
      product: parsedProduct,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'wishlistable_type': wishlistableType,
        'wishlistable_id': wishlistableId,
        if (product != null) 'wishlistable': product!.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };
}

class PaginatedWishlistResult {
  final List<WishlistItem> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;

  const PaginatedWishlistResult({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
  });
}

