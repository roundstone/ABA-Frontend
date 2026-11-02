import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/orders_providers.dart';
import '../../domain/customer_order.dart';

class OrderCancelDialog extends ConsumerStatefulWidget {
  const OrderCancelDialog({super.key, required this.order});

  final CustomerOrder order;

  static Future<bool?> show(BuildContext context, CustomerOrder order) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderCancelDialog(order: order),
    );
  }

  @override
  ConsumerState<OrderCancelDialog> createState() => _OrderCancelDialogState();
}

class _OrderCancelDialogState extends ConsumerState<OrderCancelDialog> {
  static const _reasons = [
    'Changed my mind',
    'Found a better price elsewhere',
    'Ordered items by mistake',
    'Delivery time is too long',
    'Other reason',
  ];

  String _selectedReason = _reasons.first;
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmCancel() async {
    final effectiveReason = _selectedReason == 'Other reason'
        ? (_commentController.text.trim().isNotEmpty
            ? _commentController.text.trim()
            : 'Other reason')
        : (_commentController.text.trim().isNotEmpty
            ? '$_selectedReason - ${_commentController.text.trim()}'
            : _selectedReason);

    setState(() => _isLoading = true);
    try {
      final api = ref.read(ordersApiProvider);
      await api.cancelOrder(
        orderId: widget.order.id,
        cancellationReason: effectiveReason,
      );

      ref.invalidate(customerOrderByIdProvider(widget.order.id));
      ref.read(customerOrdersNotifierProvider.notifier).refresh();

      if (mounted) {
        Navigator.of(context).pop(true);
        AppSnackbar.show(
          context,
          message: 'Order #${widget.order.orderNumber} has been cancelled.',
          type: AppSnackbarType.info,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackbar.show(
          context,
          message: ApiError.toUserFriendlyMessage(e),
          type: AppSnackbarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Cancel Order', style: AppTypography.h3),
            const SizedBox(height: 4),
            Text(
              'Please select the reason you wish to cancel Order #${widget.order.orderNumber}.',
              style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._reasons.map((r) {
              final isSelected = _selectedReason == r;
              return InkWell(
                onTap: _isLoading ? null : () => setState(() => _selectedReason = r),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.grey,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(r, style: AppTypography.bodyMedium)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _commentController,
              hintText: 'Additional details (optional)...',
              maxLines: 2,
              enabled: !_isLoading,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton.outlined(
                    label: 'Keep Order',
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.destructive(
                    label: _isLoading ? 'Cancelling...' : 'Confirm Cancel',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _handleConfirmCancel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
