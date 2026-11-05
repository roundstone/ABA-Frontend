import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/wallet_entities.dart';

class TransactionDetailSheet extends StatelessWidget {
  const TransactionDetailSheet({super.key, required this.transaction});

  final WalletTransaction transaction;

  static void show(BuildContext context, WalletTransaction transaction) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionDetailSheet(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCredit = transaction.type == TransactionType.credit;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Important: give the sheet a max height so it never becomes unbounded
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SafeArea(
        child: SingleChildScrollView(
          // ← prevents overflow on small screens / long content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // title + status
              Row(
                children: [
                  Expanded(
                    // ← take remaining space
                    child: Text(
                      'Transaction Details',
                      style: AppTypography.h6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(transaction.status).withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      transaction.status.displayName,
                      style: TextStyle(
                        color: _statusColor(transaction.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // amount + description
              Center(
                child: Column(
                  children: [
                    Text(
                      '${isCredit ? '+' : '-'}${formatNaira(transaction.amount)}',
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCredit ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.xs),

              _buildRow(
                context,
                'Type',
                transaction.transactionType.displayName,
              ),

              if (transaction.referenceNumber != null &&
                  transaction.referenceNumber!.isNotEmpty)
                _buildCopyableRow(
                  context,
                  'Reference',
                  transaction.referenceNumber!,
                ),

              _buildRow(
                context,
                'Date',
                DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.date),
              ),

              if (transaction.balanceBefore != null)
                _buildRow(
                  context,
                  'Balance Before',
                  formatNaira(transaction.balanceBefore!),
                ),

              if (transaction.balanceAfter != null)
                _buildRow(
                  context,
                  'Balance After',
                  formatNaira(transaction.balanceAfter!),
                ),

              if (transaction.sourceType != null)
                _buildRow(
                  context,
                  'Source',
                  transaction.sourceType!.replaceAll('_', ' '),
                ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            // ← key fix
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            // ← key fix
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                AppSnackbar.show(
                  context,
                  message: 'Reference copied to clipboard',
                  type: AppSnackbarType.info,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    // ← prevents the nested Row from exploding
                    child: Text(
                      value,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedCopy01,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.failed:
      case TransactionStatus.cancelled:
        return AppColors.error;
    }
  }
}
