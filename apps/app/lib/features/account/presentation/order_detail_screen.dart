import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/orders_providers.dart';
import '../domain/customer_order.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(customerOrderByIdProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: orderAsync.when(
        loading: () => const LoadingState(message: 'Loading order…'),
        error: (e, _) => ErrorState(
          message: 'Could not load order.\n${e.toString()}',
          onRetry: () => ref.invalidate(customerOrderByIdProvider(orderId)),
        ),
        data: (order) => _OrderDetailBody(order: order),
      ),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.00');

    final subtotal = order.items.fold<int>(0, (acc, item) => acc + (item.price * item.quantity));
    final deliveryFee = order.total - subtotal;

    Color statusBgColor;
    Color statusTextColor;
    Color statusBorderColor;

    switch (order.status) {
      case OrderStatus.processing:
        statusBgColor = isDark ? const Color(0xFF4A2B0F) : const Color(0xFFFEF3C7);
        statusTextColor = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
        statusBorderColor = isDark ? const Color(0xFF92400E) : const Color(0xFFFDE68A);
        break;
      case OrderStatus.shipped:
        statusBgColor = isDark ? const Color(0xFF0F2B2A) : const Color(0xFFE6E1D8);
        statusTextColor = isDark ? const Color(0xFF5EEAD4) : const Color(0xFF172A1D);
        statusBorderColor = isDark ? const Color(0xFF115E59) : const Color(0xFFD4CEC4);
        break;
      case OrderStatus.delivered:
        statusBgColor = isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
        statusTextColor = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D);
        statusBorderColor = isDark ? const Color(0xFF047857) : const Color(0xFFBBF7D0);
        break;
      case OrderStatus.cancelled:
        statusBgColor = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2);
        statusTextColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB42318);
        statusBorderColor = isDark ? const Color(0xFFB91C1C) : const Color(0xFFFECACA);
        break;
      default:
        statusBgColor = cs.surfaceContainerHighest;
        statusTextColor = cs.onSurfaceVariant;
        statusBorderColor = AppColors.border;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Info
          Container(
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
                    Text(order.id, style: AppTypography.h3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: statusBorderColor),
                      ),
                      child: Text(
                        order.status.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusTextColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedTime01, size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      'Placed on ${DateFormat('MMM d, y, h:mm a').format(order.date)}',
                      style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const HugeIcon(icon: HugeIcons.strokeRoundedInvoice01, size: 18, color: Colors.white),
                        label: const Text('Invoice'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: isDark ? Colors.white24 : AppColors.border),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (order.status == OrderStatus.cancelled || order.status == OrderStatus.delivered)
                            ? null
                            : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.error.withOpacity(0.5),
                        ),
                        child: const Text('Cancel Order'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Timeline
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: AppSpacing.borderRadiusLG,
              border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Status', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.md),
                const _TimelineStep(
                  icon: HugeIcons.strokeRoundedPackage,
                  title: 'Order Placed',
                  description: 'We have received your order.',
                  isActive: true,
                  isCompleted: true,
                  isLast: false,
                ),
                _TimelineStep(
                  icon: HugeIcons.strokeRoundedTime01,
                  title: 'Processing',
                  description: 'The merchant is preparing your items.',
                  isActive: order.status != OrderStatus.pending && order.status != OrderStatus.cancelled,
                  isCompleted: [OrderStatus.processing, OrderStatus.shipped, OrderStatus.delivered].contains(order.status),
                  isLast: false,
                ),
                _TimelineStep(
                  icon: HugeIcons.strokeRoundedDeliveryBox01,
                  title: 'Shipped',
                  description: 'Your order has been handed over to the delivery partner.',
                  isActive: [OrderStatus.shipped, OrderStatus.delivered].contains(order.status),
                  isCompleted: [OrderStatus.shipped, OrderStatus.delivered].contains(order.status),
                  isLast: false,
                ),
                _TimelineStep(
                  icon: HugeIcons.strokeRoundedLocation01,
                  title: 'Delivered',
                  description: 'Your order has arrived.',
                  isActive: order.status == OrderStatus.delivered,
                  isCompleted: order.status == OrderStatus.delivered,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Items List
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: AppSpacing.borderRadiusLG,
              border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text('Items in Order', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Image',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text('Qty: ${item.quantity}', style: AppTypography.caption),
                              ],
                            ),
                          ),
                          Text(
                            '₦${formatter.format(item.price / 100)}',
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Order Summary
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: AppSpacing.borderRadiusLG,
              border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Summary', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
                    Text('₦${formatter.format(subtotal / 100)}', style: AppTypography.bodyMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fee', style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
                    Text('₦${formatter.format(deliveryFee / 100)}', style: AppTypography.bodyMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      '₦${formatter.format(order.total / 100)}',
                      style: AppTypography.h3.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Payment Method
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: AppSpacing.borderRadiusLG,
              border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Method', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const HugeIcon(icon: HugeIcons.strokeRoundedCreditCard, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.paymentMethod,
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₦${formatter.format(order.total / 100)} was deducted',
                            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Delivery Address
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: AppSpacing.borderRadiusLG,
              border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Address', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: HugeIcon(icon: HugeIcons.strokeRoundedLocation01, color: cs.onSurfaceVariant, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.shippingAddress.fullName,
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.shippingAddress.street,
                            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                          ),
                          Text(
                            '${order.shippingAddress.city}, ${order.shippingAddress.zipCode}',
                            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.shippingAddress.phone,
                            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
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
    required this.isLast,
  });

  final dynamic icon;
  final String title;
  final String description;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color iconBgColor = isCompleted
        ? (title == 'Delivered' || title == 'Order Placed' ? AppColors.success : AppColors.primary)
        : cs.surfaceContainerHighest;
    final Color iconColor = isCompleted ? Colors.white : cs.onSurfaceVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.surface, width: 2),
                  ),
                  child: HugeIcon(icon: icon, color: iconColor, size: 16),
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
                    Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
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
