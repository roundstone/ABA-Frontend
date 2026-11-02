import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_widgets.dart';
import '../application/orders_providers.dart';
import '../domain/customer_order.dart';
import 'widgets/order_card.dart';
import 'widgets/orders_active_filters_bar.dart';
import 'widgets/orders_filter_sheet.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(customerOrdersNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasFilters = ordersState.hasActiveFilters;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/home'),
        ),
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              size: 20,
              color: AppColors.grey,
            ),
            tooltip: 'Refresh orders',
            onPressed: () =>
                ref.read(customerOrdersNotifierProvider.notifier).refresh(),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedFilter,
                  color: hasFilters ? AppColors.primary : AppColors.grey,
                  size: 24,
                ),
                tooltip: 'Filter',
                onPressed: () => OrdersFilterSheet.show(context),
              ),
              if (hasFilters)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.popOrGo('/home');
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: AppTextField(
                hintText: 'Search by Order ID or item...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                onChanged: (val) {
                  ref
                      .read(customerOrdersNotifierProvider.notifier)
                      .setSearchQuery(val);
                },
              ),
            ),
            const OrdersActiveFiltersBar(),
            Expanded(
              child: _buildListContent(context, ref, ordersState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent(
    BuildContext context,
    WidgetRef ref,
    CustomerOrdersState state,
  ) {
    if (state.isLoading && state.orders.isEmpty) {
      return const LoadingState(message: 'Loading orders…');
    }

    if (state.errorMessage != null && state.orders.isEmpty) {
      return ErrorState(
        message: state.errorMessage!,
        onRetry: () =>
            ref.read(customerOrdersNotifierProvider.notifier).refresh(),
      );
    }

    return PaginatedListView<CustomerOrder>(
      items: state.orders,
      padding: const EdgeInsets.all(AppSpacing.md),
      hasMore: state.hasMore,
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      onRefresh: () =>
          ref.read(customerOrdersNotifierProvider.notifier).refresh(),
      onLoadMore: () =>
          ref.read(customerOrdersNotifierProvider.notifier).loadMore(),
      itemBuilder: (context, order, index) => OrderCard(order: order),
      emptyWidget: const _EmptyOrdersView(),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedPackage,
                  color: AppColors.grey,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No Orders Found', style: AppTypography.h4),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'You have not placed any orders matching this criteria yet.',
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
