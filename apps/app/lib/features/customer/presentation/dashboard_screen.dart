import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../account/application/orders_providers.dart';
import '../../account/domain/customer_order.dart';
import '../../rewards/application/rewards_providers.dart';
import '../../wallet/application/wallet_providers.dart';
import '../application/customer_providers.dart' hide customerOrdersProvider;
import '../domain/customer_entities.dart' as customer_domain;
import 'referrals_screen.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_overview_metrics.dart';
import 'widgets/dashboard_quick_actions.dart';
import 'widgets/dashboard_recent_orders.dart';
import 'widgets/dashboard_recent_transactions.dart';
import 'widgets/dashboard_wallet_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final walletInfoAsync = ref.watch(walletInfoProvider);
    final walletTransactionsAsync = ref.watch(walletTransactionsProvider);
    final ordersAsync = ref.watch(customerOrdersProvider);
    final referralAsync = ref.watch(referralDataProvider);
    final rewardSummaryAsync = ref.watch(rewardSummaryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: summaryAsync.when(
        loading: () => const LoadingState(message: 'Loading dashboard…'),
        error: (e, _) => ErrorState(
          message: 'Could not load dashboard.\n${e.toString()}',
          onRetry: () {
            ref.invalidate(dashboardSummaryProvider);
            ref.invalidate(walletInfoProvider);
            ref.invalidate(customerOrdersProvider);
          },
        ),
        data: (summary) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
            ref.invalidate(walletInfoProvider);
            ref.invalidate(walletTransactionsProvider);
            ref.invalidate(customerOrdersProvider);
            ref.invalidate(referralDataProvider);
            ref.invalidate(rewardSummaryProvider);
            await ref.read(dashboardSummaryProvider.future);
          },
          child: _DashboardBody(
            profile: summary.profile,
            walletBalance: walletInfoAsync.value?.balance ??
                summary.availableToWithdraw,
            orders: ordersAsync.value ?? [],
            isOrdersLoading: ordersAsync.isLoading,
            transactions: walletTransactionsAsync.value ?? [],
            isTransactionsLoading: walletTransactionsAsync.isLoading,
            referralEarned: (referralAsync.value?.metrics.totalEarned ??
                    (summary.totalEarned * 100).toInt()) /
                100,
            networkMembersCount:
                referralAsync.value?.metrics.totalNetwork ?? 142,
            rewardPoints: rewardSummaryAsync.value?.available ?? summary.totalPoints,
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.profile,
    required this.walletBalance,
    required this.orders,
    required this.isOrdersLoading,
    required this.transactions,
    required this.isTransactionsLoading,
    required this.referralEarned,
    required this.networkMembersCount,
    required this.rewardPoints,
  });

  final customer_domain.CustomerProfile profile;
  final double walletBalance;
  final List<CustomerOrder> orders;
  final bool isOrdersLoading;
  final List<dynamic> transactions;
  final bool isTransactionsLoading;
  final double referralEarned;
  final int networkMembersCount;
  final int rewardPoints;

  @override
  Widget build(BuildContext context) {
    final activeOrdersCount = orders
        .where(
          (o) =>
              o.status == OrderStatus.pending ||
              o.status == OrderStatus.processing,
        )
        .length;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        DashboardHeader(profile: profile),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          sliver: SliverToBoxAdapter(
            child: DashboardWalletCard(balance: walletBalance),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: DashboardOverviewMetrics(
              activeOrdersCount: activeOrdersCount,
              referralEarned: referralEarned,
              networkMembersCount: networkMembersCount,
              rewardPoints: rewardPoints,
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: DashboardQuickActions(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: DashboardRecentOrders(
              orders: orders,
              isLoading: isOrdersLoading,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xxl + 80, // Clearance for bottom floating navigation bar
          ),
          sliver: SliverToBoxAdapter(
            child: DashboardRecentTransactions(
              transactions: transactions.cast(),
              isLoading: isTransactionsLoading,
            ),
          ),
        ),
      ],
    );
  }
}
