import 'package:dio/dio.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/cart_repository.dart';
import 'cart_mock_repository.dart';

class CartRemoteRepository implements CartRepository {
  CartRemoteRepository({
    required this.dio,
    CartMockRepository? mockFallback,
  }) : _mock = mockFallback ?? CartMockRepository();

  final Dio dio;
  final CartMockRepository _mock;

  static Map<String, dynamic> _extractItemMap(
    Map<String, dynamic> data, {
    int? productVariantId,
    String? itemId,
  }) {
    if (data.containsKey('items') && data['items'] is List) {
      final items = (data['items'] as List).whereType<Map>().toList();
      if (productVariantId != null) {
        final match = items.firstWhere(
          (m) =>
              m['product_variant_id'] == productVariantId ||
              m['productVariantId'] == productVariantId ||
              (m['productVariant'] is Map &&
                  (m['productVariant']['id'] == productVariantId ||
                      m['productVariant']['id']?.toString() ==
                          productVariantId.toString())),
          orElse: () => items.isNotEmpty ? items.last : const {},
        );
        if (match.isNotEmpty) return Map<String, dynamic>.from(match);
      }
      if (itemId != null) {
        final match = items.firstWhere(
          (m) =>
              m['id']?.toString() == itemId ||
              m['itemId']?.toString() == itemId,
          orElse: () => items.isNotEmpty ? items.last : const {},
        );
        if (match.isNotEmpty) return Map<String, dynamic>.from(match);
      }
      if (items.isNotEmpty) return Map<String, dynamic>.from(items.last);
    }
    return data;
  }

  @override
  Future<Cart> getCart() async {
    try {
      final res = await dio.get(ApiEndpoints.cart.base);
      final data = res.data;
      if (data != null) {
        final unwrapped = data is Map<String, dynamic>
            ? (data['data'] ?? data)
            : data;
        return Cart.fromJson(unwrapped);
      }
    } catch (e) {
      AppLogger.w('CartRemoteRepository.getCart failed: $e, falling back to mock');
    }
    return _mock.getCart();
  }

  @override
  Future<Cart> getMyCart() async {
    try {
      final res = await dio.get(ApiEndpoints.cart.me);
      final data = res.data;
      if (data != null) {
        final unwrapped = data is Map<String, dynamic>
            ? (data['data'] ?? data)
            : data;
        return Cart.fromJson(unwrapped);
      }
    } catch (e) {
      AppLogger.w('CartRemoteRepository.getMyCart failed: $e, falling back to mock');
    }
    return _mock.getMyCart();
  }

  @override
  Future<CartAvailabilityResult> checkAvailability() async {
    try {
      final res = await dio.get(ApiEndpoints.cart.availability);
      final data = res.data;
      if (data != null) {
        final unwrapped = data is Map<String, dynamic>
            ? (data['data'] ?? data)
            : data;
        return CartAvailabilityResult.fromJson(unwrapped);
      }
    } catch (e) {
      AppLogger.w('CartRemoteRepository.checkAvailability failed: $e, falling back to mock');
    }
    return _mock.checkAvailability();
  }

  @override
  Future<CartItem> addItem({
    required int productVariantId,
    required int quantity,
    Product? product,
  }) async {
    try {
      final payload = {
        'productVariantId': productVariantId,
        'quantity': quantity,
      };
      final res = await dio.post(ApiEndpoints.cart.items, data: payload);
      final data = ApiResponse.unwrapMap(res.data);
      final itemMap = _extractItemMap(data, productVariantId: productVariantId);
      var item = CartItem.fromJson(
        itemMap,
        catalogue: product != null ? [product] : const [],
      );
      if (product != null &&
          (item.product.id == 'item' || item.product.id.isEmpty)) {
        item = item.copyWith(product: product);
      }
      // Synchronize in mock cache
      try {
        await _mock.addItem(
          productVariantId: productVariantId,
          quantity: quantity,
          product: product ?? item.product,
        );
      } catch (_) {}
      return item;
    } catch (e) {
      AppLogger.w('CartRemoteRepository.addItem failed: $e, falling back to mock');
      return _mock.addItem(
        productVariantId: productVariantId,
        quantity: quantity,
        product: product,
      );
    }
  }

  @override
  Future<CartItem> updateItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final payload = {'quantity': quantity};
      final res = await dio.patch(ApiEndpoints.cart.item(itemId), data: payload);
      final data = ApiResponse.unwrapMap(res.data);
      final itemMap = _extractItemMap(data, itemId: itemId);
      final item = CartItem.fromJson(itemMap);
      try {
        await _mock.updateItemQuantity(itemId: itemId, quantity: quantity);
      } catch (_) {}
      return item;
    } catch (e) {
      AppLogger.w('CartRemoteRepository.updateItemQuantity failed: $e, falling back to mock');
      return _mock.updateItemQuantity(itemId: itemId, quantity: quantity);
    }
  }

  @override
  Future<void> removeItem(String itemId) async {
    try {
      await dio.delete(ApiEndpoints.cart.item(itemId));
    } catch (e) {
      AppLogger.w('CartRemoteRepository.removeItem failed: $e, falling back to mock');
    }
    try {
      await _mock.removeItem(itemId);
    } catch (_) {}
  }

  @override
  Future<void> clearCart() async {
    try {
      await dio.delete(ApiEndpoints.cart.base);
    } catch (e) {
      AppLogger.w('CartRemoteRepository.clearCart failed: $e, falling back to mock');
    }
    await _mock.clearCart();
  }

  // ── Backward-compatible legacy interface ──────────────────────────────
  @override
  Future<List<CartItem>> getCartItems() async => (await getCart()).items;

  @override
  Future<CartItem> addToCart(
    Product product, {
    int quantity = 1,
    int? variantId,
  }) {
    final vId = variantId ??
        (product.variants.isNotEmpty ? product.variants.first.id : (int.tryParse(product.id) ?? 1));
    return addItem(
      productVariantId: vId,
      quantity: quantity,
      product: product,
    );
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) =>
      _mock.updateQuantity(productId, quantity);

  @override
  Future<void> removeFromCart(String productId) => removeItem(productId);

  @override
  Future<Cart> getCartSummary() => getCart();
}
