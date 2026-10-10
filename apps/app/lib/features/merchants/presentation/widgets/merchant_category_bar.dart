import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

const List<String> kMerchantCategories = [
  'All',
  'Fashion & Leather',
  'Shoes & Footwear',
  'Textiles & Fabrics',
  'Electronics',
  'Auto Parts',
  'Home & Hardware',
  'Food & Provisions',
];

/// Horizontal scrollable category pill selector.
class MerchantCategoryBar extends StatelessWidget {
  const MerchantCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: kMerchantCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final category = kMerchantCategories[index];
          final isAll = category == 'All';
          final isSelected = isAll
              ? selectedCategory.isEmpty
              : selectedCategory.toLowerCase() == category.toLowerCase();

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) {
              onSelectCategory(isAll ? '' : category);
            },
            labelStyle: AppTypography.caption.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.onBackground,
            ),
            selectedColor: AppColors.primary,
            backgroundColor: isDark
                ? const Color(0xFF262626)
                : AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.avatarRadius,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : isDark
                        ? Colors.white.withAlpha(20)
                        : AppColors.border,
              ),
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs + 2,
              vertical: 2,
            ),
          );
        },
      ),
    );
  }
}
