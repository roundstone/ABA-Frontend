import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/merchant_entities.dart';

void showMerchantSortSheet({
  required BuildContext context,
  required MerchantSort currentSort,
  required ValueChanged<MerchantSort> onSelected,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => MerchantSortSheet(
      currentSort: currentSort,
      onSelected: (sort) {
        Navigator.of(ctx).pop();
        onSelected(sort);
      },
    ),
  );
}

class MerchantSortSheet extends StatelessWidget {
  const MerchantSortSheet({
    super.key,
    required this.currentSort,
    required this.onSelected,
  });

  final MerchantSort currentSort;
  final ValueChanged<MerchantSort> onSelected;

  static const _sortOptions = [
    (MerchantSort.recommended, 'Recommended', HugeIcons.strokeRoundedAward01),
    (MerchantSort.rating, 'Highest Rated', HugeIcons.strokeRoundedStar),
    (MerchantSort.orders, 'Most Orders', HugeIcons.strokeRoundedShoppingBag01),
    (MerchantSort.newest, 'Newest Sellers', HugeIcons.strokeRoundedCalendar03),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: AppSpacing.avatarRadius,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Sort Businesses',
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          ..._sortOptions.map((opt) {
            final isSelected = currentSort == opt.$1;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: HugeIcon(
                icon: opt.$3,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white60 : AppColors.grey),
                size: 20,
              ),
              title: Text(
                opt.$2,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? AppColors.secondary : AppColors.primary)
                      : (isDark ? Colors.white : AppColors.onBackground),
                ),
              ),
              trailing: isSelected
                  ? const HugeIcon(
                      icon: HugeIcons.strokeRoundedTick02,
                      color: AppColors.success,
                      size: 20,
                    )
                  : null,
              onTap: () => onSelected(opt.$1),
            );
          }),
        ],
      ),
    );
  }
}
