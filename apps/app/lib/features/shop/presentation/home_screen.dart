import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/config/app_brand.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/notification_icon_button.dart';
import '../application/shop_providers.dart';
import '../domain/shop_entities.dart';
import 'widgets/home_category_marquee.dart';
import 'widgets/home_hero_banner.dart';
import 'widgets/home_promos.dart';
import 'widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogueAsync = ref.watch(shopCatalogueProvider);

    return Scaffold(
      body: catalogueAsync.when(
        loading: () => const LoadingState(message: 'Loading store...'),
        error: (e, _) => ErrorState(
          message: 'Could not load store.\n${e.toString()}',
          onRetry: () => ref.invalidate(shopCatalogueProvider),
        ),
        data: (catalogue) => _HomeBody(catalogue: catalogue, ref: ref),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.catalogue, required this.ref});
  final ShopCatalogue catalogue;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionColor = isDark ? AppColors.secondary : AppColors.primary;
    final featured = catalogue.products.where((p) => p.isFeatured).toList();
    final trending = catalogue.products.where((p) => !p.isFeatured).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(shopCatalogueProvider);
        await ref.read(shopCatalogueProvider.future);
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              AppBrand.shortName,
              style: AppTypography.h3.copyWith(
                color: actionColor,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: 'Search products',
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: actionColor,
                ),
                onPressed: () {
                  context.go('/shop');
                },
              ),
              NotificationIconButton(
                color: actionColor,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeroBanner(imageUrl: catalogue.featuredBannerUrl),
                  const SizedBox(height: AppSpacing.xxl),
                  if (catalogue.categories.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Categories',
                      onSeeAll: () => context.go('/shop'),
                    ),
                    HomeCategoryMarquee(categories: catalogue.categories),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  if (featured.isNotEmpty) ...[
                    const _SectionHeader(title: 'Product Spotlight'),
                    _ProductHorizontalList(products: featured),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  const RewardsPromo(),
                  const SizedBox(height: AppSpacing.xxl),
                  if (trending.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Trending Products',
                      onSeeAll: () => context.go('/shop'),
                    ),
                    _ProductHorizontalList(products: trending),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  const MadeInAbaPromo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.h5.copyWith(fontWeight: FontWeight.w800),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See all',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.secondary : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductHorizontalList extends StatelessWidget {
  const _ProductHorizontalList({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: ProductCard(
              product: products[index],
              listMode: false,
            ),
          );
        },
      ),
    );
  }
}
