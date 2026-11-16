import 'package:app/core/providers/shared_preferences_provider.dart';
import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/cart/application/cart_cache_helper.dart';
import 'package:app/features/cart/application/cart_providers.dart';
import 'package:app/features/cart/domain/cart_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final user = AuthUser(
    id: '10',
    email: 'user@aba.ng',
    name: 'Test User',
    phone: '+2348012345678',
    role: UserRole.customer,
    token: 'jwt',
    createdAt: DateTime(2026),
  );

  const product = Product(
    id: '3',
    name: 'Demo Product',
    slug: 'demo-product',
    price: 12700,
    category: 'Shoes',
    brand: 'ABA',
    rating: 4.5,
    reviewCount: 2,
    stock: 20,
    images: [],
    variants: [
      ProductVariant(id: 4, productId: 3, name: 'Black', sku: 'SKU-4', price: 12700),
    ],
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CartNotifier Backend Synchronization', () {
    test('addToCart syncs with backend and reconciles server item id', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = _FakeCartRepo(serverCart: const Cart());
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authStateProvider.overrideWith((_) => _StaticAuth(AuthState(user: user))),
          cartRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(cartProvider.future);
      final ok = await container.read(cartProvider.notifier).addToCart(product, quantity: 2);

      expect(ok, isTrue);
      expect(repo.addCalls, 1);
      final cart = container.read(cartProvider).value!;
      expect(cart.items.length, 1);
      expect(cart.items.first.id, 'srv-99');
    });

    test('addToCart rolls back optimistic state and returns false on backend failure', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = _FakeCartRepo(serverCart: const Cart(), failAdd: true);
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authStateProvider.overrideWith((_) => _StaticAuth(AuthState(user: user))),
          cartRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(cartProvider.future);
      final ok = await container.read(cartProvider.notifier).addToCart(product);

      expect(ok, isFalse);
      final cart = container.read(cartProvider).value!;
      expect(cart.items, isEmpty);
      expect(container.read(cartProvider.notifier).lastErrorMessage, isNotNull);
    });

    test('updateQuantity debounces rapid taps into a single backend PATCH', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = _FakeCartRepo(
        serverCart: const Cart(
          items: [CartItem(id: 'srv-1', product: product, productVariantId: 4, quantity: 1)],
        ),
      );
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authStateProvider.overrideWith((_) => _StaticAuth(AuthState(user: user))),
          cartRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(cartProvider.future);
      final notifier = container.read(cartProvider.notifier);

      await notifier.updateQuantity('srv-1', 2);
      await notifier.updateQuantity('srv-1', 3);
      await notifier.updateQuantity('srv-1', 4);

      expect(container.read(cartProvider).value!.items.first.quantity, 4);
      expect(repo.updateCalls, 0);

      await Future.delayed(const Duration(milliseconds: 420));
      expect(repo.updateCalls, 1);
      expect(repo.lastUpdatedQty, 4);
    });

    test('syncs guest cached items to backend on login', () async {
      SharedPreferences.setMockInitialValues({
        CartCacheHelper.keyForUser(null): ['3|2|||4'],
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = _FakeCartRepo(serverCart: const Cart());
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authStateProvider.overrideWith((_) => _StaticAuth(AuthState(user: user))),
          cartRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(cartProvider.future);

      expect(repo.addCalls, 1);
      expect(prefs.getStringList(CartCacheHelper.keyForUser(null)), isNull);
    });

    test('syncAfterPayment clears local cart and syncs empty cart from backend', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = _FakeCartRepo(
        serverCart: const Cart(
          items: [CartItem(id: 'srv-1', product: product, productVariantId: 4, quantity: 2)],
        ),
      );
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authStateProvider.overrideWith((_) => _StaticAuth(AuthState(user: user))),
          cartRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(cartProvider.future);
      expect(container.read(cartProvider).value!.items.length, 1);

      // Simulate backend clearing the cart on successful Paystack payment
      repo.serverCart = const Cart();
      await container.read(cartProvider.notifier).syncAfterPayment();

      expect(container.read(cartProvider).value!.items, isEmpty);
      expect(prefs.getStringList(CartCacheHelper.keyForUser('10')), isEmpty);
    });
  });
}

class _StaticAuth extends StateNotifier<AuthState> implements AuthNotifier {
  _StaticAuth(super.state);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCartRepo implements CartRepository {
  _FakeCartRepo({required this.serverCart, this.failAdd = false});
  Cart serverCart;
  final bool failAdd;
  int addCalls = 0;
  int updateCalls = 0;
  int? lastUpdatedQty;

  @override
  Future<Cart> getCart() async => serverCart;

  @override
  Future<Cart> getMyCart() async => serverCart;

  @override
  Future<CartItem> addItem({
    required int productVariantId,
    required int quantity,
    Product? product,
  }) async {
    addCalls++;
    if (failAdd) throw Exception('Network error');
    final item = CartItem(
      id: 'srv-99',
      product: product ??
          const Product(
            id: '3',
            name: 'Demo',
            slug: 'demo',
            price: 1000,
            category: 'Cat',
            brand: 'Brand',
            rating: 4,
            reviewCount: 1,
            stock: 10,
            images: [],
          ),
      productVariantId: productVariantId,
      quantity: quantity,
    );
    serverCart = serverCart.addItem(item);
    return item;
  }

  @override
  Future<CartItem> updateItemQuantity({required String itemId, required int quantity}) async {
    updateCalls++;
    lastUpdatedQty = quantity;
    serverCart = serverCart.updateQuantity(itemId, quantity);
    return serverCart.items.first;
  }

  @override
  Future<void> removeItem(String itemId) async {
    serverCart = serverCart.removeItem(itemId);
  }

  @override
  Future<void> clearCart() async {
    serverCart = const Cart();
  }

  @override
  Future<CartAvailabilityResult> checkAvailability() async =>
      const CartAvailabilityResult(isAvailable: true);

  @override
  Future<Cart> getCartSummary() async => serverCart;

  @override
  Future<List<CartItem>> getCartItems() async => serverCart.items;

  @override
  Future<CartItem> addToCart(Product product, {int quantity = 1, int? variantId}) =>
      addItem(productVariantId: variantId ?? 4, quantity: quantity, product: product);

  @override
  Future<void> removeFromCart(String productId) async {}

  @override
  Future<void> updateQuantity(String productId, int quantity) async {}
}
