import 'package:app/core/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/shop_mock_repository.dart';
import '../domain/shop_entities.dart';
import '../domain/shop_repository.dart';

// ─── Repository ───────────────────────────────────────────────────────────
// Swap useValue for ShopRemoteRepository(ref.read(dioClientProvider))
// when the real API is ready. Zero UI changes required.
final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => ShopMockRepository(),
);

// ─── Catalogue (products + categories) ───────────────────────────────────
final shopCatalogueProvider = FutureProvider.autoDispose<ShopCatalogue>((
  ref,
) async {
  final repo = ref.watch(shopRepositoryProvider);
  return repo.fetchCatalogue();
});

// ─── Single product ───────────────────────────────────────────────────────
final productDetailProvider = FutureProvider.autoDispose
    .family<Product?, String>((ref, id) async {
      final repo = ref.watch(shopRepositoryProvider);
      return repo.fetchProductById(id);
    });

// ─── Shop UI state notifier ───────────────────────────────────────────────

class ShopState {
  const ShopState({
    this.filter = const ShopFilter(),
    this.sort = SortOrder.featured,
    this.viewMode = ViewMode.grid,
    this.selectedCategory,
    this.searchQuery = '',
  });

  final ShopFilter filter;
  final SortOrder sort;
  final ViewMode viewMode;
  final String? selectedCategory;
  final String searchQuery;

  ShopState copyWith({
    ShopFilter? filter,
    SortOrder? sort,
    ViewMode? viewMode,
    String? selectedCategory,
    String? searchQuery,
    bool clearCategory = false,
  }) => ShopState(
    filter: filter ?? this.filter,
    sort: sort ?? this.sort,
    viewMode: viewMode ?? this.viewMode,
    selectedCategory: clearCategory
        ? null
        : selectedCategory ?? this.selectedCategory,
    searchQuery: searchQuery ?? this.searchQuery,
  );
}

class ShopNotifier extends Notifier<ShopState> {
  @override
  ShopState build() => const ShopState();

  void setSort(SortOrder sort) => state = state.copyWith(sort: sort);
  void setViewMode(ViewMode mode) => state = state.copyWith(viewMode: mode);
  void setFilter(ShopFilter filter) => state = state.copyWith(filter: filter);
  void setCategory(String? category) => state = category == null
      ? state.copyWith(clearCategory: true)
      : state.copyWith(selectedCategory: category);
  void setSearch(String query) => state = state.copyWith(searchQuery: query);
  void resetFilters() =>
      state = state.copyWith(filter: const ShopFilter(), clearCategory: true);
}

final shopNotifierProvider = NotifierProvider<ShopNotifier, ShopState>(
  ShopNotifier.new,
);

// ─── Filtered product list (derived) ──────────────────────────────────────
// Watches both catalogue and UI state for reactive updates.
final filteredProductsProvider = Provider.autoDispose<List<Product>>((ref) {
  final catalogueAsync = ref.watch(shopCatalogueProvider);
  final shopState = ref.watch(shopNotifierProvider);

  return catalogueAsync.when(
    data: (catalogue) {
      var products = catalogue.products;

      // Category filter
      if (shopState.selectedCategory != null) {
        products = products
            .where((p) => p.category == shopState.selectedCategory)
            .toList();
      }

      // Search
      if (shopState.searchQuery.isNotEmpty) {
        final q = shopState.searchQuery.toLowerCase();
        products = products
            .where(
              (p) =>
                  p.name.toLowerCase().contains(q) ||
                  p.brand.toLowerCase().contains(q) ||
                  p.category.toLowerCase().contains(q),
            )
            .toList();
      }

      // Filter
      final f = shopState.filter;
      if (f.brands.isNotEmpty) {
        products = products.where((p) => f.brands.contains(p.brand)).toList();
      }
      if (f.colors.isNotEmpty) {
        products = products
            .where(
              (p) =>
                  p.colors != null &&
                  p.colors!.any((c) => f.colors.contains(c)),
            )
            .toList();
      }
      if (f.ratings.isNotEmpty) {
        products = products
            .where((p) => f.ratings.contains(p.rating.floor()))
            .toList();
      }
      products = products
          .where(
            (p) => p.price >= f.priceRange.$1 && p.price <= f.priceRange.$2,
          )
          .toList();

      // Sort
      final sorted = List<Product>.from(products);
      switch (shopState.sort) {
        case SortOrder.nameAsc:
          sorted.sort((a, b) => a.name.compareTo(b.name));
        case SortOrder.nameDesc:
          sorted.sort((a, b) => b.name.compareTo(a.name));
        case SortOrder.priceLow:
          sorted.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        case SortOrder.priceHigh:
          sorted.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        case SortOrder.newest:
          sorted.sort((a, b) => (b.isNew ? 1 : 0) - (a.isNew ? 1 : 0));
        case SortOrder.featured:
          sorted.sort(
            (a, b) => (b.isFeatured ? 1 : 0) - (a.isFeatured ? 1 : 0),
          );
      }
      return sorted;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// ─── Cart persistence helper ──────────────────────────────────────────────
// Key used in SharedPreferences — bump suffix to clear old cached carts.
const _kCartKey = 'aba_cart_v1';

// ─── Cart state notifier (persistent) ────────────────────────────────────
//
// Uses AsyncNotifier so we can await SharedPreferences during build().
// Consumers watch `cartProvider` which is kept synchronous via
// `cartProvider.select(…)` or `ref.watch(cartProvider).valueOrNull`.
//
// NOTE: We keep a flat list of product IDs + quantities in prefs and
// re-hydrate products from the mock catalogue on startup.

class CartNotifier extends AsyncNotifier<Cart> {
  static const _sep = '|';

  @override
  Future<Cart> build() async {
    // Try to rehydrate from prefs
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getStringList(_kCartKey);
    if (raw == null || raw.isEmpty) return const Cart();

    // We need the product catalogue to rebuild Product objects
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
