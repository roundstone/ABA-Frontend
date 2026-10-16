import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_widgets.dart';
import '../domain/merchant_order_entities.dart';
import '../application/merchant_providers.dart';
import 'widgets/merchant_order_card.dart';

class MerchantOrdersScreen extends ConsumerStatefulWidget {
  const MerchantOrdersScreen({super.key});

  @override
  ConsumerState<MerchantOrdersScreen> createState() =>
      _MerchantOrdersScreenState();
}

class _MerchantOrdersScreenState extends ConsumerState<MerchantOrdersScreen> {
  final _searchCtrl = TextEditingController();

  final List<MerchantOrderStatus?> _statuses = [
    null, // All
    MerchantOrderStatus.pending,
    MerchantOrderStatus.processing,
    MerchantOrderStatus.ready,
    MerchantOrderStatus.completed,
    MerchantOrderStatus.cancelled,
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(merchantOrdersProvider);
    final notifier = ref.read(merchantOrdersProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
         icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/merchant'),
        ),
        title: const Text('Order Management'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadOrders(),
          ),
        ],
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.popOrGo('/merchant');
        },
        child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: Column(
              children: [
                AppTextField(
                  label: '',
                  controller: _searchCtrl,
                  hintText: 'Search order #, customer or phone...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  onChanged: (val) => notifier.setSearchQuery(val),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statuses.map((status) {
                      final isSelected = state.selectedStatus == status;
                      final label = status == null ? 'All' : status.label;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (_) => notifier.setStatusFilter(status),
                          selectedColor: isDark
                              ? AppColors.secondary.withAlpha(60)
                              : AppColors.primary.withAlpha(40),
                          labelStyle: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading && state.orders.isEmpty
                ? const LoadingState(message: 'Loading orders...')
                : RefreshIndicator(
                    onRefresh: () => notifier.loadOrders(),
                    child: state.orders.isEmpty
                        ? ListView(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(AppSpacing.xxl),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
                                      SizedBox(height: AppSpacing.md),
                                      Text(
                                        'No orders found matching criteria.',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            itemCount: state.orders.length,
                            itemBuilder: (context, i) {
                              final order = state.orders[i];
                              return MerchantOrderCard(
                                order: order,
                                onTap: () => context.push('/merchant/orders/${order.id}'),
                                onStatusTransition: (next) {
                                  notifier.updateOrderStatus(order.id, next);
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      ),
    );
  }
}
