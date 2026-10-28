import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../shop/presentation/widgets/product_card.dart';
import '../application/merchant_providers.dart';
import 'widgets/merchant_profile_header.dart';

class MerchantDetailScreen extends ConsumerWidget {
  const MerchantDetailScreen({super.key, required this.merchantId});

  final String merchantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantAsync = ref.watch(merchantDetailProvider(merchantId));
    final productsAsync = ref.watch(merchantProductsProvider(merchantId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF172A1D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Colors.white,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/merchants'),
        ),
        title: Text(
          merchantAsync.valueOrNull?.name ?? 'Merchant Profile',
          style: AppTypography.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'View Cart',
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingBag01,
              color: Colors.white,
            ),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) context.popOrGo('/merchants');
        },
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(merchantDetailProvider(merchantId));
            ref.invalidate(merchantProductsProvider(merchantId));
            await Future.wait([
              ref.read(merchantDetailProvider(merchantId).future),
              ref.read(merchantProductsProvider(merchantId).future),
            ]);
          },
          child: merchantAsync.when(
            loading: () => const LoadingState(message: 'Loading store details…'),
            error: (err, _) => ErrorState(
              message: err.toString(),
              onRetry: () => ref.invalidate(merchantDetailProvider(merchantId)),
            ),
            data: (merchant) {
              if (merchant == null) {
                return ErrorState(
                  message: 'Merchant not found',
                  onRetry: () => ref.invalidate(merchantDetailProvider(merchantId)),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverToBoxAdapter(
                      child: MerchantProfileHeader(merchant: merchant),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Products by this Store',
                            style: AppTypography.h5.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.onBackground,
                            ),
                          ),
                          const SizedBox(width: 8),
                          productsAsync.maybeWhen(
                            data: (items) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: AppSpacing.borderRadiusSM,
                              ),
                              child: Text(
                                '${items.length}',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            orElse: () => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...productsAsync.when(
                    data: (products) {
                      if (products.isEmpty) {
                        return [
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text('No products currently listed by this store.'),
                              ),
                            ),
                          ),
                        ];
                      }
                      return [
                        SliverPadding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => ProductCard(product: products[index]),
                              childCount: products.length,
                            ),
                          ),
                        ),
                      ];
                    },
                    loading: () => [
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: LoadingState(message: 'Loading store products…'),
                        ),
                      ),
                    ],
                    error: (e, _) => [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: ErrorState(
                            message: 'Failed to load store products',
                            onRetry: () => ref.invalidate(merchantProductsProvider(merchantId)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 60)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
