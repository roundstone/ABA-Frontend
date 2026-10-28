import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_entities.dart';
import 'merchant_card_visuals.dart';

class MerchantProfileHeader extends StatelessWidget {
  const MerchantProfileHeader({super.key, required this.merchant});

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusXL,
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(20) : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 130,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  bottom: 25,
                  child: MerchantBannerImage(imageUrl: merchant.bannerImage),
                ),
                Positioned(
                  left: AppSpacing.md,
                  bottom: 0,
                  child: MerchantLogoAvatar(
                    logoUrl: merchant.logoUrl,
                    name: merchant.name,
                  ),
                ),
                if (merchant.isVerified)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppSpacing.borderRadiusSM,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedShieldCheck,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'VERIFIED',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant.name,
                  style: AppTypography.h4.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.onBackground,
                  ),
                ),
                if (merchant.category.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(25),
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                    child: Text(
                      merchant.category,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      merchant.rating.toStringAsFixed(1),
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${merchant.reviewCount} reviews)',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? Colors.white60 : AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Joined ${merchant.joinedYear}',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? Colors.white60 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (merchant.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    merchant.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? Colors.white70 : AppColors.onBackground,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.sm),
                if (merchant.address.isNotEmpty)
                  _buildMetaTile(context, HugeIcons.strokeRoundedLocation01, merchant.address),
                if (merchant.ownerName.isNotEmpty)
                  _buildMetaTile(context, HugeIcons.strokeRoundedUser, 'Owner: ${merchant.ownerName}'),
                if (merchant.phone.isNotEmpty)
                  _buildMetaTile(context, HugeIcons.strokeRoundedCall, merchant.phone, canCopy: true),
                if (merchant.email.isNotEmpty)
                  _buildMetaTile(context, HugeIcons.strokeRoundedMail01, merchant.email, canCopy: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTile(BuildContext context, dynamic icon, String text, {bool canCopy = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            color: isDark ? Colors.white60 : AppColors.textSecondary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? Colors.white70 : AppColors.onBackground,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (canCopy)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied $text'),
                    duration: const Duration(milliseconds: 900),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedCopy01,
                  color: AppColors.primary,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
