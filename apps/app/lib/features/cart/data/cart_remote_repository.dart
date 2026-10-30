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

  @override
  Future<Cart> getCart() async {
    try {
      final res = await dio.get(ApiEndpoints.cart.base);
      final data = res.data;
      if (data != null) {
        final unwrapped = data is Map<String, dynamic>
            ? (data['data'] ?? data)
            : data;
        final cart = Cart.fromJson(unwrapped);
        if (cart.items.isNotEmpty) return cart;
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
      final item = CartItem.fromJson(data);
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
      final item = CartItem.fromJson(data);
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
