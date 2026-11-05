import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/commission_models.dart';

class CommissionRecordCard extends StatelessWidget {
  const CommissionRecordCard({
    super.key,
    required this.record,
  });

  final CommissionRecord record;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = record.statusColor;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2C) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status badge & Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(isDark ? 45 : 25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withAlpha(90)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      record.statusName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatNaira(record.amount),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: record.status == 4
                      ? AppColors.error
                      : (isDark ? Colors.white : AppColors.onBackground),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Order Number & Tier Level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  record.sourceOrderNumber ?? 'Order #${record.sourceId ?? record.id}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Tier ${record.commissionLevel}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Customer Name & Plan
          if (record.sourceCustomerName != null) ...[
            Text(
              'Customer: ${record.sourceCustomerName}',
              style: AppTypography.caption.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
          ],

          if (record.commissionRule != null)
            Text(
              'Plan: ${record.commissionRule!.title}',
              style: AppTypography.caption.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                fontSize: 11.5,
              ),
            ),

          const Divider(height: 16),

          // Calculation rate & Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.appliedRate != null
                    ? '${record.appliedRate!.toStringAsFixed(1)}% of ${formatNaira(record.calculationBase)}'
                    : 'Base: ${formatNaira(record.calculationBase)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              _buildDateInfo(isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(bool isDark) {
    String label;
    DateTime? dt;

    if (record.releasedAt != null) {
      label = 'Paid: ';
      dt = record.releasedAt;
    } else if (record.eligibleAt != null) {
      label = 'Eligible: ';
      dt = record.eligibleAt;
    } else {
      label = '';
      dt = record.createdAt;
    }

    if (dt == null) return const SizedBox.shrink();

    return Text(
      '$label${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}',
      style: AppTypography.caption.copyWith(
        fontSize: 11,
        color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
      ),
    );
  }
}

