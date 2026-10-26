import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/application/auth_providers.dart';
import '../data/shop_remote_repository.dart';
import '../domain/shop_entities.dart';
import '../domain/shop_repository.dart';
import 'paginated_products_notifier.dart';

export '../../cart/application/cart_notifier.dart';
export 'paginated_products_notifier.dart';

// ─── Repository ───────────────────────────────────────────────────────────
final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => ShopRemoteRepository(dio: ref.watch(dioProvider)),
);

// ─── Product Categories Provider ──────────────────────────────────────────
final productCategoriesProvider =
    FutureProvider.autoDispose<List<ShopCategory>>((ref) async {
  ref.watch(authStateProvider);
  final repo = ref.watch(shopRepositoryProvider);
  return repo.fetchCategories(
    params: const ListQueryParams(
      page: 1,
      limit: 10,
      orderBy: 'createdAt:DESC',
      isActive: true,
    ),
  );
});

// ─── Catalogue (products + categories) ───────────────────────────────────
final shopCatalogueProvider = FutureProvider.autoDispose<ShopCatalogue>((
  ref,
) async {
  ref.watch(authStateProvider);
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

// ─── Filtered product list (derived from paginated state) ─────────────────
final filteredProductsProvider = Provider.autoDispose<List<Product>>((ref) {
  final paginatedState = ref.watch(paginatedProductsNotifierProvider);
  final catalogueAsync = ref.watch(shopCatalogueProvider);

  if (paginatedState.items.isNotEmpty) {
    return paginatedState.items;
  }
  if (paginatedState.isLoading) {
    return const [];
  }
  return catalogueAsync.valueOrNull?.products ?? const [];
});

