import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Single chip representing a top-level category with optional subcategory indicator.
class CategoryChipItem extends StatelessWidget {
  const CategoryChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.isDark,
    this.count,
    this.hasActiveChild = false,
    this.hasChildren = false,
    this.isExpanded = false,
    this.onToggleExpand,
  });

  final String label;
  final int? count;
  final bool isSelected;
  final bool hasActiveChild;
  final bool hasChildren;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback? onToggleExpand;
  final Color primaryColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isHighlighted = isSelected || hasActiveChild;
    final textColor = isSelected
        ? (isDark ? Colors.black : Colors.white)
        : (isHighlighted
            ? primaryColor
            : (isDark ? Colors.white70 : primaryColor));
    final bgColor = isSelected
        ? primaryColor
        : (hasActiveChild
            ? primaryColor.withAlpha(30)
            : (isDark
                ? cs.surfaceContainerHighest
                : primaryColor.withAlpha(15)));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppSpacing.avatarRadius,
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (hasActiveChild
                    ? primaryColor
                    : (isDark ? Colors.transparent : primaryColor.withAlpha(50))),
            width: hasActiveChild ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasActiveChild && !isSelected)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              label,
              style: AppTypography.label.copyWith(
                color: textColor,
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (hasChildren) ...[
              const SizedBox(width: 3),
              GestureDetector(
                onTap: onToggleExpand ?? onTap,
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: isSelected
                      ? (isDark ? Colors.black : Colors.white)
                      : (isDark ? Colors.white70 : primaryColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact chip representing a subcategory under an expanded parent category.
class SubCategoryChipItem extends StatelessWidget {
  const SubCategoryChipItem({
    super.key,
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
        : (isDark ? Colors.white : AppColors.grey);
    final bgColor = isSelected
        ? primaryColor
        : (isDark ? cs.surfaceContainerHigh : const Color(0xFFF1F5F9));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
