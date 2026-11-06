import 'package:app/features/shop/presentation/widgets/home_hero_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/shop_providers.dart';
import '../domain/shop_entities.dart';
import 'widgets/category_chip_bar.dart';
import 'widgets/popular_brands.dart';
import 'widgets/related_searches.dart';
import 'widgets/shop_ads_banner.dart';
import 'widgets/shop_product_view_sliver.dart';
import 'widgets/shop_search_bar.dart';
import 'widgets/shop_sliver_app_bar.dart';
import 'widgets/shop_toolbar.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogueAsync = ref.watch(shopCatalogueProvider);

    return catalogueAsync.when(
      loading: () =>
          const Scaffold(body: LoadingState(message: 'Loading shop…')),
      error: (e, _) => Scaffold(
        body: ErrorState(
          message: 'Could not load shop.\n${e.toString()}',
          onRetry: () => ref.invalidate(shopCatalogueProvider),
        ),
      ),
      data: (catalogue) => const _ShopBody(),
    );
  }
}

// ─── Main shop body ───────────────────────────────────────────────────────

class _ShopBody extends ConsumerStatefulWidget {
  const _ShopBody();

  @override
  ConsumerState<_ShopBody> createState() => _ShopBodyState();
}

class _ShopBodyState extends ConsumerState<_ShopBody> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchQuery(String query) {
    ref.read(shopNotifierProvider.notifier).setSearch(query);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onRefresh() {
    ref.invalidate(shopCatalogueProvider);
    ref.invalidate(productCategoriesProvider);
    ref.read(paginatedProductsNotifierProvider.notifier).fetchFirstPage();
    ref.read(cartProvider);
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopNotifierProvider);
    final paginatedState = ref.watch(paginatedProductsNotifierProvider);
    final products = paginatedState.items;
    final catalogueAsync = ref.watch(shopCatalogueProvider);
    final categoriesAsync = ref.watch(productCategoriesProvider);
    final categories =
        categoriesAsync.valueOrNull ??
        catalogueAsync.valueOrNull?.categories ??
        const <ShopCategory>[];
    final cartCount = ref.watch(cartProvider).valueOrNull?.itemCount ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: InfiniteScrollListener(
        onLoadMore: () =>
            ref.read(paginatedProductsNotifierProvider.notifier).loadMore(),
        hasMore: paginatedState.hasMore,
        isLoading: paginatedState.isLoading,
        isLoadingMore: paginatedState.isLoadingMore,
        prefetchDistance: 250.0,
        child: RefreshIndicator(
          onRefresh: () async => _onRefresh(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ── App bar
              ShopSliverAppBar(cartCount: cartCount),

              // ── Search bar
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: ShopSearchBar(
                    focusNode: _searchFocusNode,
                    initialValue: shopState.searchQuery,
                    onChanged: (q) =>
                        ref.read(shopNotifierProvider.notifier).setSearch(q),
                  ),
                ),
              ),

              // ── Category chips
              SliverToBoxAdapter(
                child: CategoryChipBar(
                  categories: categories,
                  selected: shopState.selectedCategory,
                  isLoading: categoriesAsync.isLoading && categories.isEmpty,
                  onSelect: (cat) =>
                      ref.read(shopNotifierProvider.notifier).setCategory(cat),
                ),
              ),

              // ── Sort / filter / view mode bar
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                sliver: SliverToBoxAdapter(
                  child: ShopToolbar(
                    sort: shopState.sort,
                    viewMode: shopState.viewMode,
                    filterActive: shopState.filter.isActive,
                    productCount: paginatedState.totalCount > 0
                        ? paginatedState.totalCount
                        : products.length,
                  ),
                ),
              ),

              // ── Ads Banner
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  AppSpacing.sm,
                  0,
                  AppSpacing.sm,
                ),
                sliver: SliverToBoxAdapter(child: HomeHeroBanner()),
              ),

              // ── Product grid / list / states
              ShopProductViewSliver(
                products: products,
                viewMode: shopState.viewMode,
                isInitialLoading: paginatedState.isInitialLoading,
                error: paginatedState.error,
                onRetry: () => ref
                    .read(paginatedProductsNotifierProvider.notifier)
                    .fetchFirstPage(),
              ),

              // ── Bottom Loading Indicator
              if (paginatedState.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
              if (paginatedState.error != null && products.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    child: Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text(
                          'Failed to load more products. Tap to retry.',
                        ),
                        onPressed: () => ref
                            .read(paginatedProductsNotifierProvider.notifier)
                            .loadMore(),
                      ),
                    ),
                  ),
                ),

              // ── Bottom Sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xl),
                  child: PopularBrands(onSelect: _onSearchQuery),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: RelatedSearches(onSelect: _onSearchQuery),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 120), // Clearance for floating nav bar
              ),
            ],
          ),
        ),
      ),
    );
  }
}
