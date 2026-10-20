import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class ReferralPaymentStepView extends StatelessWidget {
  const ReferralPaymentStepView({
    super.key,
    required this.isProcessing,
    required this.onPay,
    required this.onBack,
  });

  final bool isProcessing;
  final VoidCallback onPay;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: const Color(0xFFC28B38).withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedCoins01,
                color: Color(0xFFC28B38),
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Step 2 of 2: Activation Fee',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: const Color(0xFFC28B38).withAlpha(isDark ? 30 : 15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC28B38).withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registration Fee: ₦5,000',
                style: AppTypography.h3.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFC28B38),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '100% Credited to Your Shopping Wallet!',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Your fee is credited immediately to your BuyNaija wallet. It cannot be withdrawn, but you can use it anytime to purchase any products across BuyNaija.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Pay ₦5,000 & Activate Referral Earning',
          isLoading: isProcessing,
          onPressed: onPay,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton.text(label: 'Back to KYC', onPressed: onBack),
      ],
    );
  }
}

class ReferralSuccessStepView extends StatelessWidget {
  const ReferralSuccessStepView({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
            color: AppColors.success,
            size: 56,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Referral Account Activated!',
          style: AppTypography.h3.copyWith(fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'You can now earn commissions when people register or shop with your referral code. ₦5,000 has been credited to your Shopping Wallet.',
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            height: 1.45,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Start Sharing & Earning',
          onPressed: onClose,
        ),
      ],
    );
  }
}
