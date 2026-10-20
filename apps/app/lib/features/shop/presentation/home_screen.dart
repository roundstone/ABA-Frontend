import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/config/app_brand.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/notification_icon_button.dart';
import '../application/shop_providers.dart';
import '../domain/shop_entities.dart';
import 'widgets/home_category_marquee.dart';
import 'widgets/home_hero_banner.dart';
import 'widgets/home_merchant_sections.dart';
import 'widgets/home_promos.dart';
import 'widgets/home_section_header.dart';

/// Mobile Storefront Home Screen matching Web Storefront content & structure.
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
            leading: context.canPopSafely
                ? IconButton(
                    tooltip: 'Back',
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: isDark ? Colors.white : AppColors.onBackground,
                      size: 20,
                    ),
                    onPressed: () => context.popOrGo('/home'),
                  )
                : null,
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
                onPressed: () => context.go('/shop'),
              ),
              NotificationIconButton(color: actionColor),
              const SizedBox(width: AppSpacing.xs),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Banner Carousel
                  HomeHeroBanner(imageUrl: catalogue.featuredBannerUrl),
                  const SizedBox(height: AppSpacing.xxl),

                  // 2. Product Spotlight (Featured Products)
                  if (featured.isNotEmpty) ...[
                    HomeSectionHeader(
                      title: 'Featured Products',
                      subtitle: 'Discover top picks sponsored by our merchants',
                      onSeeAll: () => context.go('/shop'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    HomeProductHorizontalList(products: featured),
                    const SizedBox(height: AppSpacing.xxl),
                  ],

                  // 3. Trending Products
                  if (trending.isNotEmpty) ...[
                    HomeSectionHeader(
                      title: 'Trending on ${AppBrand.shortName}',
                      subtitle: 'Popular items our customers are loving right now',
                      onSeeAll: () => context.go('/shop'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    HomeProductHorizontalList(products: trending),
                    const SizedBox(height: AppSpacing.xxl),
                  ],

                  // 4. Meet Businesses
                  HomeSectionHeader(
                    title: "Meet Nigeria's Businesses",
                    subtitle: 'Connect directly with makers and sellers behind every product',
                    onSeeAll: () => context.go('/merchants'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const HomeMeetBusinessesSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // 5. Category Marquee
                  if (catalogue.categories.isNotEmpty) ...[
                    HomeSectionHeader(
                      title: 'Explore Categories',
                      subtitle: 'Browse by craft, material & industry',
                      onSeeAll: () => context.go('/shop'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    HomeCategoryMarquee(categories: catalogue.categories),
                    const SizedBox(height: AppSpacing.xxl),
                  ],

                  // 6. Merchant Spotlight Showcase
                  HomeSectionHeader(
                    title: 'Merchant Spotlight',
                    subtitle: 'Top-rated sellers providing exceptional quality & service',
                    onSeeAll: () => context.go('/merchants'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const HomeMerchantSpotlightSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // 7. Rewards Program Promo ("Shop. Refer. Earn. Grow.")
                  const RewardsPromo(),
                  const SizedBox(height: AppSpacing.xxl),

                  // 8. Made in Nigeria Showcase
                  const MadeInAbaPromo(),
                  const SizedBox(height: AppSpacing.xxl),

                  // 9. Take Your Business Online CTA
                  const TakeBusinessOnlinePromo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
