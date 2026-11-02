import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/cart_repository.dart';
import 'cart_mock_repository.dart';
import 'cart_remote_helpers.dart';

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
      Response res;
      try {
        res = await dio.get(ApiEndpoints.cart.me);
      } on DioException catch (dioErr) {
        if (dioErr.response?.statusCode == 404) {
          res = await dio.get(ApiEndpoints.cart.base);
        } else {
          rethrow;
        }
      }
      final data = res.data;
      if (data != null) {
        final unwrapped =
            data is Map<String, dynamic> ? (data['data'] ?? data) : data;
        return Cart.fromJson(unwrapped);
      }
      return const Cart();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.getCart();
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.getCart();
      rethrow;
    }
  }

  @override
  Future<Cart> getMyCart() async {
    try {
      final res = await dio.get(ApiEndpoints.cart.me);
      final data = res.data;
      if (data != null) {
        final unwrapped =
            data is Map<String, dynamic> ? (data['data'] ?? data) : data;
        return Cart.fromJson(unwrapped);
      }
      return const Cart();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.getMyCart();
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.getMyCart();
      rethrow;
    }
  }

  @override
  Future<CartAvailabilityResult> checkAvailability() async {
    try {
      final res = await dio.get(ApiEndpoints.cart.availability);
      final data = res.data;
      if (data != null) {
        final unwrapped =
            data is Map<String, dynamic> ? (data['data'] ?? data) : data;
        return CartAvailabilityResult.fromJson(unwrapped);
      }
      return const CartAvailabilityResult(cartId: 0, isAvailable: true, items: []);
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.checkAvailability();
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.checkAvailability();
      rethrow;
    }
  }

  @override
  Future<CartItem> addItem({
    required int productVariantId,
    required int quantity,
    Product? product,
  }) async {
    try {
      final payload = {'productVariantId': productVariantId, 'quantity': quantity};
      final res = await dio.post(ApiEndpoints.cart.items, data: payload);
      final data = ApiResponse.unwrapMap(res.data);
      final itemMap = CartRemoteHelpers.extractItemMap(data, productVariantId: productVariantId);
      var item = CartItem.fromJson(itemMap, catalogue: product != null ? [product] : const []);
      if (product != null && (item.product.id == 'item' || item.product.id.isEmpty)) {
        item = item.copyWith(product: product);
      }
      if (AppConfig.isMockMode) {
        try {
          await _mock.addItem(productVariantId: productVariantId, quantity: quantity, product: product ?? item.product);
        } catch (_) {}
      }
      return item;
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        return _mock.addItem(productVariantId: productVariantId, quantity: quantity, product: product);
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return _mock.addItem(productVariantId: productVariantId, quantity: quantity, product: product);
      }
      rethrow;
    }
  }

  @override
  Future<CartItem> updateItemQuantity({required String itemId, required int quantity}) async {
    try {
      final res = await dio.patch(ApiEndpoints.cart.item(itemId), data: {'quantity': quantity});
      final data = ApiResponse.unwrapMap(res.data);
      final itemMap = CartRemoteHelpers.extractItemMap(data, itemId: itemId);
      final item = CartItem.fromJson(itemMap);
      if (AppConfig.isMockMode) {
        try {
          await _mock.updateItemQuantity(itemId: itemId, quantity: quantity);
        } catch (_) {}
      }
      return item;
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.updateItemQuantity(itemId: itemId, quantity: quantity);
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.updateItemQuantity(itemId: itemId, quantity: quantity);
      rethrow;
    }
  }

  @override
  Future<void> removeItem(String itemId) async {
    try {
      await dio.delete(ApiEndpoints.cart.item(itemId));
      if (AppConfig.isMockMode) {
        try {
          await _mock.removeItem(itemId);
        } catch (_) {}
      }
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        await _mock.removeItem(itemId);
        return;
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        await _mock.removeItem(itemId);
        return;
      }
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await dio.delete(ApiEndpoints.cart.base);
      if (AppConfig.isMockMode) await _mock.clearCart();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        await _mock.clearCart();
        return;
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        await _mock.clearCart();
        return;
      }
      rethrow;
    }
  }

  @override
  Future<List<CartItem>> getCartItems() async => (await getCart()).items;

  @override
  Future<CartItem> addToCart(Product p, {int quantity = 1, int? variantId}) =>
      addItem(productVariantId: variantId ?? (p.variants.isNotEmpty ? p.variants.first.id : (int.tryParse(p.id) ?? 1)), quantity: quantity, product: p);

  @override
  Future<void> updateQuantity(String productId, int quantity) =>
      _mock.updateQuantity(productId, quantity);

  @override
  Future<void> removeFromCart(String productId) => removeItem(productId);

  @override
  Future<Cart> getCartSummary() => getCart();
}
