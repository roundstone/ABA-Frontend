import 'dart:async';
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

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen>
    with WidgetsBindingObserver {
  Timer? _pollTimer;
  bool _isBackgrounded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      if (!_isBackgrounded && mounted) {
        _silentPoll();
      }
    });
  }

  void _silentPoll() {
    final order =
        ref.read(customerOrderByIdProvider(widget.orderId)).valueOrNull;
    if (order != null &&
        (order.status == OrderStatus.delivered ||
            order.status == OrderStatus.cancelled)) {
      _pollTimer?.cancel();
      return;
    }
    ref.invalidate(customerOrderByIdProvider(widget.orderId));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _isBackgrounded = false;
      _silentPoll();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _isBackgrounded = true;
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(customerOrderByIdProvider(widget.orderId));
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
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              size: 20,
              color: AppColors.grey,
            ),
            tooltip: 'Refresh order',
            onPressed: () =>
                ref.invalidate(customerOrderByIdProvider(widget.orderId)),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
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
            onRetry: () =>
                ref.invalidate(customerOrderByIdProvider(widget.orderId)),
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
            OrderDetailAddressSection(
              address: order.shippingAddress,
              deliveryMethod: order.deliveryMethod,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
