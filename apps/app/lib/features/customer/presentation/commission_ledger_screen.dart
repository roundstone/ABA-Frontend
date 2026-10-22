import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/commission_ledger_entry.dart';
import 'widgets/commission_flow_timeline_card.dart';

final commissionLedgerEntriesProvider = Provider<List<CommissionLedgerEntry>>((ref) {
  return [
    CommissionLedgerEntry(
      id: 'cfl-001',
      date: DateTime(2026, 9, 3, 11, 0),
      commissionNumber: 'COM-001',
      orderNumber: 'ORD-001',
      beneficiaryName: 'Aisha Bello',
      level: 1,
      stage: CommissionFlowStage.accrual,
      journalEntryNumber: 'JE-0003',
      debitAccountCode: '6000',
      debitAccountName: 'Operating Expenses (Referral)',
      creditAccountCode: '2110',
      creditAccountName: 'Commissions Payable',
      amountInKobo: 1250000,
      runningPayableBalanceInKobo: 1250000,
      status: 'Posted',
      notes: 'Direct 5% referral commission on ORD-001',
    ),
    CommissionLedgerEntry(
      id: 'cfl-002',
      date: DateTime(2026, 9, 17, 9, 30),
      commissionNumber: 'COM-001',
      orderNumber: 'ORD-001',
      beneficiaryName: 'Aisha Bello',
      level: 1,
      stage: CommissionFlowStage.walletCredited,
      journalEntryNumber: 'JE-0008',
      debitAccountCode: '2110',
      debitAccountName: 'Commissions Payable',
      creditAccountCode: '2100',
      creditAccountName: 'Marketer Wallet Liability',
      amountInKobo: 1250000,
      runningPayableBalanceInKobo: 0,
      status: 'Posted',
      notes: 'Cool-off completed; credited to user wallet for withdrawal or shopping',
    ),
    CommissionLedgerEntry(
      id: 'cfl-003',
      date: DateTime(2026, 9, 18, 14, 15),
      commissionNumber: 'PO-001',
      orderNumber: 'ORD-001',
      beneficiaryName: 'Aisha Bello',
      level: 1,
      stage: CommissionFlowStage.payoutDisbursed,
      journalEntryNumber: 'JE-0012',
      debitAccountCode: '2100',
      debitAccountName: 'Marketer Wallet Liability',
      creditAccountCode: '1010',
      creditAccountName: 'Bank Account',
      amountInKobo: 1000000,
      runningPayableBalanceInKobo: 0,
      status: 'Posted',
      notes: 'Withdrawal disburse to GTBank via Paystack transfer',
    ),
    CommissionLedgerEntry(
      id: 'cfl-004',
      date: DateTime(2026, 9, 20, 16, 0),
      commissionNumber: 'COM-002',
      orderNumber: 'ORD-002',
      beneficiaryName: 'Michael Okon',
      level: 1,
      stage: CommissionFlowStage.accrual,
      journalEntryNumber: 'JE-0015',
      debitAccountCode: '6000',
      debitAccountName: 'Operating Expenses (Referral)',
      creditAccountCode: '2110',
      creditAccountName: 'Commissions Payable',
      amountInKobo: 1800000,
      runningPayableBalanceInKobo: 1800000,
      status: 'Posted',
      notes: 'Direct 5% referral commission on ORD-002',
    ),
    CommissionLedgerEntry(
      id: 'cfl-005',
      date: DateTime(2026, 9, 21, 10, 45),
      commissionNumber: 'COM-003',
      orderNumber: 'ORD-002',
      beneficiaryName: 'Aisha Bello',
      level: 2,
      stage: CommissionFlowStage.accrual,
      journalEntryNumber: 'JE-0016',
      debitAccountCode: '6000',
      debitAccountName: 'Operating Expenses (Referral)',
      creditAccountCode: '2110',
      creditAccountName: 'Commissions Payable',
      amountInKobo: 450000,
      runningPayableBalanceInKobo: 2250000,
      status: 'Posted',
      notes: 'Tier-2 network bonus on ORD-002 via direct sub-referral',
    ),
    CommissionLedgerEntry(
      id: 'cfl-006',
      date: DateTime(2026, 9, 22, 12, 0),
      commissionNumber: 'REV-001',
      orderNumber: 'ORD-004',
      beneficiaryName: 'Chidi Eze',
      level: 1,
      stage: CommissionFlowStage.reversed,
      journalEntryNumber: 'JE-0019',
      debitAccountCode: '2110',
      debitAccountName: 'Commissions Payable',
      creditAccountCode: '6000',
      creditAccountName: 'Operating Expenses (Clawback)',
      amountInKobo: 800000,
      runningPayableBalanceInKobo: 1450000,
      status: 'Reversed',
      notes: 'Clawback due to customer order cancellation & refund',
    ),
  ];
});

class CommissionLedgerScreen extends ConsumerStatefulWidget {
  const CommissionLedgerScreen({super.key});

  @override
  ConsumerState<CommissionLedgerScreen> createState() =>
      _CommissionLedgerScreenState();
}

class _CommissionLedgerScreenState
    extends ConsumerState<CommissionLedgerScreen> {
  CommissionFlowStage? _selectedStage;

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(commissionLedgerEntriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _selectedStage == null
        ? entries
        : entries.where((e) => e.stage == _selectedStage).toList();

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
        title: const Text('Commission Financial Ledger'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Commission Flow Timeline
          const CommissionFlowTimelineCard(),
          const SizedBox(height: AppSpacing.lg),

          // Stage Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All Entries',
                  isSelected: _selectedStage == null,
                  onTap: () => setState(() => _selectedStage = null),
                ),
                ...CommissionFlowStage.values.map(
                  (st) => _buildFilterChip(
                    label: st.label,
                    isSelected: _selectedStage == st,
                    onTap: () => setState(() => _selectedStage = st),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Entries List
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              alignment: Alignment.center,
              child: Text(
                'No ledger entries found for this filter.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                ),
              ),
            )
          else
            ...filtered.map((item) => _buildLedgerCard(item, isDark)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withAlpha(40),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
    );
  }

  Widget _buildLedgerCard(CommissionLedgerEntry entry, bool isDark) {
    Color stageColor;
    IconData stageIcon;

    switch (entry.stage) {
      case CommissionFlowStage.accrual:
        stageColor = const Color(0xFFFFA000);
        stageIcon = Icons.arrow_outward;
        break;
      case CommissionFlowStage.walletCredited:
        stageColor = const Color(0xFF43A047);
        stageIcon = Icons.account_balance_wallet_outlined;
        break;
      case CommissionFlowStage.payoutDisbursed:
        stageColor = const Color(0xFF1E88E5);
        stageIcon = Icons.account_balance_outlined;
        break;
      case CommissionFlowStage.reversed:
        stageColor = const Color(0xFFE53935);
        stageIcon = Icons.replay;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: stageColor.withAlpha(isDark ? 50 : 25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: stageColor.withAlpha(90)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(stageIcon, size: 12, color: stageColor),
                    const SizedBox(width: 4),
                    Text(
                      entry.stage.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: stageColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₦${entry.amountInNaira.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: entry.stage == CommissionFlowStage.reversed
                      ? AppColors.error
                      : (isDark ? Colors.white : AppColors.onBackground),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${entry.journalEntryNumber} • ${entry.orderNumber}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                style: AppTypography.caption.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            '${entry.beneficiaryName} (Level ${entry.level})',
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            ),
          ),
          const Divider(height: 16),

          // Double Entry Accounting details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Debit (Dr)', style: TextStyle(fontSize: 10, color: AppColors.grey)),
                    Text(
                      '${entry.debitAccountCode} ${entry.debitAccountName}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_right_alt, size: 16, color: AppColors.grey),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Credit (Cr)', style: TextStyle(fontSize: 10, color: AppColors.grey)),
                    Text(
                      '${entry.creditAccountCode} ${entry.creditAccountName}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
