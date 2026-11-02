import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snackbar.dart';

class ReferralActiveCodeView extends StatelessWidget {
  const ReferralActiveCodeView({super.key, required this.referralCode});

  final String referralCode;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withAlpha(isDark ? 30 : 15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      'Your referral code is ready. Share with friends to earn.',
                      style: AppTypography.caption.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withAlpha(50)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCopy01,
                  size: 18,
                  color: AppColors.success,
                ),
                tooltip: 'Copy Code',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: referralCode));
                  AppSnackbar.show(
                    context,
                    message: 'Referral code copied to clipboard!',
                    type: AppSnackbarType.info,
                  );
                },
              ),
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShare01,
                  size: 18,
                  color: AppColors.primary,
                ),
                tooltip: 'Share',
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(
                      text:
                          'Join me on BuyNaija! Use my referral code: $referralCode when signing up: https://abaonline.vercel.app/community/$referralCode',
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
