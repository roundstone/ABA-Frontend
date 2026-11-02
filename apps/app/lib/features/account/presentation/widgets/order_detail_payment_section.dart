import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/customer_order.dart';

class OrderDetailPaymentSection extends StatelessWidget {
  const OrderDetailPaymentSection({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.00');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment & Transactions',
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              _statusChip(
                order.isPaid ? 'PAID' : (order.isCancelled ? 'CANCELLED' : 'PENDING'),
                order.isPaid ? AppColors.success : (order.isCancelled ? AppColors.grey : const Color(0xFFB45309)),
                isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const HugeIcon(icon: HugeIcons.strokeRoundedCreditCard, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.paymentMethod,
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      order.isPaid
                          ? '₦${formatter.format(order.total / 100.0)} fully paid'
                          : (order.isCancelled ? 'Order cancelled' : 'Payment pending'),
                      style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (order.payments.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            Text('Transaction History (${order.payments.length})',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: cs.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.xs),
            ..._sortedPayments.map((p) => _PaymentAttemptTile(payment: p, isDark: isDark)),
          ],
        ],
      ),
    );
  }

  List<CustomerOrderPayment> get _sortedPayments {
    final list = List<CustomerOrderPayment>.from(order.payments);
    list.sort((a, b) {
      final aDate = a.createdAt ?? a.paidAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? b.paidAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return list;
  }

  Widget _statusChip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.5)),
    );
  }
}

class _PaymentAttemptTile extends StatelessWidget {
  const _PaymentAttemptTile({required this.payment, required this.isDark});

  final CustomerOrderPayment payment;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final formatter = NumberFormat('#,##0.00');
    final isSuccess = payment.status.toLowerCase() == 'success' || payment.paidAt != null;
    final isFailed = payment.status.toLowerCase() == 'failed';
    final effectiveDate = payment.createdAt ?? payment.paidAt;
    final dateStr = effectiveDate != null
        ? DateFormat('MMM d, h:mm a').format(effectiveDate)
        : null;
    final badgeColor = isSuccess ? AppColors.success : (isFailed ? AppColors.error : const Color(0xFFB45309));

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : AppColors.surface2,
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text('₦${formatter.format(payment.amount / 100.0)}',
                        style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                    if (dateStr != null) ...[
                      const SizedBox(width: 6),
                      Text('• $dateStr',
                          style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant, fontSize: 10)),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(payment.status.toUpperCase(),
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: badgeColor)),
              ),
            ],
          ),
          if (payment.reference != null && payment.reference!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text('Ref: ${payment.reference}',
                      style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant, fontSize: 10, fontFamily: 'monospace'),
                      overflow: TextOverflow.ellipsis),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: payment.reference!));
                    AppSnackbar.show(context, message: 'Reference copied to clipboard', type: AppSnackbarType.info);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: HugeIcon(icon: HugeIcons.strokeRoundedCopy01, size: 12, color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ],
          if (payment.failureReason != null && payment.failureReason!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const HugeIcon(icon: HugeIcons.strokeRoundedAlertCircle, color: AppColors.error, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(payment.failureReason!,
                      style: AppTypography.caption.copyWith(color: AppColors.error, fontSize: 10)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
