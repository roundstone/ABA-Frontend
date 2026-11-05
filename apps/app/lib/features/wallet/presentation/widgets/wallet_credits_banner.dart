import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/wallet_entities.dart';

class WalletCreditsBanner extends StatelessWidget {
  const WalletCreditsBanner({
    super.key,
    this.credits,
    this.isLoading = false,
    this.onRetry,
  });

  final ShoppingCreditInfo? credits;
  final bool isLoading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF261C08) : const Color(0xFFFFFBEB);
    final borderColor = isDark ? const Color(0xFF45300B) : const Color(0xFFFDE68A);
    final primaryTextColor = isDark ? const Color(0xFFFDE68A) : const Color(0xFF78350F);
    final secondaryTextColor = isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E);
    final badgeBg = isDark ? const Color(0xFF45300B) : const Color(0xFFFEF3C7);
    final badgeTextColor = isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E);
    final dividerColor = isDark ? const Color(0xFF45300B) : const Color(0xFFFDE68A);

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedShoppingBag02,
                    color: primaryTextColor,
                    size: AppSpacing.iconSizeSM,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Credits',
                    style: AppTypography.bodyMedium.copyWith(
                      color: primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'NON-WITHDRAWABLE',
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceSM,
          if (isLoading && credits == null)
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryTextColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading credits...',
                  style: AppTypography.caption.copyWith(color: secondaryTextColor),
                ),
              ],
            )
          else
            Text(
              formatNaira(credits?.balance ?? 0.0),
              style: AppTypography.h4.copyWith(
                color: primaryTextColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          const SizedBox(height: 6),
          Text(
            'Credited from referral activation fee. Valid for purchasing all BuyNaija marketplace products.',
            style: AppTypography.caption.copyWith(
              color: secondaryTextColor.withAlpha(220),
              fontSize: 12,
              height: 1.4,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: dividerColor)),
            ),
            child: Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedShieldCheck,
                  color: secondaryTextColor,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Automatically applied at checkout',
                    style: AppTypography.caption.copyWith(
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

