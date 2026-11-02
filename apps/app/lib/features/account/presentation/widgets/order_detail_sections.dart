import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/customer_order.dart';

export 'order_detail_payment_section.dart';

class OrderDetailSummarySection extends StatelessWidget {
  const OrderDetailSummarySection({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.00');

    final subtotal = order.items.fold<int>(
      0,
      (acc, item) => acc + (item.price * item.quantity),
    );
    final deliveryFee = (order.total - subtotal).clamp(0, 999999999);
    final deliveryMethodLabel = order.deliveryMethod.toLowerCase() == 'express'
        ? 'Express Delivery'
        : 'Standard Delivery';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _summaryRow('Subtotal', '₦${formatter.format(subtotal / 100.0)}', cs),
          const SizedBox(height: AppSpacing.sm),
          _summaryRow(
            'Delivery Method',
            deliveryMethodLabel,
            cs,
          ),
          const SizedBox(height: AppSpacing.sm),
          _summaryRow(
            'Delivery Fee',
            '₦${formatter.format(deliveryFee / 100.0)}',
            cs,
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₦${formatter.format(order.total / 100.0)}',
                style: AppTypography.h4.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
        ),
        Text(value, style: AppTypography.bodyMedium),
      ],
    );
  }
}
