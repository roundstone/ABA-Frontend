import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

/// Modal dialogs displayed during checkout payment verification and pending states.
class CheckoutPaymentDialogs {
  const CheckoutPaymentDialogs._();

  static void showVerifyingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSpacing.radiusLG),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                SizedBox(height: 20),
                Text(
                  'Verifying Payment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Confirming your transaction with Paystack. Please do not close this screen...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showPaymentPendingDialog(BuildContext context, dynamic orderId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedAlert02,
                    color: AppColors.warning,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Payment Processing',
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Your payment for order #$orderId is awaiting confirmation. We're checking the transaction with Paystack. If you were debited, please don't make another payment. Your order status will be updated once your payment is confirmed.",
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: 'View Order Details',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go('/account/orders/$orderId');
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              AppButton.text(
                label: 'Dismiss',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showVerificationFailedDialog({
    required BuildContext context,
    required dynamic orderId,
    required VoidCallback onRetry,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedTime04,
                    color: AppColors.warning,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Verification Pending',
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'We could not immediately verify payment for order #$orderId. If you were debited, your order will update automatically once confirmed.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: 'Retry Verification',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onRetry();
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              AppButton.outlined(
                label: 'View Order Details',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go('/account/orders/$orderId');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
