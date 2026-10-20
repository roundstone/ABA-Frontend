import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Reusable document upload box with status indicator.
class MerchantUploadBox extends StatelessWidget {
  const MerchantUploadBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isUploaded,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isUploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF282828) : AppColors.surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.border),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: isUploaded
                  ? HugeIcons.strokeRoundedCheckmarkCircle02
                  : HugeIcons.strokeRoundedUpload01,
              color: isUploaded ? AppColors.success : AppColors.grey,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: isUploaded ? AppColors.success : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Selector chip for CAC vs Provisional options.
class MerchantSelectionChip extends StatelessWidget {
  const MerchantSelectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final dynamic icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isSelected
        ? AppColors.primary
        : (isDark ? Colors.white12 : AppColors.border);
    final bg = isSelected
        ? AppColors.primary.withAlpha(isDark ? 40 : 15)
        : (isDark ? const Color(0xFF242424) : Colors.white);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white70 : AppColors.onBackground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
