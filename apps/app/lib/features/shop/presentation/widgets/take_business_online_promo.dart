import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/config/app_brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Mobile representation of the "Take Your Business Online" merchant acquisition banner.
class TakeBusinessOnlinePromo extends StatelessWidget {
  const TakeBusinessOnlinePromo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2820) : const Color(0xFFF1F6F2);
    final borderColor = isDark ? const Color(0xFF2C3E30) : const Color(0xFFDCE8DF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(isDark ? 80 : 30),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedStore01,
                color: AppColors.primary,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            'Take Your Business Online',
            style: AppTypography.h4.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),

          // Description
          Text(
            'Whether you run a workshop, boutique, wholesale store, or emerging brand, ${AppBrand.shortName} gives you a digital storefront to reach millions of buyers nationwide.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // 3 Feature Checklist Items
          const Column(
            children: [
              _FeatureCheckItem(text: 'Create your digital storefront'),
              SizedBox(height: AppSpacing.xs),
              _FeatureCheckItem(text: 'List products & set wholesale prices'),
              SizedBox(height: AppSpacing.xs),
              _FeatureCheckItem(text: 'Manage orders & in-store POS seamlessly'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // CTA: Become a Merchant
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/merchants/onboarding'),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedSparkles,
                color: Colors.white,
                size: 18,
              ),
              label: Text(
                'Become a Merchant',
                style: AppTypography.buttonMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppSpacing.avatarRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCheckItem extends StatelessWidget {
  const _FeatureCheckItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedCheckmarkCircle02,
          color: AppColors.success,
          size: 18,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
