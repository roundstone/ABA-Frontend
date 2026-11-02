import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/customer_order.dart';
import 'payment_verify_button.dart';

class PaymentAttemptTile extends StatelessWidget {
  const PaymentAttemptTile({
    super.key,
    required this.payment,
    required this.order,
    required this.isDark,
    this.isVerifying = false,
    this.onVerify,
  });

  final CustomerOrderPayment payment;
  final CustomerOrder order;
  final bool isDark;
  final bool isVerifying;
  final ValueChanged<String>? onVerify;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final formatter = NumberFormat('#,##0.00');
    final isSuccess =
        payment.status.toLowerCase() == 'success' || payment.paidAt != null;
    final isFailed = payment.status.toLowerCase() == 'failed';
    final effectiveDate = payment.createdAt ?? payment.paidAt;
    final dateStr = effectiveDate != null
        ? DateFormat('MMM d, h:mm a').format(effectiveDate)
        : null;
    final badgeColor = isSuccess
        ? AppColors.success
        : (isFailed ? AppColors.error : const Color(0xFFB45309));

    final canVerify = order.isUnpaid &&
        payment.status.toLowerCase() == 'pending' &&
        payment.reference != null &&
        payment.reference!.trim().isNotEmpty;

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
                    Text(
                      '₦${formatter.format(payment.amount / 100.0)}',
                      style: AppTypography.bodySmall
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (dateStr != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        '• $dateStr',
                        style: AppTypography.caption.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      payment.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  if (canVerify) ...[
                    const SizedBox(width: 6),
                    PaymentVerifyButton(
                      key: ValueKey('verify_payment_button_${payment.reference}'),
                      reference: payment.reference!,
                      isDark: isDark,
                      isVerifying: isVerifying,
                      onTap: onVerify != null
                          ? () => onVerify!(payment.reference!)
                          : null,
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (payment.reference != null && payment.reference!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ref: ${payment.reference}',
                    style: AppTypography.caption.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: payment.reference!));
                    AppSnackbar.show(
                      context,
                      message: 'Reference copied to clipboard',
                      type: AppSnackbarType.info,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedCopy01,
                      size: 12,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (payment.failureReason != null &&
              payment.failureReason!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedAlertCircle,
                  color: AppColors.error,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    payment.failureReason!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.error,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
