import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/customer_order.dart';
import '../../domain/order_date_cluster.dart';

class OrderClusterItemTile extends StatelessWidget {
  const OrderClusterItemTile({
    super.key,
    required this.order,
    required this.isDark,
  });

  final CustomerOrder order;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final formatter = NumberFormat('#,##0.00');

    final (statusLabel, statusColor, circleBg, circleIconColor) =
        _resolveStatusAttributes(isDark);

    final title = order.items.isNotEmpty
        ? order.items.first.productName
        : (order.orderNumber.isNotEmpty
            ? order.orderNumber
            : 'Order #${order.id}');

    final dateFormatted = formatOrderDateOrdinal(order.date);
    final countLabel =
        order.items.length > 1 ? ' • +${order.items.length - 1} more' : '';
    final subtitle = '$dateFormatted$countLabel';

    return InkWell(
      onTap: () => context.push('/account/orders/${order.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: circleBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedPackage,
                  color: circleIconColor,
                  size: 19,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₦${formatter.format(order.total / 100.0)}',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (String, Color, Color, Color) _resolveStatusAttributes(bool isDark) {
    if (order.isCancelled) {
      return (
        'Cancelled',
        AppColors.grey,
        AppColors.grey.withValues(alpha: isDark ? 0.2 : 0.1),
        AppColors.grey,
      );
    }
    if (order.isPaid || order.status == OrderStatus.delivered) {
      final label =
          order.status == OrderStatus.delivered ? 'Delivered' : 'Paid';
      return (
        label,
        AppColors.success,
        AppColors.success.withValues(alpha: isDark ? 0.22 : 0.12),
        AppColors.success,
      );
    }
    if (order.isUnpaid || order.status == OrderStatus.unpaid) {
      return (
        'Unpaid',
        const Color(0xFFC28B38),
        const Color(0xFFC28B38).withValues(alpha: isDark ? 0.22 : 0.12),
        const Color(0xFFC28B38),
      );
    }
    if (order.status == OrderStatus.processing ||
        order.status == OrderStatus.shipped) {
      return (
        order.status.label,
        AppColors.primary,
        AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.12),
        AppColors.primary,
      );
    }
    return (
      'Pending',
      const Color(0xFFC28B38),
      const Color(0xFFC28B38).withValues(alpha: isDark ? 0.22 : 0.12),
      const Color(0xFFC28B38),
    );
  }
}

