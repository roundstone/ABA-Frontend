import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class FilterSheetHeader extends StatelessWidget {
  const FilterSheetHeader({
    super.key,
    required this.isDark,
    required this.onReset,
  });

  final bool isDark;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(40)
                  : Colors.black.withAlpha(20),
              borderRadius: AppSpacing.avatarRadius,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text('Filter',
                  style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(
                onPressed: onReset,
                child: Text('Reset all',
                    style:
                        AppTypography.bodySmall.copyWith(color: AppColors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
