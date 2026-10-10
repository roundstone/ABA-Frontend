import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_entities.dart';

class MerchantToolbar extends StatelessWidget {
  const MerchantToolbar({
    super.key,
    required this.totalCount,
    required this.currentSort,
    required this.hasActiveFilters,
    required this.activeFiltersCount,
    required this.onTapFilter,
    required this.onTapSort,
  });

  final int totalCount;
  final MerchantSort currentSort;
  final bool hasActiveFilters;
  final int activeFiltersCount;
  final VoidCallback onTapFilter;
  final VoidCallback onTapSort;

  String get _sortLabel {
    switch (currentSort) {
      case MerchantSort.recommended:
        return 'Recommended';
      case MerchantSort.rating:
        return 'Top Rated';
      case MerchantSort.orders:
        return 'Most Orders';
      case MerchantSort.newest:
        return 'Newest';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total count label
          Text(
            '$totalCount ${totalCount == 1 ? 'business' : 'businesses'}',
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Actions: Filters & Sort
          Row(
            children: [
              // Filter button
              InkWell(
                onTap: onTapFilter,
                borderRadius: AppSpacing.borderRadiusMD,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: hasActiveFilters
                        ? AppColors.primary.withAlpha(isDark ? 50 : 20)
                        : (isDark ? const Color(0xFF282828) : AppColors.surface2),
                    borderRadius: AppSpacing.borderRadiusMD,
                    border: Border.all(
                      color: hasActiveFilters
                          ? AppColors.primary
                          : (isDark ? Colors.white12 : AppColors.border),
                    ),
                  ),
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedFilter,
                        color: hasActiveFilters
                            ? AppColors.primary
                            : (isDark ? Colors.white : AppColors.onBackground),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Filter',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: hasActiveFilters
                              ? AppColors.primary
                              : (isDark ? Colors.white : AppColors.onBackground),
                        ),
                      ),
                      if (hasActiveFilters && activeFiltersCount > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$activeFiltersCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.xs),

              // Sort button
              InkWell(
                onTap: onTapSort,
                borderRadius: AppSpacing.borderRadiusMD,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF282828) : AppColors.surface2,
                    borderRadius: AppSpacing.borderRadiusMD,
                    border: Border.all(
                      color: isDark ? Colors.white12 : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedSorting01,
                        color: isDark ? Colors.white : AppColors.onBackground,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _sortLabel,
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
