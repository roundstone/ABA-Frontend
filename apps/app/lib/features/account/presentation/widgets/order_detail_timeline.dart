import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/customer_order.dart';

class OrderDetailTimeline extends StatelessWidget {
  const OrderDetailTimeline({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (order.status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppSpacing.borderRadiusLG,
          border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Timeline',
                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            const _TimelineStep(
              icon: HugeIcons.strokeRoundedPackage,
              title: 'Order Placed',
              description: 'Order was submitted.',
              isActive: true,
              isCompleted: true,
              isLast: false,
            ),
            _TimelineStep(
              icon: HugeIcons.strokeRoundedCancelCircle,
              title: 'Order Cancelled',
              description: order.cancellationReason ?? 'This order was cancelled.',
              isActive: true,
              isCompleted: true,
              isError: true,
              isLast: true,
            ),
          ],
        ),
      );
    }

    final isProcessing = [
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ].contains(order.status);
    final isShipped = [
      OrderStatus.shipped,
      OrderStatus.delivered,
    ].contains(order.status);
    final isDelivered = order.status == OrderStatus.delivered;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Status',
              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          _TimelineStep(
            icon: HugeIcons.strokeRoundedPackage,
            title: 'Order Placed',
            description: order.isUnpaid
                ? 'Order initiated. Awaiting payment confirmation.'
                : 'Payment received. Order placed successfully.',
            isActive: true,
            isCompleted: !order.isUnpaid,
            isLast: false,
          ),
          _TimelineStep(
            icon: HugeIcons.strokeRoundedTime01,
            title: 'Processing',
            description: 'The merchant is preparing your items.',
            isActive: isProcessing,
            isCompleted: isProcessing,
            isLast: false,
          ),
          _TimelineStep(
            icon: HugeIcons.strokeRoundedDeliveryBox01,
            title: 'Shipped',
            description: 'Your order has been handed over to the delivery partner.',
            isActive: isShipped,
            isCompleted: isShipped,
            isLast: false,
          ),
          _TimelineStep(
            icon: HugeIcons.strokeRoundedLocation01,
            title: 'Delivered',
            description: 'Your order has arrived at the destination.',
            isActive: isDelivered,
            isCompleted: isDelivered,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.isActive,
    required this.isCompleted,
    this.isError = false,
    required this.isLast,
  });

  final dynamic icon;
  final String title;
  final String description;
  final bool isActive;
  final bool isCompleted;
  final bool isError;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color iconBgColor;
    if (isError) {
      iconBgColor = AppColors.error;
    } else if (isCompleted) {
      iconBgColor = (title == 'Delivered' || title == 'Order Placed')
          ? AppColors.success
          : AppColors.primary;
    } else {
      iconBgColor = cs.surfaceContainerHighest;
    }

    final Color iconColor = (isCompleted || isError) ? Colors.white : cs.onSurfaceVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.surface, width: 2),
                  ),
                  child: HugeIcon(icon: icon, color: iconColor, size: 15),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDark ? Colors.white12 : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Opacity(
                opacity: isActive ? 1.0 : 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isError ? AppColors.error : null,
                        )),
                    const SizedBox(height: 4),
                    Text(description,
                        style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
