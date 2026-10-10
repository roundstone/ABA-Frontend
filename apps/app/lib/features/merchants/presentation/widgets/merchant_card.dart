import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_entities.dart';
import 'merchant_card_details.dart';
import 'merchant_card_visuals.dart';

/// Compact card rendering a verified merchant in the public directory.
class MerchantCard extends StatelessWidget {
  const MerchantCard({
    super.key,
    required this.merchant,
    this.onTap,
  });

  final Merchant merchant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
    final borderColor = isDark
        ? Colors.white.withAlpha(20)
        : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner area with featured tag & overlapping avatar
          SizedBox(
            height: 110,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 86,
                  child: MerchantBannerImage(imageUrl: merchant.bannerImage),
                ),
                if (merchant.isFeatured)
                  Positioned(
                    top: AppSpacing.xs + 2,
                    right: AppSpacing.xs + 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs + 2,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(240),
                        borderRadius: AppSpacing.borderRadiusSM,
                      ),
                      child: Text(
                        'FEATURED',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: AppSpacing.md,
                  bottom: 0,
                  child: MerchantLogoAvatar(
                    logoUrl: merchant.logoUrl,
                    name: merchant.name,
                  ),
                ),
                Positioned(
                  left: AppSpacing.md + 44 + AppSpacing.sm,
                  right: AppSpacing.md,
                  bottom: 4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs + 2,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2A2A2A)
                            : AppColors.surface2,
                        borderRadius: AppSpacing.borderRadiusSM,
                      ),
                      child: Text(
                        merchant.category,
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content body
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business Name + Verified badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        merchant.name,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (merchant.isVerified) ...[
                      const SizedBox(width: 4),
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedShieldCheck,
                        color: AppColors.success,
                        size: 16,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: AppSpacing.xs),

                // Rating & Review count
                MerchantRatingRow(merchant: merchant),

                const SizedBox(height: AppSpacing.xs + 2),

                // Location & Order info
                MerchantMetaRow(merchant: merchant),

                const SizedBox(height: AppSpacing.md),

                // Action button: "Visit Store"
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: OutlinedButton(
                    onPressed: onTap ??
                        () {
                          context.go(
                            '/shop?merchant=${Uri.encodeComponent(merchant.name)}',
                          );
                        },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withAlpha(40)
                            : AppColors.border,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusMD,
                      ),
                      backgroundColor: isDark
                          ? const Color(0xFF282828)
                          : AppColors.surface2,
                    ),
                    child: Text(
                      'Visit Store',
                      style: AppTypography.buttonMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.onBackground,
                      ),
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
