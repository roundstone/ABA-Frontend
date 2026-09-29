import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/cart/application/cart_service.dart';
import 'package:app/features/cart/data/cart_mock_repository.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

final cartServiceProvider = Provider<CartService>(
  (ref) => CartService(CartMockRepository()),
);

final cartItemsProvider = FutureProvider.autoDispose<List<CartItem>>(
  (ref) => ref.watch(cartServiceProvider).getCartItems(),
);
