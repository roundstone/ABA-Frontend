import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../application/customer_providers.dart';
import '../domain/customer_entities.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: summaryAsync.when(
        loading: () => const LoadingState(message: 'Loading dashboard…'),
        error: (e, _) => ErrorState(
          message: 'Could not load dashboard.\n${e.toString()}',
          onRetry: () => ref.invalidate(dashboardSummaryProvider),
        ),
        data: (summary) => _DashboardBody(summary: summary),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _SliverHeader(profile: summary.profile),
        SliverPadding(
          padding: AppSpacing.paddingHorizontalMD,
          sliver: SliverToBoxAdapter(child: _StatsRow(summary: summary)),
        ),
        SliverPadding(
          padding: AppSpacing.paddingHorizontalMD,
          sliver: SliverToBoxAdapter(child: _EarningsCard(summary: summary)),
        ),
        SliverPadding(
          padding: AppSpacing.paddingHorizontalMD,
          sliver: SliverToBoxAdapter(
            child: _SectionHeader(title: 'Recent Orders', onSeeAll: () {}),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl +
                AppSpacing.xxxl, // extra clearance for floating nav bar
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _OrderCard(order: summary.recentOrders[i]),
              childCount: summary.recentOrders.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────

class _SliverHeader extends StatelessWidget {
  const _SliverHeader({required this.profile});
  final CustomerProfile profile;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      stretch: true,
      backgroundColor: cs.primary,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, cs.primary.withAlpha(200)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm + AppSpacing.xs, // 12px
                AppSpacing.md,
                0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withAlpha(51),
                    child: Text(
                      profile.initials,
                      style: AppTypography.h5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AppSpacing.horizontalSpaceSM,
                  const SizedBox(
                    width: AppSpacing.xs + AppSpacing.xs / 2,
                  ), // ~6px extra = 14px total
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome back,',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                        Text(
                          profile.firstName,
                          style: AppTypography.h4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedNotification01,
                      color: Colors.white,
                      size: AppSpacing.iconSizeMD,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Collapsed app bar title
      title: Text(
        'Dashboard',
        style: AppTypography.h6.copyWith(
          color: cs.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actionsIconTheme: IconThemeData(color: cs.onPrimary),
      actions: [
        Builder(
          builder: (ctx) => IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedLogout01,
              color: cs.onPrimary,
              size: AppSpacing.iconSizeMD,
            ),
            tooltip: 'Logout',
            onPressed: () => ctx.go('/login'),
          ),
        ),
      ],
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm + AppSpacing.xs, // 12px
      crossAxisSpacing: AppSpacing.sm + AppSpacing.xs, // 12px
      childAspectRatio: 0.85,
      children: [
        StatCard(
          label: 'Total Value',
          value: formatNaira(summary.totalOrderValue),
          icon: HugeIcons.strokeRoundedReceipt,
          iconColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.secondary
              : cs.primary,
        ),
        StatCard(
          label: 'Points',
          value: summary.totalPoints.toString(),
          icon: HugeIcons.strokeRoundedStars,
          iconColor: const Color(0xFFF59E0B),
        ),
        StatCard(
          label: 'Orders',
          value: summary.totalOrders.toString(),
          icon: HugeIcons.strokeRoundedShoppingBag01,
          iconColor: const Color(0xFF10B981),
        ),
        StatCard(
          label: 'Reorders',
          value: summary.totalOrders.toString(),
          icon: HugeIcons.strokeRoundedRefresh,
          iconColor: const Color(0xFFFF8C00),
        ),
      ],
    );
  }
}

// ─── Earnings card ────────────────────────────────────────────────────────

class _EarningsCard extends StatelessWidget {
  const _EarningsCard({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.secondary, cs.secondary.withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.borderRadiusXL,
      ),
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedWallet01,
                color: cs.onSecondary,
                size: AppSpacing.iconSizeSM,
              ),
              AppSpacing.horizontalSpaceSM,
              Text(
                'Commission Earnings',
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSecondary.withAlpha(230),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _EarningPill(
                label: 'Total Earned',
                value: formatNaira(summary.totalEarned),
                dark: true,
              ),
              _EarningPill(
                label: 'Pending',
                value: formatNaira(summary.pendingCommission),
                dark: false,
              ),
              _EarningPill(
                label: 'Available',
                value: formatNaira(summary.availableToWithdraw),
                dark: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EarningPill extends StatelessWidget {
  const _EarningPill({
    required this.label,
    required this.value,
    required this.dark,
  });
  final String label;
  final String value;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: cs.onSecondary.withAlpha(179),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.verticalSpaceXS,
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: cs.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
        ),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('See all')),
      ],
    );
  }
}

// ─── Order card ───────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.sm + AppSpacing.xs,
      ), // 12px
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusMD,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: AppSpacing.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.secondary.withAlpha(25)
                    : cs.primary.withAlpha(25),
                borderRadius: AppSpacing.borderRadiusSM,
              ),
              child: Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedShoppingBag01,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.secondary
                      : cs.primary,
                  size: AppSpacing.iconSizeSM,
                ),
              ),
            ),
            AppSpacing.horizontalSpaceSM,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstItem?.productName ?? 'Order ${order.id}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.verticalSpaceXS,
                  Text(
                    '${order.items.length} item(s) · #${order.id}',
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.horizontalSpaceSM,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNaira(order.total),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.secondary
                        : cs.primary,
                  ),
                ),
                AppSpacing.verticalSpaceSM,
                OrderStatusBadge(status: order.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
