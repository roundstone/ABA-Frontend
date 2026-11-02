import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/auth_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../data/cart_mock_repository.dart';
import '../data/cart_remote_repository.dart';
import '../domain/cart_repository.dart';
import 'cart_service.dart';

export 'cart_notifier.dart';
export 'cart_service.dart';

final cartMockRepositoryProvider = Provider<CartMockRepository>((ref) {
  final user = ref.watch(currentUserProvider);
  return CartMockRepository(
    getUserId: () => user?.id.toString() ?? 'guest',
  );
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRemoteRepository(
    dio: ref.watch(dioProvider),
    mockFallback: ref.watch(cartMockRepositoryProvider),
  );
});

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref.watch(cartRepositoryProvider));
});

final cartItemsProvider = FutureProvider.autoDispose<List<CartItem>>((ref) {
  return ref.watch(cartServiceProvider).getCartItems();
});
