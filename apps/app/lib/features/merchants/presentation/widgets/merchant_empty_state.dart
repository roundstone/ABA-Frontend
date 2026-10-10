import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MerchantEmptyState extends StatelessWidget {
  const MerchantEmptyState({
    super.key,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF262626) : AppColors.surface2,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: HugeIcon(
                  icon: hasActiveFilters
                      ? HugeIcons.strokeRoundedFilter
                      : HugeIcons.strokeRoundedStore01,
                  color: AppColors.grey,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              hasActiveFilters
                  ? 'No businesses match your filters'
                  : 'No businesses yet',
              style: AppTypography.h4.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              hasActiveFilters
                  ? 'Try clearing your filters or searching for something else.'
                  : 'Check back soon as verified artisans and manufacturers join.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasActiveFilters) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCancel01,
                  color: AppColors.primary,
                  size: 16,
                ),
                label: Text(
                  'Clear All Filters',
                  style: AppTypography.buttonMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? Colors.white30 : AppColors.primary,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppSpacing.avatarRadius,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
