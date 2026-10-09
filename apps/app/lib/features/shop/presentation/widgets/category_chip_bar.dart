import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:app/features/shop/domain/shop_entities.dart';
import 'package:flutter/material.dart';
// import '../../../core/theme/app_spacing.dart';
// import '../../../core/theme/app_typography.dart';
// import '../../shop/domain/shop_entities.dart';

/// Horizontal scrollable category chip strip.
class CategoryChipBar extends StatelessWidget {
  const CategoryChipBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<ShopCategory> categories;
  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? cs.secondary : cs.primary;

    return SizedBox(
      height: 32,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, i) {
          if (i == 0) {
            final isAll = selected == null;
            return _CategoryChip(
              label: 'All',
              isSelected: isAll,
              onTap: () => onSelect(null),
              primaryColor: primaryColor,
              isDark: isDark,
            );
          }
          final cat = categories[i - 1];
          final isSel = selected == cat.name;
          return _CategoryChip(
            label: cat.name,
            isSelected: isSel,
            onTap: () => onSelect(isSel ? null : cat.name),
            primaryColor: primaryColor,
            isDark: isDark,
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.isDark,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textColor = isSelected
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? Colors.white70 : primaryColor);
    final bgColor = isSelected
        ? primaryColor
        : (isDark ? cs.surfaceContainerHighest : primaryColor.withAlpha(15));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppSpacing.avatarRadius,
          border: isSelected ? null : Border.all(color: isDark ? Colors.transparent : primaryColor.withAlpha(50)),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
