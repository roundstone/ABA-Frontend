import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../checkout/application/payment_gateway_registry.dart';
import '../../../checkout/domain/payment_gateway.dart';
import '../../../checkout/presentation/widgets/paystack_payment_sheet.dart';
import '../../application/invoice_service.dart';
import '../../application/orders_providers.dart';
import '../../domain/customer_order.dart';
import 'order_cancel_dialog.dart';
import 'order_status_badge.dart';

class OrderDetailHeader extends ConsumerWidget {
  const OrderDetailHeader({super.key, required this.order});

  final CustomerOrder order;

  Future<void> _handlePayNow(BuildContext context, WidgetRef ref) async {
    final gateway = ref.read(paymentGatewayServiceProvider(PaymentGatewayType.paystack));
    final orderIdInt = int.tryParse(order.id);

    if (orderIdInt == null) {
      AppSnackbar.show(
        context,
        message: 'Cannot process payment for order ID: ${order.id}',
        type: AppSnackbarType.error,
      );
      return;
    }

    final amountNaira = order.total / 100.0;
    final result = await PaystackPaymentSheet.show(
      context,
      orderId: orderIdInt,
      amount: amountNaira,
      email: 'customer@aba.com',
      gatewayService: gateway,
    );

    if (result != null && result.isNotEmpty) {
      ref.invalidate(customerOrderByIdProvider(order.id));
      ref.read(customerOrdersNotifierProvider.notifier).refresh();
      if (context.mounted) {
        AppSnackbar.show(
          context,
          message: 'Payment completed successfully!',
          type: AppSnackbarType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.orderNumber.isNotEmpty ? order.orderNumber : 'Order #${order.id}',
                  style: AppTypography.h4,
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
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedTime01,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Placed on ${DateFormat('MMM d, y, h:mm a').format(order.date)}',
                style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
          if (order.isCancelled) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: isDark ? 0.2 : 0.08),
                borderRadius: AppSpacing.borderRadiusMD,
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HugeIcon(icon: HugeIcons.strokeRoundedAlert02, color: AppColors.error, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Cancelled',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                            )),
                        if (order.cancellationReason != null && order.cancellationReason!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text('Reason: ${order.cancellationReason}',
                              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (order.isUnpaid) ...[
            AppButton.primary(
              label: 'Complete Payment Now',
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedCreditCard,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () => _handlePayNow(context, ref),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  label: 'Invoice',
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedInvoice01,
                    size: 18,
                    color: cs.onSurface,
                  ),
                  onPressed: () => InvoiceService.downloadAndShareInvoice(context, order, ref: ref),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.destructive(
                  label: 'Cancel Order',
                  onPressed: order.canBeCancelled
                      ? () => OrderCancelDialog.show(context, order)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
