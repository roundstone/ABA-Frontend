import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/wallet_entities.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isCredit = transaction.type == TransactionType.credit;
    final iconColor = isCredit ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: cs.outlineVariant.withAlpha(51),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: AppSpacing.borderRadiusMD,
            ),
            child: HugeIcon(
              icon: isCredit
                  ? HugeIcons.strokeRoundedArrowDownLeft01
                  : HugeIcons.strokeRoundedArrowUpRight01,
              color: iconColor,
              size: AppSpacing.iconSizeSM,
            ),
          ),
          AppSpacing.horizontalSpaceMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalSpaceXS,
                Row(
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.date),
                      style: AppTypography.label.copyWith(
                        color: cs.onSurface.withAlpha(153),
                      ),
                    ),
                    if (transaction.status != TransactionStatus.completed) ...[
                      const SizedBox(width: AppSpacing.xs),
                      _StatusBadge(status: transaction.status),
                    ],
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.horizontalSpaceSM,
          Text(
            '${isCredit ? '+' : '-'}${formatNaira(transaction.amount)}',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isCredit ? AppColors.success : cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final TransactionStatus status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case TransactionStatus.pending:
        color = AppColors.warning;
        label = 'Pending';
        break;
      case TransactionStatus.failed:
        color = AppColors.error;
        label = 'Failed';
        break;
      case TransactionStatus.completed:
        color = AppColors.success;
        label = 'Completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
