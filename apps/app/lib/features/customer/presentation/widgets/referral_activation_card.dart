import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/referral_activation_provider.dart';
import 'referral_activation_sheet.dart';
// import 'referral_active_code_view.dart';

/// Card showing referral code status & commission earning activation state.
class ReferralActivationCard extends ConsumerWidget {
  const ReferralActivationCard({super.key});

  Future<void> _handleGenerateCode(BuildContext context, WidgetRef ref) async {
    try {
      final code = await ref
          .read(referralActivationProvider.notifier)
          .generateReferralCode();
      if (context.mounted && code != null) {
        AppSnackbar.show(
          context,
          message: 'Referral code $code generated successfully!',
          type: AppSnackbarType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.show(
          context,
          message: ApiError.toUserFriendlyMessage(e),
          type: AppSnackbarType.error,
        );
      }
    }
  }

  void _handleActivateKyc(BuildContext context) {
    ReferralActivationSheet.show(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(referralActivationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isLoading) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              // if (state.hasCode)
              //   Text(
              //     'Code: ${state.referralCode}',
              //     style: AppTypography.caption.copyWith(
              //       fontWeight: FontWeight.w800,
              //       color: const Color(0xFFC28B38),
              //     ),
              //   ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Activate Your Referral Account',
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Complete KYC verification and pay the ₦5,000 activation fee (100% credited to your shopping wallet) to unlock referral commission earnings.',
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
                  icon: HugeIcons.strokeRoundedGift,
                  color: Color(0xFFC28B38),
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Earn direct commissions on every purchase made with your code.',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : AppColors.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.primary(
            label: 'Complete KYC & Activate (₦5,000)',
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUserCheck01,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => _handleActivateKyc(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (!state.hasCode)
            AppButton.outlined(
              label: state.isGenerating
                  ? 'Generating...'
                  : 'Generate Referral Code',
              isLoading: state.isGenerating,
              onPressed: state.isGenerating
                  ? null
                  : () => _handleGenerateCode(context, ref),
            )
          else
            AppButton.outlined(
              label: 'Share Referral Code',
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    text:
                        'Join me on BuyNaija! Use my referral code: ${state.referralCode} when signing up: https://aba-erp.com/register?ref=${state.referralCode}',
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
