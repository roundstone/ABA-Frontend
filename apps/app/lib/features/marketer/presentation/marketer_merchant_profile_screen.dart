import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../../merchants/application/merchant_providers.dart';
import '../application/marketer_providers.dart';
import 'widgets/marketer_merchant_header_card.dart';
import 'widgets/marketer_merchant_products_grid.dart';

class MarketerMerchantProfileScreen extends ConsumerWidget {
  const MarketerMerchantProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final merchantAsync = ref.watch(associatedMerchantProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF172A1D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Associated Merchant',
          style: AppTypography.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: merchantAsync.when(
        loading: () => const LoadingState(message: 'Loading merchant profile…'),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(associatedMerchantProvider),
        ),
        data: (merchant) {
          if (merchant == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedStore01,
                      color: AppColors.grey,
                      size: 48,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'No Merchant Found',
                      style: AppTypography.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'You have not been assigned to a merchant store yet.',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final productsAsync = ref.watch(merchantProductsProvider(merchant.id));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(associatedMerchantProvider);
              ref.invalidate(merchantProductsProvider(merchant.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MarketerMerchantHeaderCard(merchant: merchant),

                  const SizedBox(height: AppSpacing.md),

                  _buildAffiliationCard(merchant, isDark),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Store Products (${merchant.productCount})',
                        style: AppTypography.h4.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          final code = user?.referralCode ?? '';
                          Clipboard.setData(
                            ClipboardData(
                              text:
                                  'https://buynaija.ng/merchants/${merchant.id}?ref=$code',
                            ),
                          );
                          AppSnackbar.info(context, 'Store promotional link copied!');
                        },
                        icon: const Icon(Icons.share_outlined, size: 16),
                        label: const Text('Share Store'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  MarketerMerchantProductsGrid(
                    products: productsAsync.valueOrNull ?? const [],
                    isLoading: productsAsync.isLoading,
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAffiliationCard(dynamic merchant, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withAlpha(50)
            : AppColors.primary.withAlpha(16),
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.primary.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.handshake_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'OFFICIAL MARKETER AFFILIATION',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.secondary : AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'You are registered as an authorized sales marketer for ${merchant.name}. You earn automated tier commissions on all customer sales generated.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : AppColors.onBackground,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
