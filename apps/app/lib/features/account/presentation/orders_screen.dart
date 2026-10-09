import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/orders_providers.dart';
import '../domain/customer_order.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedFilter, color: AppColors.grey, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: ordersAsync.when(
        loading: () => const LoadingState(message: 'Loading orders…'),
        error: (e, _) => ErrorState(
          message: 'Could not load orders.\n${e.toString()}',
          onRetry: () => ref.invalidate(customerOrdersProvider),
        ),
        data: (orders) => _OrdersBody(orders: orders),
      ),
    );
  }
}

class _OrdersBody extends StatelessWidget {
  const _OrdersBody({required this.orders});

  final List<CustomerOrder> orders;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (orders.isEmpty) {
      return const Center(
        child: Text('You have no orders yet.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final formattedDate = DateFormat.yMMMd().format(order.date);
        final formatter = NumberFormat('#,##0.00');

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

        return GestureDetector(
          onTap: () {
            context.push('/account/orders/${order.id}');
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: AppSpacing.borderRadiusSM,
                      ),
                      child: const HugeIcon(icon: HugeIcons.strokeRoundedPackage, color: AppColors.grey, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.id,
                                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
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
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '$formattedDate • ${order.items.length} ${order.items.length == 1 ? "item" : "items"} • Sold by Merchant',
                            style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Total', style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
                        Text(
                          '₦${formatter.format(order.total / 100)}',
                          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.grey, size: 24),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
