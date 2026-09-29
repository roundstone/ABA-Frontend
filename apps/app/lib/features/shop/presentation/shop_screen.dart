import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/shop_providers.dart';
import '../domain/shop_entities.dart';
import 'widgets/category_chip_bar.dart';
import 'widgets/product_card.dart';
import 'widgets/shop_filter_sheet.dart';
import 'widgets/shop_search_bar.dart';
import 'widgets/sort_bottom_sheet.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogueAsync = ref.watch(shopCatalogueProvider);

    return catalogueAsync.when(
      loading: () => const Scaffold(
        body: LoadingState(message: 'Loading shop…'),
      ),
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

class _ShopBody extends ConsumerWidget {
  const _ShopBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopNotifierProvider);
    final products = ref.watch(filteredProductsProvider);
    final catalogueAsync = ref.watch(shopCatalogueProvider);
    final categories =
        catalogueAsync.valueOrNull?.categories ?? const <ShopCategory>[];
    final cartCount = ref.watch(cartProvider).valueOrNull?.itemCount ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── App bar
          _ShopSliverAppBar(cartCount: cartCount),

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
              child: _ShopToolbar(
                sort: shopState.sort,
                viewMode: shopState.viewMode,
                filterActive: shopState.filter.isActive,
                productCount: products.length,
              ),
            ),
          ),

          // ── Product grid / list
          if (products.isEmpty)
            const SliverFillRemaining(
              child: _EmptyProducts(),
            )
          else if (shopState.viewMode == ViewMode.grid)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.xl + AppSpacing.xxxl, // nav bar clearance
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => ProductCard(product: products[i]),
                  childCount: products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.68,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.xl + AppSpacing.xxxl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) =>
                      ProductCard(product: products[i], listMode: true),
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Sliver app bar ───────────────────────────────────────────────────────

class _ShopSliverAppBar extends StatelessWidget {
  const _ShopSliverAppBar({required this.cartCount});
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      backgroundColor: cs.primary,
      title: Text(
        'ABA Shop',
        style: AppTypography.h6.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedShoppingCart01,
                color: Colors.white,
                size: AppSpacing.iconSizeMD,
              ),
              onPressed: () => context.push('/cart'),
            ),
            if (cartCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      cartCount > 9 ? '9+' : '$cartCount',
                      style: AppTypography.label.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}

// ─── Toolbar (sort + filter + view toggle) ─────────────────────────────────

class _ShopToolbar extends ConsumerWidget {
  const _ShopToolbar({
    required this.sort,
    required this.viewMode,
    required this.filterActive,
    required this.productCount,
  });
  final SortOrder sort;
  final ViewMode viewMode;
  final bool filterActive;
  final int productCount;

  String get _sortLabel {
    switch (sort) {
      case SortOrder.featured:
        return 'Featured';
      case SortOrder.nameAsc:
        return 'A–Z';
      case SortOrder.nameDesc:
        return 'Z–A';
      case SortOrder.priceLow:
        return 'Price ↑';
      case SortOrder.priceHigh:
        return 'Price ↓';
      case SortOrder.newest:
        return 'Newest';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final notifier = ref.read(shopNotifierProvider.notifier);

    return Row(
      children: [
        Text(
          '$productCount items',
          style: AppTypography.bodySmall.copyWith(
            color: cs.onSurface.withAlpha(153),
          ),
        ),
        const Spacer(),

        // Sort button
        _ToolbarButton(
          icon: HugeIcons.strokeRoundedSorting01,
          label: _sortLabel,
          onTap: () => showSortSheet(context, sort, (s) => notifier.setSort(s)),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Filter button
        _ToolbarButton(
          icon: HugeIcons.strokeRoundedFilterHorizontal,
          label: 'Filter',
          active: filterActive,
          onTap: () => showShopFilterSheet(context),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Grid/List toggle
        GestureDetector(
          onTap: () => notifier.setViewMode(
            viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: AppSpacing.borderRadiusSM,
            ),
            child: HugeIcon(
              icon: viewMode == ViewMode.grid
                  ? HugeIcons.strokeRoundedGridView
                  : HugeIcons.strokeRoundedListView,
              size: AppSpacing.iconSizeSM,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = active ? cs.primary : cs.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: active
              ? cs.primary.withAlpha(20)
              : cs.surfaceContainerHighest,
          borderRadius: AppSpacing.borderRadiusSM,
          border: active
              ? Border.all(color: cs.primary.withAlpha(80), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(icon: icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.label.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────

class _EmptyProducts extends ConsumerWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedSearchList01,
            size: AppSpacing.iconSizeXXL,
            color: AppColors.grey,
          ),
          AppSpacing.verticalSpaceMD,
          Text('No products found',
              style: AppTypography.h6.copyWith(color: AppColors.grey)),
          AppSpacing.verticalSpaceXS,
          Text('Try adjusting your filters',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey)),
          AppSpacing.verticalSpaceMD,
          TextButton(
            onPressed: () =>
                ref.read(shopNotifierProvider.notifier).resetFilters(),
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}
