import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../application/referral_activation_provider.dart';
import 'referral_activation_sheet.dart';

/// Card showing referral code status & commission earning activation state.
class ReferralActivationCard extends ConsumerWidget {
  const ReferralActivationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(referralActivationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isActive) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.success.withAlpha(isDark ? 30 : 15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withAlpha(80)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commission Earning Active',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    'KYC verified • ₦5,000 shopping credit active in wallet',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF241C10) : const Color(0xFFFFFBF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC28B38).withAlpha(isDark ? 90 : 60),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFC28B38),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'COMMISSION INACTIVE',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                'Code: ${state.referralCode}',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFC28B38),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Activate Your Referral Account',
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Every user gets a code upon registration, but earning commissions requires completing KYC verification and the one-time ₦5,000 membership fee.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.white10 : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedCoins01,
                  color: Color(0xFFC28B38),
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Fee is 100% credited to your shopping wallet for purchasing BuyNaija products (non-withdrawable).',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : AppColors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Note: Users who only wish to shop can do so freely without activating their referral codes.',
            style: AppTypography.caption.copyWith(
              fontStyle: FontStyle.italic,
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            label: 'Activate Earning (KYC & ₦5,000 Fee)',
            onPressed: () => ReferralActivationSheet.show(context),
          ),
        ],
      ),
    );
  }
}
