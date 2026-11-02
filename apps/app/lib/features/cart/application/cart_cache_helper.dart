import '../../shop/domain/shop_entities.dart';

/// Helper for encoding, decoding, and resolving local user-scoped cart cache.
class CartCacheHelper {
  static const _sep = '|';
  static const legacyKey = 'aba_cart_v1';

  /// Returns user-scoped storage key for SharedPreferences.
  static String keyForUser(String? userId) {
    if (userId != null && userId.trim().isNotEmpty) {
      return 'aba_cart_v1_user_${userId.trim()}';
    }
    return 'aba_cart_v1_guest';
  }

  /// Encodes cart items into pipe-delimited string lists for SharedPreferences.
  static List<String> encode(Cart cart) {
    return cart.items.map((i) => [
      i.product.id,
      '${i.quantity}',
      i.selectedColor ?? '',
      i.selectedSize ?? '',
      i.id ?? '',
      '${i.effectiveVariantId ?? ''}',
    ].join(_sep)).toList();
  }

  /// Decodes cached string list into domain [CartItem]s using catalogue lookup.
  static List<CartItem> decode(
    List<String> raw,
    Map<String, Product> productMap,
  ) {
    final items = <CartItem>[];
    for (final entry in raw) {
      final parts = entry.split(_sep);
      if (parts.length < 2) continue;

      final productId = parts[0];
      final qty = int.tryParse(parts[1]) ?? 1;
      final color = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : null;
      final size = parts.length > 3 && parts[3].isNotEmpty ? parts[3] : null;
      final itemId = parts.length > 4 && parts[4].isNotEmpty ? parts[4] : null;
      final varId = parts.length > 5 ? int.tryParse(parts[5]) : null;

      final product = productMap[productId] ??
          Product(
            id: productId,
            name: 'Product $productId',
            slug: 'product-$productId',
            price: 15000.0,
            category: 'General',
            brand: 'Aba Craft',
            rating: 4.8,
            reviewCount: 5,
            stock: 20,
            images: const [],
          );

      items.add(
        CartItem(
          id: itemId,
          product: product,
          quantity: qty,
          productVariantId: varId,
          selectedColor: color,
          selectedSize: size,
        ),
      );
    }
    return items;
  }

  /// Resolves matching variant ID from product variants.
  static int resolveVariantId(
    Product product, {
    String? color,
    String? size,
    int? variantId,
  }) {
    if (variantId != null && variantId > 0) return variantId;
    if (product.variants.isNotEmpty) {
      if (color != null || size != null) {
        return product.variants.firstWhere(
          (v) =>
              (color == null || v.color?.toLowerCase() == color.toLowerCase()) &&
              (size == null || v.size?.toLowerCase() == size.toLowerCase()),
          orElse: () => product.variants.first,
        ).id;
      }
      return product.variants.first.id;
    }
    return int.tryParse(product.id) ?? 1;
  }
}
