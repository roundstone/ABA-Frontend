import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../shop/domain/shop_entities.dart';
import '../../application/checkout_state.dart';
import '../../domain/checkout_entities.dart';
import 'review_items_preview.dart';
import 'review_summary_card.dart';

class StepReviewOrder extends StatelessWidget {
  const StepReviewOrder({
    super.key,
    required this.state,
    required this.cart,
    required this.onEditAddress,
    required this.onEditPayment,
    required this.onBack,
    required this.onPlaceOrder,
  });

  final CheckoutState state;
  final Cart cart;
  final VoidCallback onEditAddress;
  final VoidCallback onEditPayment;
  final VoidCallback onBack;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deliveryCost = state.selectedDeliveryMethod?.cost ?? 2500.0;
    final grandTotal = cart.subtotal + deliveryCost + cart.tax;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedCheckList,
                color: isDark ? AppColors.secondary : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Review Your Order',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildAlertBanner(isDark),
          const SizedBox(height: AppSpacing.md),
          ReviewSummaryCard(
            title: 'Delivery Address',
            onEdit: onEditAddress,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.selectedAddress?.fullName ?? state.customerInfo.fullName,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${state.selectedAddress?.street ?? ''}, ${state.selectedAddress?.city ?? ''}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Text(
                  state.selectedAddress?.phone ?? state.customerInfo.phone,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ReviewSummaryCard(
            title: 'Payment & Delivery',
            onEdit: onEditPayment,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Method: ${_paymentMethodLabel(state.paymentType)}',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Shipping: ${state.selectedDeliveryMethod?.name ?? 'Standard Delivery'} (${state.selectedDeliveryMethod?.duration ?? ''})',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Order Items (${cart.itemCount})',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ReviewItemsPreview(items: cart.items),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  label: 'Back',
                  onPressed: state.isSubmitting ? null : onBack,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: AppButton.primary(
                  label: 'Place Order (${formatNaira(grandTotal)})',
                  isLoading: state.isSubmitting,
                  onPressed: state.isSubmitting ? null : onPlaceOrder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha(20),
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: AppColors.warning.withAlpha(80),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedAlertCircle,
            color: AppColors.warning,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Please review your order details carefully before placing your order.',
              style: AppTypography.caption.copyWith(
                color: isDark ? Colors.white70 : const Color(0xFF8A5B00),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _paymentMethodLabel(CheckoutPaymentType type) {
    switch (type) {
      case CheckoutPaymentType.card:
        return 'Card Payment (Gateway)';
      case CheckoutPaymentType.wallet:
        return 'ABA Wallet';
      case CheckoutPaymentType.bankTransfer:
        return 'Bank Transfer';
    }
  }
}
