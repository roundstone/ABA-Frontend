import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class PaymentOptionTile extends StatelessWidget {
  const PaymentOptionTile({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.enabled = true,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final List<List<dynamic>> icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? AppColors.secondary.withAlpha(25)
                    : AppColors.primary.withAlpha(15))
                : (isDark ? const Color(0xFF252525) : Colors.white),
            borderRadius: AppSpacing.borderRadiusMD,
            border: Border.all(
              color: isSelected
                  ? (isDark ? AppColors.secondary : AppColors.primary)
                  : (isDark ? Colors.white12 : AppColors.border),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              HugeIcon(
                icon: icon,
                color: isSelected
                    ? (isDark ? AppColors.secondary : AppColors.primary)
                    : AppColors.grey,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                trailing!,
                const SizedBox(width: AppSpacing.xs),
              ],
              if (isSelected)
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                  color: isDark ? AppColors.secondary : AppColors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

