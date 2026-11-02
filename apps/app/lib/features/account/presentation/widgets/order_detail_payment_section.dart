import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/orders_providers.dart';
import '../../domain/customer_order.dart';
import 'payment_attempt_tile.dart';
import 'payment_verify_button.dart';

class OrderDetailPaymentSection extends ConsumerStatefulWidget {
  const OrderDetailPaymentSection({super.key, required this.order});

  final CustomerOrder order;

  @override
  ConsumerState<OrderDetailPaymentSection> createState() =>
      _OrderDetailPaymentSectionState();
}

class _OrderDetailPaymentSectionState
    extends ConsumerState<OrderDetailPaymentSection> {
  String? _verifyingReference;

  Future<void> _handleVerify(String reference) async {
    setState(() => _verifyingReference = reference);
    try {
      AppSnackbar.show(
        context,
        message: 'Verifying payment with gateway...',
        type: AppSnackbarType.info,
      );

      final api = ref.read(ordersApiProvider);
      final isVerified = await api.verifyPayment(reference);

      if (!mounted) return;

      if (isVerified) {
        AppSnackbar.show(
          context,
          message: 'Payment verified successfully! Updating order...',
          type: AppSnackbarType.success,
        );
        ref.invalidate(customerOrderByIdProvider(widget.order.id));
        ref.read(customerOrdersNotifierProvider.notifier).refresh();
      } else {
        AppSnackbar.show(
          context,
          message:
              'Payment is still pending on gateway. Please try again shortly.',
          type: AppSnackbarType.warning,
        );
      }
    } catch (e, stack) {
      AppLogger.e('Payment verification failed', error: e, stackTrace: stack);
      if (mounted) {
        AppSnackbar.show(
          context,
          message:
              'Could not verify payment: ${ApiError.toUserFriendlyMessage(e)}',
          type: AppSnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _verifyingReference = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,##0.00');

    final pendingPayment = widget.order.payments
        .where((p) =>
            p.status.toLowerCase() == 'pending' &&
            p.reference != null &&
            p.reference!.trim().isNotEmpty)
        .firstOrNull;
    final bool canVerifySection =
        widget.order.isUnpaid && pendingPayment != null;

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
              Text(
                'Payment & Transactions',
                style: AppTypography.bodyMedium
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _statusChip(
                    widget.order.isPaid
                        ? 'PAID'
                        : (widget.order.isCancelled ? 'CANCELLED' : 'PENDING'),
                    widget.order.isPaid
                        ? AppColors.success
                        : (widget.order.isCancelled
                            ? AppColors.grey
                            : const Color(0xFFB45309)),
                    isDark,
                  ),
                  if (canVerifySection) ...[
                    const SizedBox(width: AppSpacing.xs),
                    PaymentVerifyButton(
                      key: const ValueKey('header_verify_payment_button'),
                      reference: pendingPayment.reference!,
                      isDark: isDark,
                      isVerifying:
                          _verifyingReference == pendingPayment.reference,
                      onTap: _verifyingReference != null
                          ? null
                          : () => _handleVerify(pendingPayment.reference!),
                    ),
                  ],
                ],
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
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCreditCard,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.paymentMethod,
                      style: AppTypography.bodyMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.order.isPaid
                          ? '₦${formatter.format(widget.order.total / 100.0)} fully paid'
                          : (widget.order.isCancelled
                              ? 'Order cancelled'
                              : 'Payment pending'),
                      style: AppTypography.caption
                          .copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.order.payments.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Transaction History (${widget.order.payments.length})',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ..._sortedPayments.map(
              (p) => PaymentAttemptTile(
                payment: p,
                order: widget.order,
                isDark: isDark,
                isVerifying: _verifyingReference == p.reference,
                onVerify: _handleVerify,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<CustomerOrderPayment> get _sortedPayments {
    final list = List<CustomerOrderPayment>.from(widget.order.payments);
    list.sort((a, b) {
      final aDate =
          a.createdAt ?? a.paidAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          b.createdAt ?? b.paidAt ?? DateTime.fromMillisecondsSinceEpoch(0);
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
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
