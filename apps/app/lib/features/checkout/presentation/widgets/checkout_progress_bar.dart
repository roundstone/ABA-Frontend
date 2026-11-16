import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class CheckoutProgressBar extends StatelessWidget {
  const CheckoutProgressBar({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  final int currentStep;
  final ValueChanged<int> onStepTapped;

  static const _steps = [
    (num: 1, label: 'Info'),
    (num: 2, label: 'Address'),
    (num: 3, label: 'Delivery'),
    (num: 4, label: 'Payment'),
    (num: 5, label: 'Review'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = _steps.length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(total * 2 - 1, (index) {
              if (index.isOdd) {
                // Divider line between steps
                final stepBefore = (index ~/ 2) + 1;
                final isCompleted = currentStep > stepBefore;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? AppColors.primary
                        : (isDark ? Colors.white12 : AppColors.border),
                  ),
                );
              }

              // Step indicator
              final stepIndex = index ~/ 2;
              final stepNum = _steps[stepIndex].num;
              final isPassed = currentStep > stepNum;
              final isCurrent = currentStep == stepNum;

              Color bg;
              Color border;
              Color text;

              if (isPassed) {
                bg = AppColors.primary;
                border = AppColors.primary;
                text = Colors.white;
              } else if (isCurrent) {
                bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
                border = AppColors.primary;
                text = AppColors.primary;
              } else {
                bg = isDark ? const Color(0xFF2A2A2A) : AppColors.surface2;
                border = isDark ? Colors.white24 : AppColors.border;
                text = AppColors.grey;
              }

              return InkWell(
                onTap: isPassed ? () => onStepTapped(stepNum) : null,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                          border: Border.all(color: border, width: 2),
                        ),
                        child: Center(
                          child: isPassed
                              ? const HugeIcon(
                                  icon:
                                      HugeIcons.strokeRoundedCheckmarkCircle01,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : Text(
                                  '$stepNum',
                                  style: TextStyle(
                                    color: text,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _steps[stepIndex].label,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isCurrent
                              ? (isDark
                                    ? AppColors.secondary
                                    : AppColors.primary)
                              : AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
