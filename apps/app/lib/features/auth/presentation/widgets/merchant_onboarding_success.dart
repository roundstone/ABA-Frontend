import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

/// Screen displayed upon successful completion of the merchant onboarding wizard.
class MerchantOnboardingSuccess extends StatelessWidget {
  const MerchantOnboardingSuccess({
    super.key,
    this.isProvisional = false,
  });

  final bool isProvisional;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isProvisional
                      ? const Color(0xFFC28B38).withAlpha(isDark ? 40 : 20)
                      : AppColors.success.withAlpha(isDark ? 40 : 20),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: HugeIcon(
                    icon: isProvisional
                        ? HugeIcons.strokeRoundedHourglass
                        : HugeIcons.strokeRoundedCheckmarkCircle02,
                    color: isProvisional ? const Color(0xFFC28B38) : AppColors.success,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                isProvisional
                    ? 'Provisional Storefront Created!'
                    : 'Application Submitted for Review!',
                style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                decoration: BoxDecoration(
                  color: isProvisional
                      ? const Color(0xFFC28B38).withAlpha(25)
                      : AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isProvisional
                      ? 'PROVISIONAL STATUS • 60 DAYS REMAINING'
                      : 'STATUS: UNDER ADMIN VERIFICATION',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isProvisional ? const Color(0xFFC28B38) : AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                isProvisional
                    ? 'Welcome to BuyNaija! Your store is provisionally active. Please complete and submit your CAC registration within 60 days to unlock full verified merchant status.'
                    : 'Our verification team is reviewing your CAC, NIN, and workshop details. Verification typically completes within 24–48 hours.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton.primary(
                label: 'Open Merchant Hub',
                onPressed: () => context.go('/merchant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
