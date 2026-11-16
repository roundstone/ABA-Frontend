import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/logging/app_logger.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/cart_repository.dart';

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

  /// Finds the authoritative server cart item ID for a local [CartItem] after
  /// fetching the live cart, matching by item id, variant id, or product id.
  static String? findRemoteItemId(Cart remoteCart, CartItem localItem) {
    final vId = localItem.effectiveVariantId;
    for (final r in remoteCart.items) {
      if (localItem.id != null && r.id == localItem.id) return r.id;
      if (vId != null && r.effectiveVariantId == vId) return r.id;
      if (r.product.id == localItem.product.id) return r.id;
    }
    return null;
  }

  static Future<String?> resolveServerItemId(
    CartRepository repo,
    CartItem? item,
  ) async {
    if (item == null) return null;
    if (item.id != null && item.id!.isNotEmpty) return item.id;
    return findRemoteItemId(await repo.getCart(), item);
  }

  static Future<void> persistCart(
    SharedPreferences? prefs,
    Cart cart,
    String? userId,
  ) async {
    if (prefs == null) return;
    await prefs.setStringList(keyForUser(userId), encode(cart));
  }

  static Future<void> syncGuestCartOnLogin(
    SharedPreferences? prefs,
    CartRepository repo,
  ) async {
    final guestKey = keyForUser(null);
    final raw = prefs?.getStringList(guestKey);
    if (raw == null || raw.isEmpty) return;

    final guestItems = decode(raw, const {});
    for (final item in guestItems) {
      final vId = item.effectiveVariantId ?? int.tryParse(item.product.id) ?? 0;
      if (vId <= 0) continue;
      try {
        await repo.addItem(productVariantId: vId, quantity: item.quantity);
      } catch (e) {
        AppLogger.w('CartCacheHelper: guest item sync skipped ($e)');
      }
    }
    await prefs?.remove(guestKey);
  }
}
