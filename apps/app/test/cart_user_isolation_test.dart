import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/providers/shared_preferences_provider.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/cart/application/cart_cache_helper.dart';
import 'package:app/features/cart/application/cart_providers.dart';
import 'package:app/features/cart/data/cart_mock_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Cart User Isolation Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    const product1 = Product(
      id: 'prod-1',
      name: 'User 1 Product',
      slug: 'user-1-product',
      price: 5000.0,
      category: 'Shoes',
      brand: 'Aba Craft',
      rating: 4.5,
      reviewCount: 3,
      stock: 10,
      images: [],
    );

    const product2 = Product(
      id: 'prod-2',
      name: 'User 2 Product',
      slug: 'user-2-product',
      price: 8000.0,
      category: 'Bags',
      brand: 'Aba Craft',
      rating: 4.8,
      reviewCount: 5,
      stock: 15,
      images: [],
    );

    test('CartCacheHelper partitions keys by user ID', () {
      expect(CartCacheHelper.keyForUser('1'), equals('aba_cart_v1_user_1'));
      expect(CartCacheHelper.keyForUser('2'), equals('aba_cart_v1_user_2'));
      expect(CartCacheHelper.keyForUser(null), equals('aba_cart_v1_guest'));
    });

    test('CartMockRepository isolates cart items between user sessions', () async {
      String currentUserId = 'user-A';
      final mockRepo = CartMockRepository(getUserId: () => currentUserId);

      // User A adds product 1
      await mockRepo.addItem(productVariantId: 101, quantity: 2, product: product1);
      final userACart = await mockRepo.getCart();
      expect(userACart.items.length, equals(1));
      expect(userACart.items.first.product.id, equals('prod-1'));

      // Switch to User B (login as different user)
      currentUserId = 'user-B';
      final userBCart = await mockRepo.getCart();
      expect(userBCart.items, isEmpty);

      // User B adds product 2
      await mockRepo.addItem(productVariantId: 202, quantity: 1, product: product2);
      final userBCartAfterAdd = await mockRepo.getCart();
      expect(userBCartAfterAdd.items.length, equals(1));
      expect(userBCartAfterAdd.items.first.product.id, equals('prod-2'));

      // Switch back to User A
      currentUserId = 'user-A';
      final userACartRestored = await mockRepo.getCart();
      expect(userACartRestored.items.length, equals(1));
      expect(userACartRestored.items.first.product.id, equals('prod-1'));
    });

    test('cartProvider automatically clears on logout and switches carts per user', () async {
      final userA = AuthUser(
        id: '1',
        name: 'User A',
        email: 'userA@example.com',
        phone: '+2348000000001',
        token: 'token-a',
        createdAt: DateTime(2026),
        role: UserRole.customer,
      );
      final userB = AuthUser(
        id: '2',
        name: 'User B',
        email: 'userB@example.com',
        phone: '+2348000000002',
        token: 'token-b',
        createdAt: DateTime(2026),
        role: UserRole.customer,
      );

      late ProviderContainer container;
      final mockRepo = CartMockRepository(
        getUserId: () => container.read(currentUserProvider)?.id.toString() ?? 'guest',
      );

      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          cartRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      // 1. Initial unauthenticated state: cart is empty
      expect(container.read(cartProvider).valueOrNull?.items ?? [], isEmpty);

      // 2. User A logs in
      container.read(authStateProvider.notifier).state = AuthState(user: userA);
      // Wait for provider to react
      await container.read(cartProvider.future);
      expect(container.read(cartProvider).valueOrNull?.items ?? [], isEmpty);

      // User A adds product 1 to cart
      await container.read(cartProvider.notifier).addToCart(product1, quantity: 2);
      final cartAfterUserA = container.read(cartProvider).valueOrNull;
      expect(cartAfterUserA?.items.length, equals(1));
      expect(cartAfterUserA?.items.first.product.id, equals('prod-1'));

      // 3. User A logs out
      await container.read(authStateProvider.notifier).logout();
      final cartAfterLogout = container.read(cartProvider).valueOrNull;
      expect(cartAfterLogout?.items ?? [], isEmpty);

      // 4. User B logs in
      container.read(authStateProvider.notifier).state = AuthState(user: userB);
      await container.read(cartProvider.future);

      // User B MUST NOT see User A's items
      final cartForUserB = container.read(cartProvider).valueOrNull;
      expect(cartForUserB?.items ?? [], isEmpty);
    });
  });
}
