import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_error.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../cart/application/cart_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../../wallet/application/wallet_providers.dart';
import '../application/checkout_notifier.dart';
import '../application/checkout_state.dart';
import '../application/payment_gateway_registry.dart';
import '../domain/checkout_entities.dart';
import '../domain/payment_gateway.dart';
import 'checkout_success_screen.dart';
import 'widgets/checkout_payment_dialogs.dart';
import 'widgets/paystack_payment_sheet.dart';

/// Handles order submission, payment gateway initialization, and verification loading.
class CheckoutOrderHandler {
  const CheckoutOrderHandler._();

  static Future<void> handlePlaceOrder({
    required BuildContext context,
    required WidgetRef ref,
    required CheckoutState checkoutState,
    required CheckoutNotifier notifier,
    required Cart cart,
    bool isDirectBuy = false,
  }) async {
    final isOnline = checkoutState.paymentType == CheckoutPaymentType.paystack ||
        checkoutState.paymentType == CheckoutPaymentType.card;
    final isWallet = checkoutState.paymentType == CheckoutPaymentType.wallet;

    final res = await notifier.submitOrder(
      cart,
      clearCartOnSuccess: false,
      isDirectBuy: isDirectBuy,
    );
    if (res == null || !context.mounted) return;

    if (isOnline) {
      final deliveryFee = CheckoutDeliveryPricing.effectiveFee(
        checkoutState.selectedDeliveryMethod,
      );
      final amountToPay =
          cart.subtotal > 0 ? (cart.subtotal + deliveryFee) : res.totalAmount;
      final email = checkoutState.customerInfo.email.isNotEmpty
          ? checkoutState.customerInfo.email
          : 'customer@aba.ng';

      final gateway = ref
          .read(paymentGatewayRegistryProvider)
          .getGateway(PaymentGatewayType.paystack);

      if (!context.mounted) return;
      final paymentRef = await PaystackPaymentSheet.show(
        context,
        amount: amountToPay,
        email: email,
        orderId: res.orderId,
        gatewayService: gateway,
      );

      if (paymentRef == null || paymentRef.isEmpty) {
        if (!context.mounted) return;
        CheckoutPaymentDialogs.showPaymentPendingDialog(context, res.orderId);
        return;
      }

      if (!context.mounted) return;
      final isVerified = await _verifyWithLoading(
        context: context,
        gateway: gateway,
        reference: paymentRef,
      );

      if (!isVerified) {
        if (!context.mounted) return;
        CheckoutPaymentDialogs.showVerificationFailedDialog(
          context: context,
          orderId: res.orderId,
          onRetry: () async {
            final ok = await _verifyWithLoading(
              context: context,
              gateway: gateway,
              reference: paymentRef,
            );
            if (ok) {
              if (!isDirectBuy) {
                await ref.read(cartProvider.notifier).syncAfterPayment();
              }
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => CheckoutSuccessScreen(order: res.order),
                  ),
                );
              }
            }
          },
        );
        return;
      }

      if (!isDirectBuy) {
        await ref.read(cartProvider.notifier).syncAfterPayment();
      }
    } else if (isWallet) {
      final deliveryFee = CheckoutDeliveryPricing.effectiveFee(
        checkoutState.selectedDeliveryMethod,
      );
      final amountToPay =
          cart.subtotal > 0 ? (cart.subtotal + deliveryFee) : res.totalAmount;
      final email = checkoutState.customerInfo.email.isNotEmpty
          ? checkoutState.customerInfo.email
          : 'customer@aba.ng';

      final gateway = ref
          .read(paymentGatewayRegistryProvider)
          .getGateway(PaymentGatewayType.paystack);

      if (!context.mounted) return;
      CheckoutPaymentDialogs.showVerifyingDialog(
        context,
        title: 'Processing Payment',
        message: 'Debiting your wallet balance for this order...',
      );

      try {
        await gateway.initializePayment(
          orderId: res.orderId,
          amount: amountToPay,
          email: email,
          paymentMethod: 2,
          extra: {'paymentMethod': 2},
        );

        ref.invalidate(walletInfoProvider);
        ref.invalidate(walletTransactionsProvider);

        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (!isDirectBuy) {
          await ref.read(cartProvider.notifier).syncAfterPayment();
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          final errorMsg = e is ApiError
              ? e.message
              : e.toString().replaceAll('Exception: ', '');
          AppSnackbar.error(
            context,
            errorMsg.isNotEmpty
                ? errorMsg
                : 'Wallet payment could not be completed.',
          );
          CheckoutPaymentDialogs.showPaymentPendingDialog(context, res.orderId);
          return;
        }
      }
    } else {
      if (!isDirectBuy) {
        await ref.read(cartProvider.notifier).clearCart();
        ref.invalidate(cartProvider);
      }
    }

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CheckoutSuccessScreen(order: res.order),
        ),
      );
    }
  }

  static Future<bool> _verifyWithLoading({
    required BuildContext context,
    required PaymentGatewayService gateway,
    required String reference,
  }) async {
    CheckoutPaymentDialogs.showVerifyingDialog(context);

    bool isVerified = false;
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        isVerified = await gateway.verifyPayment(reference);
        if (isVerified) break;
      } catch (_) {}
      await Future<void>.delayed(const Duration(milliseconds: 1500));
    }

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    return isVerified;
  }
}
