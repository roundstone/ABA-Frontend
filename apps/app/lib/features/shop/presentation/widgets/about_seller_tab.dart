import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../merchants/domain/merchant_entities.dart';
import 'product_reviews_section.dart';

class AboutSellerTab extends StatelessWidget {
  const AboutSellerTab({
    super.key,
    required this.merchantName,
    required this.productId,
    this.merchantId,
    this.merchant,
    this.reviewsKey,
    this.onMessageSeller,
  });

  final String merchantName;
  final String productId;
  final String? merchantId;
  final Merchant? merchant;
  final Key? reviewsKey;
  final VoidCallback? onMessageSeller;

  void _navigateToMerchant(BuildContext context) {
    final target = (merchantId != null && merchantId!.isNotEmpty)
        ? merchantId!
        : (merchantName.isNotEmpty ? merchantName : null);
    if (target != null) {
      context.push('/merchants/$target');
    } else {
      context.push('/merchants');
    }
  }

  String _sellerStatsText() {
    final m = merchant;
    if (m == null) return 'Marketplace seller';
    final parts = <String>[
      if (m.reviewCount > 0)
        '${m.rating.toStringAsFixed(1)} ★ (${m.reviewCount} reviews)',
      if (m.ordersCount > 0) '${m.ordersCount} orders',
      if (m.ordersCount == 0 && m.productCount > 0) '${m.productCount} products',
    ];
    if (parts.isNotEmpty) return parts.join(' • ');
    if (m.city.isNotEmpty) {
      return m.state.isNotEmpty ? '${m.city}, ${m.state}' : m.city;
    }
    return m.isVerified ? 'Verified seller' : 'Marketplace seller';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.secondary : cs.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seller Info
        InkWell(
          onTap: () => _navigateToMerchant(context),
          borderRadius: AppSpacing.borderRadiusMD,
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedStore01,
                    size: 28,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchantName,
                      style: AppTypography.h6.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _sellerStatsText(),
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Joined Date
        Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar01,
              size: 16,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              merchant != null
                  ? 'Joined ${merchant!.joinedYear}'
                  : 'Marketplace seller',
              style: AppTypography.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Actions
        AppButton.primary(
          label: 'Visit store',
          backgroundColor: color,
          foregroundColor: isDark ? cs.onPrimary : Colors.white,
          onPressed: () => _navigateToMerchant(context),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton.outlined(
          label: 'Message seller',
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedMessage01,
            size: 18,
            color: color,
          ),
          foregroundColor: color,
          borderSide: BorderSide(color: color.withAlpha(50)),
          onPressed: onMessageSeller,
        ),

        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        const SizedBox(height: AppSpacing.xl),

        // All this would be implemented in the future
        // const SellerRatingsSection(),

        // const SizedBox(height: AppSpacing.xl),
        // const Divider(),
        // const SizedBox(height: AppSpacing.xl),

        // // Popular categories
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: [
        //     Text(
        //       'Popular categories',
        //       style: AppTypography.bodyMedium.copyWith(
        //         fontWeight: FontWeight.w700,
        //       ),
        //     ),
        //     Text(
        //       'See all',
        //       style: AppTypography.label.copyWith(
        //         color: color,
        //         decoration: TextDecoration.underline,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: AppSpacing.sm),
        // Wrap(
        //   spacing: AppSpacing.xs,
        //   runSpacing: AppSpacing.xs,
        //   children: [
        //     Chip(
        //       label: const Text('Consumer Electronics'),
        //       labelStyle: AppTypography.label,
        //       backgroundColor: cs.surfaceContainerHighest.withAlpha(100),
        //       side: const BorderSide(color: AppColors.border),
        //     ),
        //     Chip(
        //       label: const Text('Fashion & Apparel'),
        //       labelStyle: AppTypography.label,
        //       backgroundColor: cs.surfaceContainerHighest.withAlpha(100),
        //       side: const BorderSide(color: AppColors.border),
        //     ),
        //   ],
        // ),

        // const SizedBox(height: AppSpacing.xl),
        // const Divider(),
        // const SizedBox(height: AppSpacing.xl),

        // Referral Network
        // Text(
        //   'Referral Network',
        //   style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        // ),
        // const SizedBox(height: AppSpacing.sm),
        // Container(
        //   padding: const EdgeInsets.all(AppSpacing.md),
        //   decoration: BoxDecoration(
        //     color: color.withAlpha(20),
        //     borderRadius: AppSpacing.borderRadiusLG,
        //     border: Border.all(color: color.withAlpha(50)),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'This merchant is part of the Aba Online referral network. You can earn commissions by referring their products!',
        //         style: AppTypography.bodySmall.copyWith(color: color),
        //       ),
        //       const SizedBox(height: AppSpacing.md),
        //       AppButton.outlined(
        //         label: 'Join their network',
        //         foregroundColor: color,
        //         borderSide: BorderSide(color: color.withAlpha(100)),
        //         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //         onPressed: () => context.push('/referrals'),
        //       ),
        //     ],
        //   ),
        // ),

        // const SizedBox(height: AppSpacing.xl),
        // const Divider(),
        // const SizedBox(height: AppSpacing.xl),
        ProductReviewsSection(key: reviewsKey, productId: productId),
      ],
    );
  }
}
