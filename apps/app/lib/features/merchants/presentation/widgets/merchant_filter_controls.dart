import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

const List<String> kAvailableStates = [
  'Abia',
  'Lagos',
  'Rivers',
  'Anambra',
  'Kano',
  'Enugu',
  'Oyo',
  'FCT Abuja',
];

class MerchantStateChip extends StatelessWidget {
  const MerchantStateChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? const Color(0xFF282828) : AppColors.surface2,
      labelStyle: AppTypography.caption.copyWith(
        color: isSelected
            ? Colors.white
            : (isDark ? Colors.white : AppColors.onBackground),
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      showCheckmark: false,
    );
  }
}

class MerchantRatingOption extends StatelessWidget {
  const MerchantRatingOption({
    super.key,
    required this.stars,
    required this.isSelected,
    required this.onTap,
  });

  final String stars;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              ? AppColors.primary
              : (isDark ? const Color(0xFF282828) : AppColors.surface2),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMD,
          ),
        ),
        child: Text(
          stars,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : AppColors.onBackground),
          ),
        ),
      ),
    );
  }
}
