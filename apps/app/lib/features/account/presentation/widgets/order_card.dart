import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/customer_order.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedDate = DateFormat.yMMMd().format(order.date);
    final formatter = NumberFormat('#,##0.00');

    final itemCount = order.items.length;
    final itemText = itemCount == 1 ? '1 item' : '$itemCount items';

    return GestureDetector(
      onTap: () => context.push('/account/orders/${order.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppSpacing.borderRadiusLG,
          border: Border.all(
            color: isDark ? Colors.white12 : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: AppSpacing.borderRadiusSM,
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedPackage,
                    color: AppColors.grey,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order.orderNumber.isNotEmpty
                                  ? order.orderNumber
                                  : 'Order #${order.id}',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          OrderStatusBadge(
                            status: order.status,
                            customLabel: order.isUnpaid ? 'UNPAID' : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$formattedDate • $itemText',
                        style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Total',
                      style: AppTypography.caption.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '₦${formatter.format(order.total / 100.0)}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.grey,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

