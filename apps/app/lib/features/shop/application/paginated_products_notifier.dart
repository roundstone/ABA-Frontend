import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/list_query_params.dart';
import '../../../core/network/paginated_list_state.dart';
import '../../auth/application/auth_providers.dart';
import '../domain/shop_entities.dart';
import 'shop_providers.dart';

/// Manages paginated products state for the shop screen.
/// Automatically re-fetches page 1 whenever filters, sorting, category,
/// or search query changes, and loads subsequent pages on infinite scroll.
class PaginatedProductsNotifier
    extends StateNotifier<PaginatedListState<Product>> {
  PaginatedProductsNotifier(this._ref)
      : super(const PaginatedListState<Product>(isLoading: true)) {
    _init();
  }

  final Ref _ref;

  void _init() {
    _ref.listen<ShopState>(shopNotifierProvider, (previous, next) {
      if (previous?.filter != next.filter ||
          previous?.sort != next.sort ||
          previous?.selectedCategory != next.selectedCategory ||
          previous?.searchQuery != next.searchQuery) {
        fetchFirstPage();
      }
    });

    _ref.listen(authStateProvider, (_, __) {
      fetchFirstPage();
    });

    fetchFirstPage();
  }

  int? _resolveCategoryId(ShopState shopState, List<ShopCategory> categories) {
    if (shopState.selectedCategory == null) return null;
    final parsed = int.tryParse(shopState.selectedCategory!);
    if (parsed != null) return parsed;
    if (categories.isEmpty) return null;

    final sel = shopState.selectedCategory!.toLowerCase();
    final match = categories.firstWhere(
      (c) =>
          c.name.toLowerCase() == sel ||
          c.slug.toLowerCase() == sel ||
          c.id.toString() == shopState.selectedCategory,
      orElse: () => const ShopCategory(id: '0', name: '', slug: ''),
    );
    return match.id != '0' ? int.tryParse(match.id) : null;
  }

  /// Refreshes the catalogue from page 1.
  Future<void> fetchFirstPage() async {
    if (!mounted) return;
    state = state.toLoading(
      newParams: const ListQueryParams(page: 1, limit: 20),
    );

    try {
      final repo = _ref.read(shopRepositoryProvider);
      final shopState = _ref.read(shopNotifierProvider);
      final categories =
          _ref.read(productCategoriesProvider).valueOrNull ?? const [];
      final categoryId = _resolveCategoryId(shopState, categories);

      final items = await repo.fetchProducts(
        page: 1,
        pageSize: 20,
        filter: shopState.filter,
        sort: shopState.sort,
        search: shopState.searchQuery,
        categoryId: categoryId,
      );

      if (!mounted) return;
      state = state.withRefreshedItems(newItems: items, defaultLimit: 20);
    } catch (e) {
      if (!mounted) return;
      state = state.withError(e);
    }
  }

  /// Silently loads the next page when scroll threshold is reached.
  Future<void> loadMore() async {
    if (!mounted || !state.hasMore || state.isLoadingMore || state.isLoading) {
      return;
    }

    state = state.toLoadingMore();

    try {
      final repo = _ref.read(shopRepositoryProvider);
      final shopState = _ref.read(shopNotifierProvider);
      final categories =
          _ref.read(productCategoriesProvider).valueOrNull ?? const [];
      final categoryId = _resolveCategoryId(shopState, categories);

      final nextPage = state.currentPage + 1;
      final newItems = await repo.fetchProducts(
        page: nextPage,
        pageSize: 20,
        filter: shopState.filter,
        sort: shopState.sort,
        search: shopState.searchQuery,
        categoryId: categoryId,
      );

      if (!mounted) return;

      if (newItems.isEmpty) {
        state = state.copyWith(isLoadingMore: false, hasMore: false);
      } else {
        state = state.withAppendedItems(newItems: newItems, defaultLimit: 20);
      }
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }
}

final paginatedProductsNotifierProvider = StateNotifierProvider.autoDispose<
    PaginatedProductsNotifier, PaginatedListState<Product>>((ref) {
  return PaginatedProductsNotifier(ref);
});
