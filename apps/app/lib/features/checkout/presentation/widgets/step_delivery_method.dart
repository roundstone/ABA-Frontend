import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/checkout_entities.dart';

class StepDeliveryMethod extends StatelessWidget {
  const StepDeliveryMethod({
    super.key,
    required this.methods,
    required this.selectedMethod,
    required this.onSelectMethod,
    required this.onBack,
    required this.onContinue,
  });

  final List<DeliveryMethod> methods;
  final DeliveryMethod? selectedMethod;
  final ValueChanged<DeliveryMethod> onSelectMethod;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedDeliveryTruck01,
                color: isDark ? AppColors.secondary : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Delivery Method',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...methods.map((method) {
            final isSelected = selectedMethod?.id == method.id;
            final isExpress = method.id.contains('express');

            return GestureDetector(
              onTap: () => onSelectMethod(method),
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
                      icon: isExpress
                          ? HugeIcons.strokeRoundedFlash
                          : HugeIcons.strokeRoundedDeliveryBox01,
                      color: isSelected
                          ? (isDark ? AppColors.secondary : AppColors.primary)
                          : AppColors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.name,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            method.duration,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatNaira(method.cost),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.secondary : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  label: 'Back',
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Continue',
                  onPressed: onContinue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
