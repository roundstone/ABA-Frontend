import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/config/app_brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class RewardsPromo extends StatelessWidget {
  const RewardsPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
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

class MadeInAbaPromo extends StatelessWidget {
  const MadeInAbaPromo({super.key});

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
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => context.go('/merchants'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? Colors.white30 : AppColors.primary,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppSpacing.avatarRadius,
              ),
            ),
            child: Text(
              'Explore Verified Businesses',
              style: AppTypography.buttonMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
