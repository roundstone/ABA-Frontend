import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_widgets.dart';
import '../domain/merchant_order_entities.dart';
import '../application/merchant_providers.dart';
import 'widgets/merchant_status_badge.dart';

class MerchantOrderDetailScreen extends ConsumerWidget {
  const MerchantOrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderAsync = ref.watch(merchantOrderDetailProvider(orderId));
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/merchant/orders'),
        ),
        title: Text(orderId),
      ),
      body: orderAsync.when(
        loading: () => const LoadingState(message: 'Loading order details...'),
        error: (e, _) => ErrorState(message: e.toString()),
        data: (order) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: AppSpacing.borderRadiusLG,
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order.channel.label} • ${order.createdAt.toString().substring(0, 16)}',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                    MerchantOrderStatusBadge(status: order.status),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Customer Details
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: AppSpacing.borderRadiusLG,
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer & Delivery',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      order.customerName,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(order.customerPhone, style: AppTypography.caption),
                    if (order.shippingAddress != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        order.shippingAddress!,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                    if (order.notes != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Note: ${order.notes}',
                        style: AppTypography.caption.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Line Items
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: AppSpacing.borderRadiusLG,
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Items Ordered (${order.itemsCount})',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity}x @ ${formatNaira(item.price)}',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatNaira(item.total),
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 20),
                    _financialRow('Subtotal', formatNaira(order.subtotal)),
                    if (order.deliveryFee > 0)
                      _financialRow(
                        'Delivery Fee',
                        formatNaira(order.deliveryFee),
                      ),
                    if (order.discount > 0)
                      _financialRow(
                        'Discount',
                        '−${formatNaira(order.discount)}',
                      ),
                    const SizedBox(height: 6),
                    _financialRow(
                      'Total Amount',
                      formatNaira(order.total),
                      isBold: true,
                      color: isDark ? AppColors.secondary : AppColors.primary,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment: ${order.paymentMethod}',
                          style: AppTypography.caption,
                        ),
                        MerchantPaymentBadge(status: order.paymentStatus),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Action Buttons
              _buildActionButtons(context, ref, order),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }

  Widget _financialRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    MerchantOrder order,
  ) {
    if (order.status == MerchantOrderStatus.completed ||
        order.status == MerchantOrderStatus.cancelled) {
      return const SizedBox.shrink();
    }

    final notifier = ref.read(merchantOrdersProvider.notifier);

    return Column(
      children: [
        if (order.status == MerchantOrderStatus.pending)
          AppButton(
            label: 'Accept & Start Processing',
            onPressed: () async {
              await notifier.updateOrderStatus(
                order.id,
                MerchantOrderStatus.processing,
              );
              ref.invalidate(merchantOrderDetailProvider(orderId));
            },
          ),
        if (order.status == MerchantOrderStatus.processing)
          AppButton(
            label: 'Mark as Ready / Packed',
            onPressed: () async {
              await notifier.updateOrderStatus(
                order.id,
                MerchantOrderStatus.ready,
              );
              ref.invalidate(merchantOrderDetailProvider(orderId));
            },
          ),
        if (order.status == MerchantOrderStatus.ready)
          AppButton(
            label: 'Complete Order (Delivered / Picked Up)',
            onPressed: () async {
              await notifier.updateOrderStatus(
                order.id,
                MerchantOrderStatus.completed,
              );
              ref.invalidate(merchantOrderDetailProvider(orderId));
            },
          ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: () => _showCancelDialog(context, notifier, order.id, ref),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFEF4444),
            side: const BorderSide(color: Color(0xFFEF4444)),
            minimumSize: const Size(double.infinity, 44),
          ),
          child: const Text('Cancel Order'),
        ),
      ],
    );
  }

  void _showCancelDialog(
    BuildContext context,
    dynamic notifier,
    String id,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text(
          'Are you sure you want to cancel this order? This will release reserved stock.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Keep'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await notifier.updateOrderStatus(
                id,
                MerchantOrderStatus.cancelled,
              );
              ref.invalidate(merchantOrderDetailProvider(id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
