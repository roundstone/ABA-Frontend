import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/config/app_brand.dart';
import '../application/shop_providers.dart';
import '../domain/shop_entities.dart';
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
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  context.go('/shop');
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(imageUrl: catalogue.featuredBannerUrl),
                  const SizedBox(height: AppSpacing.xxl),
                  if (catalogue.categories.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Categories',
                      onSeeAll: () => context.go('/shop'),
                    ),
                    _CategoryMarquee(categories: catalogue.categories),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  if (featured.isNotEmpty) ...[
                    const _SectionHeader(title: 'Product Spotlight'),
                    _ProductHorizontalList(products: featured),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  const _RewardsPromo(),
                  const SizedBox(height: AppSpacing.xxl),
                  if (trending.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Trending Products',
                      onSeeAll: () => context.go('/shop'),
                    ),
                    _ProductHorizontalList(products: trending),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  const _MadeInAbaPromo(),
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

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppSpacing.borderRadiusXL,
        color: AppColors.primary.withAlpha(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedImage01,
                  color: AppColors.grey,
                  size: 40,
                ),
              ),
            )
          else
            const Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedImage01,
                color: AppColors.grey,
                size: 40,
              ),
            ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(150)],
              ),
            ),
          ),
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppBrand.tagline,
                  style: AppTypography.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Direct from source to your storefront',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryMarquee extends StatelessWidget {
  const _CategoryMarquee({required this.categories});
  final List<ShopCategory> categories;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () {
              // TODO: Update shop state category filter and navigate to shop
              context.go('/shop');
            },
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: AppSpacing.borderRadiusLG,
                border: Border.all(
                  color: isDark
                      ? Colors.transparent
                      : AppColors.outline.withAlpha(100),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedTag01,
                    color: isDark ? AppColors.secondary : AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    cat.name,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
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
          bool isViewModeList = false;
          return SizedBox(
            width: 160,
            child: ProductCard(
              product: products[index],
              listMode: isViewModeList,
            ),
          );
        },
      ),
    );
  }
}

class _RewardsPromo extends StatelessWidget {
  const _RewardsPromo();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppSpacing.borderRadiusXL,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join ${AppBrand.shortName} Rewards',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Earn points on every purchase and unlock exclusive discounts.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.secondary.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedGift,
              color: AppColors.secondary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _MadeInAbaPromo extends StatelessWidget {
  const _MadeInAbaPromo();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(
          color: isDark ? Colors.transparent : AppColors.outline.withAlpha(100),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedStore01,
            color: isDark ? AppColors.secondary : AppColors.primary,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Made in Nigeria',
            style: AppTypography.h5.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Discover authentic products manufactured directly from the source. Support local industries.',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
