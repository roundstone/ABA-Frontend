import 'package:flutter/material.dart';
import 'package:app/features/merchants/domain/merchant_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MarketerMerchantHeaderCard extends StatelessWidget {
  const MarketerMerchantHeaderCard({
    super.key,
    required this.merchant,
  });

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: isDark
                    ? AppColors.primary.withAlpha(60)
                    : AppColors.secondary,
                child: Text(
                  merchant.name.isNotEmpty
                      ? merchant.name[0].toUpperCase()
                      : 'M',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            merchant.name,
                            style: AppTypography.h4.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (merchant.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: AppColors.success,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${merchant.city}, ${merchant.state}',
                      style: AppTypography.caption.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (merchant.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              merchant.description,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(Icons.location_on_outlined, merchant.address, isDark),
          const SizedBox(height: 4),
          _buildInfoRow(Icons.phone_outlined, merchant.phone, isDark),
          const SizedBox(height: 4),
          _buildInfoRow(Icons.email_outlined, merchant.email, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
