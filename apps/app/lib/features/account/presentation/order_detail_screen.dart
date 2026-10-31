import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/orders_providers.dart';
import '../domain/customer_order.dart';
import 'widgets/order_detail_address_section.dart';
import 'widgets/order_detail_header.dart';
import 'widgets/order_detail_items_section.dart';
import 'widgets/order_detail_sections.dart';
import 'widgets/order_detail_timeline.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(customerOrderByIdProvider(orderId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/account/orders'),
        ),
        title: const Text('Order Details'),
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.popOrGo('/account/orders');
        },
        child: orderAsync.when(
          loading: () => const LoadingState(message: 'Loading order…'),
          error: (e, _) => ErrorState(
            message: 'Could not load order details.\n${e.toString()}',
            onRetry: () => ref.invalidate(customerOrderByIdProvider(orderId)),
          ),
          data: (order) => _OrderDetailBody(order: order),
        ),
      ),
    );
  }
}

class _OrderDetailBody extends ConsumerWidget {
  const _OrderDetailBody({required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(customerOrderByIdProvider(order.id));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderDetailHeader(order: order),
            const SizedBox(height: AppSpacing.md),
            OrderDetailTimeline(order: order),
            const SizedBox(height: AppSpacing.md),
            OrderDetailItemsSection(items: order.items),
            const SizedBox(height: AppSpacing.md),
            OrderDetailSummarySection(order: order),
            const SizedBox(height: AppSpacing.md),
            OrderDetailPaymentSection(order: order),
            const SizedBox(height: AppSpacing.md),
            OrderDetailAddressSection(address: order.shippingAddress),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
