import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MarketerReferralBanner extends StatelessWidget {
  const MarketerReferralBanner({
    super.key,
    required this.referralCode,
    required this.isDark,
  });

  final String referralCode;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withAlpha(50)
            : AppColors.primary.withAlpha(16),
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.primary.withAlpha(40),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedNetwork,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Referral Code: $referralCode',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'All onboarded customers earn you commissions automatically.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Copy code',
            icon: const Icon(Icons.copy_rounded, size: 18),
            color: AppColors.primary,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: referralCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Referral code copied!')),
              );
            },
          ),
        ],
      ),
    );
  }
}

