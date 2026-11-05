import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/network/api_error.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../application/commission_providers.dart';
import 'widgets/commission_flow_timeline_card.dart';
import 'widgets/commission_overview_cards.dart';
import 'widgets/commission_record_card.dart';

class CommissionLedgerScreen extends ConsumerWidget {
  const CommissionLedgerScreen({super.key});

  static const _filters = [
    (label: 'All', status: null),
    (label: 'Pending Approval', status: 1),
    (label: 'Approved', status: 2),
    (label: 'Paid', status: 3),
    (label: 'Reversed', status: 4),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(commissionOverviewProvider);
    final listAsync = ref.watch(commissionsListProvider);
    final currentStatus = ref.watch(commissionFilterStatusProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          onPressed: () => context.popOrGo('/referrals'),
        ),
        title: const Text('Commissions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(commissionOverviewProvider);
          ref.invalidate(commissionsListProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // 1. Commission Flow Double-Entry Accounting Timeline
            const CommissionFlowTimelineCard(),
            const SizedBox(height: AppSpacing.md),

            // 2. Overview KPI Cards
            overviewAsync.when(
              data: (overview) => CommissionOverviewCards(overview: overview),
              loading: () => const CommissionOverviewCards(
                overview: CommissionOverview.empty,
                isLoading: true,
              ),
              error: (err, _) => _buildErrorCard(
                context,
                message: ApiError.toUserFriendlyMessage(err),
                onRetry: () => ref.invalidate(commissionOverviewProvider),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3. Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = currentStatus == f.status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(f.label),
                      selected: isSelected,
                      onSelected: (_) {
                        ref.read(commissionFilterStatusProvider.notifier).state = f.status;
                      },
                      selectedColor: AppColors.primary.withAlpha(40),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 4. Commission Records List
            listAsync.when(
              data: (paginated) {
                if (paginated.items.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedInvoice01,
                          color: AppColors.grey,
                          size: 36,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'No commission records found for this filter.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: paginated.items
                      .map((record) => CommissionRecordCard(record: record))
                      .toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (err, _) => _buildErrorCard(
                context,
                message: ApiError.toUserFriendlyMessage(err),
                onRetry: () => ref.invalidate(commissionsListProvider),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withAlpha(50)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
