import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import 'product_reviews_section.dart';
import 'seller_ratings_section.dart';

class AboutSellerTab extends StatelessWidget {
  const AboutSellerTab({
    super.key,
    required this.merchantName,
    required this.productId,
    this.merchantId,
    this.reviewsKey,
  });

  final String merchantName;
  final String productId;
  final String? merchantId;
  final Key? reviewsKey;

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
                      '99.9% positive feedback • 5.7K items sold',
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
              'Joined Oct 2025',
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
          onPressed: () {},
        ),

        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        const SizedBox(height: AppSpacing.xl),

        const SellerRatingsSection(),

        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        const SizedBox(height: AppSpacing.xl),

        // Popular categories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Popular categories',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'See all',
              style: AppTypography.label.copyWith(
                color: color,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            Chip(
              label: const Text('Consumer Electronics'),
              labelStyle: AppTypography.label,
              backgroundColor: cs.surfaceContainerHighest.withAlpha(100),
              side: const BorderSide(color: AppColors.border),
            ),
            Chip(
              label: const Text('Fashion & Apparel'),
              labelStyle: AppTypography.label,
              backgroundColor: cs.surfaceContainerHighest.withAlpha(100),
              side: const BorderSide(color: AppColors.border),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        const SizedBox(height: AppSpacing.xl),

        // Referral Network
        Text(
          'Referral Network',
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: AppSpacing.borderRadiusLG,
            border: Border.all(color: color.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This merchant is part of the Aba Online referral network. You can earn commissions by referring their products!',
                style: AppTypography.bodySmall.copyWith(color: color),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton.outlined(
                label: 'Join their network',
                foregroundColor: color,
                borderSide: BorderSide(color: color.withAlpha(100)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onPressed: () => context.push('/referrals'),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),
        const Divider(),
        const SizedBox(height: AppSpacing.xl),
        ProductReviewsSection(key: reviewsKey, productId: productId),
      ],
    );
  }
}
