import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';

const _kCartKey = 'aba_cart_v1';

/// Cart state notifier with SharedPreferences persistence.
class CartNotifier extends AsyncNotifier<Cart> {
  static const _sep = '|';

  @override
  Future<Cart> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs?.getStringList(_kCartKey);
    if (raw == null || raw.isEmpty) return const Cart();

    final catalogue = await ref.read(shopCatalogueProvider.future);
    final productMap = {for (final p in catalogue.products) p.id: p};

    final items = <CartItem>[];
    for (final entry in raw) {
      final parts = entry.split(_sep);
      if (parts.length < 2) continue;
      final productId = parts[0];
      final qty = int.tryParse(parts[1]) ?? 1;
      final color = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : null;
      final size = parts.length > 3 && parts[3].isNotEmpty ? parts[3] : null;
      final product = productMap[productId];
      if (product != null) {
        items.add(
          CartItem(
            product: product,
            quantity: qty,
            selectedColor: color,
            selectedSize: size,
          ),
        );
      }
    }
    return Cart(items: items);
  }

  Future<void> _persist(Cart cart) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (prefs == null) return;
    final encoded = cart.items.map((i) {
      final parts = [
        i.product.id,
        '${i.quantity}',
        i.selectedColor ?? '',
        i.selectedSize ?? '',
      ];
      return parts.join(_sep);
    }).toList();
    await prefs.setStringList(_kCartKey, encoded);
  }

  void addToCart(
    Product product, {
    int quantity = 1,
    String? color,
    String? size,
  }) {
    final current = state.valueOrNull ?? const Cart();
    final next = current.addItem(
      CartItem(
        product: product,
        quantity: quantity,
        selectedColor: color,
        selectedSize: size,
      ),
    );
    state = AsyncValue.data(next);
    _persist(next);
  }

  void removeFromCart(String productId) {
    final current = state.valueOrNull ?? const Cart();
    final next = current.removeItem(productId);
    state = AsyncValue.data(next);
    _persist(next);
  }

  void updateQuantity(String productId, int quantity) {
    final current = state.valueOrNull ?? const Cart();
    final next = current.updateQuantity(productId, quantity);
    state = AsyncValue.data(next);
    _persist(next);
  }

  void clearCart() {
    state = const AsyncValue.data(Cart());
    _persist(const Cart());
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, Cart>(
  CartNotifier.new,
);
