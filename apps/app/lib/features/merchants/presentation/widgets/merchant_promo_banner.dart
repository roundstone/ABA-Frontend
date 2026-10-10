import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Call-to-action banner inviting sellers to take their business online.
class MerchantPromoBanner extends StatelessWidget {
  const MerchantPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2620) : const Color(0xFFF1F6F2),
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(
          color: isDark
              ? const Color(0xFF2E4032)
              : AppColors.primary.withAlpha(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(isDark ? 50 : 20),
              shape: BoxShape.circle,
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedStore01,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Take Your Business Online',
            style: AppTypography.h4.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Whether you run a workshop, fashion brand, hardware shop, or wholesale warehouse, ABA Marketplace connects you to millions of buyers.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          const _BenefitRow(label: 'Digital verified storefront'),
          const SizedBox(height: 6),
          const _BenefitRow(label: 'Direct escrow & wallet payouts'),
          const SizedBox(height: 6),
          const _BenefitRow(label: 'Built-in POS & logistics tracking'),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                context.go('/merchant');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppSpacing.avatarRadius,
                ),
                elevation: 0,
              ),
              child: Text(
                'Become a Merchant',
                style: AppTypography.buttonMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedCheckmarkCircle02,
          color: AppColors.success,
          size: 16,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
