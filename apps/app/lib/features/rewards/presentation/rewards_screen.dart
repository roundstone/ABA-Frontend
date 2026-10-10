import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../application/rewards_providers.dart';
import 'widgets/how_to_earn_card.dart';
import 'widgets/redeem_points_card.dart';
import 'widgets/reward_ledger_tile.dart';
import 'widgets/reward_summary_cards.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(rewardSummaryProvider);
    final rulesAsync = ref.watch(rewardRulesProvider);
    final ledgerAsync = ref.watch(filteredRewardLedgerProvider);
    final currentFilter = ref.watch(rewardLedgerFilterProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Reward Points'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh,
              size: 20,
            ),
            onPressed: () {
              ref.invalidate(rewardSummaryProvider);
              ref.invalidate(rewardRulesProvider);
              ref.invalidate(rewardLedgerProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(rewardSummaryProvider);
          ref.invalidate(rewardRulesProvider);
          ref.invalidate(rewardLedgerProvider);
          await ref.read(rewardSummaryProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View your balance, history, and how to earn.',
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Summary Cards ───────────────────────────────────────────
              summaryAsync.when(
                data: (summary) => RewardSummaryCards(summary: summary),
                loading: () => const RewardSummaryCards(
                  summary: null,
                  isLoading: true,
                ),
                error: (_, __) => const RewardSummaryCards(summary: null),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── How To Earn & Redeem Section ─────────────────────────────
              rulesAsync.when(
                data: (rules) => HowToEarnCard(rules: rules),
                loading: () => const HowToEarnCard(rules: [], isLoading: true),
                error: (_, __) => const HowToEarnCard(rules: []),
              ),
              const SizedBox(height: AppSpacing.lg),

              const RedeemPointsCard(),
              const SizedBox(height: AppSpacing.xl),

              // ── Points History Header & Filter Chips ─────────────────────
              Text(
                'Points History',
                style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),

              _FilterChipsRow(
                currentFilter: currentFilter,
                onSelected: (filter) {
                  ref.read(rewardLedgerFilterProvider.notifier).state = filter;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Ledger Entries List ──────────────────────────────────────
              ledgerAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return _EmptyLedgerView(isDark: isDark);
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) =>
                        RewardLedgerTile(entry: entries[i]),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        Text('Could not load history: $e'),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(rewardLedgerProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.currentFilter,
    required this.onSelected,
  });

  final String currentFilter;
  final ValueChanged<String> onSelected;

  static const _filters = [
    ('all', 'All'),
    ('earn', 'Earned'),
    ('redeem', 'Redeemed'),
    ('adjust', 'Adjusted'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filters.map((f) {
          final isSelected = currentFilter == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: FilterChip(
              label: Text(f.$2),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) => onSelected(f.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyLedgerView extends StatelessWidget {
  const _EmptyLedgerView({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedClock01,
            size: 40,
            color: isDark ? Colors.white38 : AppColors.grey,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No points history found',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your reward transactions will appear here.',
            style: AppTypography.caption.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
