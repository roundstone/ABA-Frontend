import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../auth/application/auth_providers.dart';
import '../application/merchant_providers.dart';
import 'widgets/merchant_kpi_card.dart';
import 'widgets/merchant_low_stock_tile.dart';
import 'widgets/merchant_order_card.dart';
import 'widgets/merchant_product_form_sheet.dart';
import 'widgets/merchant_quick_actions.dart';
import 'widgets/merchant_sales_chart.dart';
import 'widgets/merchant_stock_adjust_sheet.dart';
import 'widgets/merchant_menu_sheet.dart';

class MerchantDashboardScreen extends ConsumerWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final dashState = ref.watch(merchantDashboardProvider);
    final ordersState = ref.watch(merchantOrdersProvider);
    final productsState = ref.watch(merchantProductsProvider);

    final m = dashState.metrics;
    final businessName = user?.businessName ?? 'Enyimba Leather Works';
    final ownerName = user?.name ?? 'Merchant Owner';

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    businessName,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Color(0xFF10B981), size: 16),
              ],
            ),
            Text(
              ownerName,
              style: AppTypography.caption.copyWith(
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/home'),
            icon: const Icon(Icons.storefront_outlined, size: 18),
            label: const Text('Storefront', style: TextStyle(fontSize: 12)),
          ),
          IconButton(
            tooltip: 'Menu & Settings',
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedMenuSquare,
              size: 22,
            ),
            onPressed: () => showMerchantMenuSheet(context),
          ),
        ],
      ),
      body: dashState.isLoading && m == null
          ? const LoadingState(message: 'Loading merchant insights...')
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(merchantDashboardProvider.notifier).refresh();
                await ref.read(merchantOrdersProvider.notifier).loadOrders();
                await ref
                    .read(merchantProductsProvider.notifier)
                    .loadProducts();
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  MerchantQuickActions(
                    onAddProduct: () {
                      MerchantProductFormSheet.show(
                        context,
                        onSave: (p) => ref
                            .read(merchantProductsProvider.notifier)
                            .addProduct(p),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1.35,
                    children: [
                      MerchantKpiCard(
                        title: "Today's Sales",
                        value: formatNaira(m?.todaySales ?? 0),
                        icon: HugeIcons.strokeRoundedMoneyBag02,
                        badgeText: '+14% today',
                        isPositiveTrend: true,
                      ),
                      MerchantKpiCard(
                        title: "Today's Orders",
                        value: '${m?.todayOrdersCount ?? 0} orders',
                        icon: HugeIcons.strokeRoundedShoppingBag02,
                        subtitle: '${m?.pendingOrdersCount ?? 0} pending',
                        onTap: () => context.push('/merchant/orders'),
                      ),
                      MerchantKpiCard(
                        title: 'Low Stock Alert',
                        value: '${m?.lowStockCount ?? 0} items',
                        icon: HugeIcons.strokeRoundedAlertCircle,
                        iconColor: const Color(0xFFEF4444),
                        subtitle: 'Tap to view',
                        onTap: () => context.push('/merchant/products'),
                      ),
                      MerchantKpiCard(
                        title: 'Total Revenue',
                        value: formatNaira(m?.totalRevenue ?? 0),
                        icon: HugeIcons.strokeRoundedChartLine,
                        iconColor: isDark
                            ? AppColors.secondary
                            : AppColors.primary,
                        badgeText: '+18.5% 30d',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (m != null)
                    MerchantSalesChart(
                      trendPoints: m.salesTrend,
                      growthPercentage: m.salesGrowthPercentage,
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/merchant/orders'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (ordersState.orders.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Center(child: Text('No orders found yet.')),
                    )
                  else
                    ...ordersState.orders
                        .take(3)
                        .map(
                          (order) => MerchantOrderCard(
                            order: order,
                            onTap: () =>
                                context.push('/merchant/orders/${order.id}'),
                            onStatusTransition: (next) {
                              ref
                                  .read(merchantOrdersProvider.notifier)
                                  .updateOrderStatus(order.id, next);
                            },
                          ),
                        ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inventory Watch',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/merchant/products'),
                        child: const Text('Manage Stock'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...productsState.products
                      .where((p) => p.isLowStock || p.isOutOfStock)
                      .take(2)
                      .map(
                        (p) => MerchantLowStockTile(
                          product: p,
                          onRestock: () {
                            MerchantStockAdjustSheet.show(
                              context,
                              product: p,
                              onConfirm: (delta, reason) => ref
                                  .read(merchantProductsProvider.notifier)
                                  .adjustStock(p.id, delta, reason),
                            );
                          },
                        ),
                      ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }
}
