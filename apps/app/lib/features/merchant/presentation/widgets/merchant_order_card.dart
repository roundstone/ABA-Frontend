import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/merchant_order_entities.dart';
import 'merchant_status_badge.dart';

class MerchantOrderCard extends StatelessWidget {
  const MerchantOrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onStatusTransition,
  });

  final MerchantOrder order;
  final VoidCallback onTap;
  final void Function(MerchantOrderStatus nextStatus)? onStatusTransition;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0);

    final nextAction = _getNextTransition(order.status);

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusLG,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: AppSpacing.borderRadiusLG,
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 30 : 6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      order.id,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9),
                        borderRadius: AppSpacing.borderRadiusSM,
                      ),
                      child: Text(
                        order.channel.label,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: isDark ? Colors.white70 : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                MerchantOrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              order.isWalkIn
                  ? 'Walk-in Customer'
                  : '${order.customerName} (${order.customerPhone})',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${order.itemsCount} items • ${order.items.first.productName}${order.items.length > 1 ? ' +${order.items.length - 1} more' : ''}',
              style: AppTypography.caption.copyWith(
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                fontSize: 11.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Divider(
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F5F9),
              height: 1,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatNaira(order.total),
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.secondary : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    MerchantPaymentBadge(status: order.paymentStatus),
                  ],
                ),
                if (nextAction != null && onStatusTransition != null)
                  FilledButton(
                    onPressed: () => onStatusTransition!(nextAction.targetStatus),
                    style: FilledButton.styleFrom(
                      backgroundColor: nextAction.buttonColor,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: Text(
                      nextAction.label,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _OrderTransitionAction? _getNextTransition(MerchantOrderStatus status) {
    switch (status) {
      case MerchantOrderStatus.pending:
        return const _OrderTransitionAction(
          label: 'Process Order',
          targetStatus: MerchantOrderStatus.processing,
          buttonColor: Color(0xFF2563EB),
        );
      case MerchantOrderStatus.processing:
        return const _OrderTransitionAction(
          label: 'Mark Ready',
          targetStatus: MerchantOrderStatus.ready,
          buttonColor: Color(0xFF9333EA),
        );
      case MerchantOrderStatus.ready:
        return const _OrderTransitionAction(
          label: 'Complete Order',
          targetStatus: MerchantOrderStatus.completed,
          buttonColor: Color(0xFF059669),
        );
      case MerchantOrderStatus.completed:
      case MerchantOrderStatus.cancelled:
        return null;
    }
  }
}

class _OrderTransitionAction {
  const _OrderTransitionAction({
    required this.label,
    required this.targetStatus,
    required this.buttonColor,
  });
  final String label;
  final MerchantOrderStatus targetStatus;
  final Color buttonColor;
}
