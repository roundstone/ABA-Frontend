import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class OrderSuccessTimeline extends StatelessWidget {
  const OrderSuccessTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What happens next?',
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const _TimelineStep(
          isActive: true,
          isDone: true,
          title: 'Order placed successfully',
        ),
        const _TimelineStep(
          isActive: true,
          isDone: false,
          title: 'Merchant processing your items',
        ),
        const _TimelineStep(
          isActive: false,
          isDone: false,
          title: 'Order shipped for delivery',
          isLast: true,
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.isActive,
    required this.isDone,
    required this.title,
    this.isLast = false,
  });

  final bool isActive;
  final bool isDone;
  final String title;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.success
                    : (isActive ? AppColors.primary : AppColors.border),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: isDone ? AppColors.success : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              style: AppTypography.caption.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? null : AppColors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
