import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/merchant_providers.dart';
import '../domain/merchant_entities.dart';
import 'widgets/merchant_card.dart';
import 'widgets/merchant_category_bar.dart';
import 'widgets/merchant_empty_state.dart';
import 'widgets/merchant_filter_sheet.dart';
import 'widgets/merchant_hero_header.dart';
import 'widgets/merchant_promo_banner.dart';
import 'widgets/merchant_sort_sheet.dart';
import 'widgets/merchant_toolbar.dart';

class MerchantDirectoryScreen extends ConsumerWidget {
  const MerchantDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterParams = ref.watch(merchantFilterProvider);
    final directoryAsync = ref.watch(merchantsDirectoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF172A1D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Verified Businesses',
          style: AppTypography.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'View Cart',
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingBag01,
              color: Colors.white,
            ),
            onPressed: () => context.go('/cart'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(merchantsDirectoryProvider);
          await ref.read(merchantsDirectoryProvider.future);
        },
        child: CustomScrollView(
          slivers: [
            // Top Hero Banner with Search
            SliverToBoxAdapter(
              child: MerchantHeroHeader(
                searchQuery: filterParams.query,
                onSearchChanged: (q) {
                  ref.read(merchantFilterProvider.notifier).setQuery(q);
                },
              ),
            ),

            // Horizontal Category Selector
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: MerchantCategoryBar(
                  selectedCategory: filterParams.category,
                  onSelectCategory: (cat) {
                    ref.read(merchantFilterProvider.notifier).setCategory(cat);
                  },
                ),
              ),
            ),

            // Directory content / Toolbar
            ...directoryAsync.when(
              data: (result) => _buildDataSlivers(
                context,
                ref,
                result,
                filterParams,
              ),
              loading: () => [
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingState(message: 'Loading verified businesses…'),
                ),
              ],
              error: (err, _) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorState(
                    message: err.toString(),
                    onRetry: () => ref.invalidate(merchantsDirectoryProvider),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDataSlivers(
    BuildContext context,
    WidgetRef ref,
    MerchantDirectoryResult result,
    MerchantFilterParams filterParams,
  ) {
    final activeCount = _calculateActiveFiltersCount(filterParams);

    return [
      SliverToBoxAdapter(
        child: MerchantToolbar(
          totalCount: result.totalCount,
          currentSort: filterParams.sort,
          hasActiveFilters: filterParams.hasActiveFilters,
          activeFiltersCount: activeCount,
          onTapFilter: () {
            showMerchantFilterSheet(
              context: context,
              initialParams: filterParams,
              onApply: (updated) {
                ref.read(merchantFilterProvider.notifier).updateParams(updated);
              },
            );
          },
          onTapSort: () {
            showMerchantSortSheet(
              context: context,
              currentSort: filterParams.sort,
              onSelected: (sort) {
                ref.read(merchantFilterProvider.notifier).setSort(sort);
              },
            );
          },
        ),
      ),
      if (result.merchants.isEmpty)
        SliverToBoxAdapter(
          child: MerchantEmptyState(
            hasActiveFilters: filterParams.hasActiveFilters,
            onClearFilters: () {
              ref.read(merchantFilterProvider.notifier).clearFilters();
            },
          ),
        )
      else
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final merchant = result.merchants[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: MerchantCard(merchant: merchant),
                );
              },
              childCount: result.merchants.length,
            ),
          ),
        ),
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: MerchantPromoBanner(),
        ),
      ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 80),
      ),
    ];
  }

  int _calculateActiveFiltersCount(MerchantFilterParams p) {
    int count = 0;
    if (p.state.isNotEmpty) count++;
    if (p.minRating != null) count++;
    if (p.verifiedOnly) count++;
    return count;
  }
}
