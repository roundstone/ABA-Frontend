import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_error.dart';
import '../../../core/providers/notifications_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/application/auth_providers.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/checkout_entities.dart';
import '../domain/checkout_repository.dart';
import 'checkout_state.dart';

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier({required this.repository, required this.ref})
    : super(const CheckoutState()) {
    init();
  }

  final CheckoutRepository repository;
  final Ref ref;

  Future<void> init() async {
    state = state.copyWith(isLoadingInit: true, clearError: true);
    try {
      final user = ref.read(currentUserProvider);
      CheckoutCustomerInfo customerInfo = state.customerInfo;
      if (user != null) {
        final nameParts = user.name.trim().split(RegExp(r'\s+'));
        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        customerInfo = CheckoutCustomerInfo(
          firstName: firstName,
          lastName: lastName,
          email: user.email,
          phone: user.phone,
        );
      }

      final addresses = await repository.getSavedAddresses();
      final methods = await repository.getDeliveryMethods();

      final CheckoutAddress? defaultAddress = addresses.isNotEmpty
          ? addresses.firstWhere(
              (a) => a.isDefault,
              orElse: () => addresses.first,
            )
          : null;

      final defaultMethod = methods.isNotEmpty ? methods.first : null;

      state = state.copyWith(
        isLoadingInit: false,
        customerInfo: customerInfo,
        savedAddresses: addresses,
        selectedAddress: defaultAddress,
        isNewAddressMode: addresses.isEmpty,
        deliveryMethods: methods,
        selectedDeliveryMethod: defaultMethod,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingInit: false,
        errorMessage: ApiError.toUserFriendlyMessage(e),
      );
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 5) {
      state = state.copyWith(step: step, clearError: true);
    }
  }

  void nextStep() {
    if (state.step < 5) {
      state = state.copyWith(step: state.step + 1, clearError: true);
    }
  }

  void prevStep() {
    if (state.step > 1) {
      state = state.copyWith(step: state.step - 1, clearError: true);
    }
  }

  void updateCustomerInfo(CheckoutCustomerInfo info) {
    state = state.copyWith(customerInfo: info);
  }

  void selectAddress(CheckoutAddress address) {
    state = state.copyWith(selectedAddress: address, isNewAddressMode: false);
  }

  void updateCustomAddress(CheckoutAddress address) {
    state = state.copyWith(selectedAddress: address, isNewAddressMode: true);
  }

  void toggleNewAddressMode(bool isNew) {
    state = state.copyWith(isNewAddressMode: isNew);
  }

  void selectDeliveryMethod(DeliveryMethod method) {
    state = state.copyWith(selectedDeliveryMethod: method);
  }

  void selectPaymentType(CheckoutPaymentType paymentType) {
    state = state.copyWith(paymentType: paymentType);
  }

  Future<void> searchReferrals(String query) async {
    state = state.copyWith(
      referralQuery: query,
      isSearchingReferral: query.trim().length >= 2,
    );
    if (query.trim().length < 2) {
      state = state.copyWith(
        referralSearchResults: const [],
        isSearchingReferral: false,
      );
      return;
    }

    try {
      final results = await repository.searchReferrals(query);
      state = state.copyWith(
        referralSearchResults: results,
        isSearchingReferral: false,
      );
    } catch (_) {
      state = state.copyWith(
        referralSearchResults: const [],
        isSearchingReferral: false,
      );
    }
  }

  void applyReferral(ReferralCandidate candidate) {
    state = state.copyWith(
      appliedReferral: candidate,
      referralQuery: '',
      referralSearchResults: const [],
      isSearchingReferral: false,
    );
  }

  void removeReferral() {
    state = state.copyWith(
      clearAppliedReferral: true,
      referralQuery: '',
      referralSearchResults: const [],
    );
  }

  Future<CheckoutOrderResult?> submitOrder(
    Cart cart, {
    String? paymentReference,
    bool clearCartOnSuccess = true,
  }) async {
    if (state.selectedAddress == null || state.selectedDeliveryMethod == null) {
      state = state.copyWith(
        errorMessage: 'Please complete all address and delivery details.',
      );
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    // 1. Check availability via GET /api/v1/cart/mobile-app/availability
    try {
      final avail = await ref.read(cartProvider.notifier).checkAvailability();
      AppLogger.d('Cart availability: ${avail.isAvailable}');
      if (!avail.isAvailable) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage:
              avail.message ??
              'Some items in your cart are no longer available in the requested quantity.',
        );
        return null;
      }
    } catch (_) {}

    // 2. Verify payment reference via GET /api/v1/payments/mobile-app/paystack/{reference}/verify
    if (paymentReference != null && paymentReference.isNotEmpty) {
      final verified = await repository.verifyPaystackPayment(paymentReference);
      if (!verified) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage:
              'Paystack payment verification failed. Please try again.',
        );
        return null;
      }
    }

    // 3. Create order via POST /api/v1/orders/mobile-app
    try {
      final result = await repository.placeOrder(
        cart: cart,
        customerInfo: state.customerInfo,
        address: state.selectedAddress!,
        deliveryMethod: state.selectedDeliveryMethod!,
        paymentType: state.paymentType,
        referral: state.appliedReferral,
        paymentReference: paymentReference,
      );

      // Clear the user's cart if immediate settlement is desired
      if (clearCartOnSuccess) {
        await ref.read(cartProvider.notifier).clearCart();
      }

      // Add notification
      final notifNotifier = ref.read(notificationsProvider.notifier);
      notifNotifier.addNotification(
        AppNotification(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Order Confirmed: ${result.orderId}',
          body:
              'Your order has been placed successfully and is currently being processed.',
          time: 'Just now',
          icon: HugeIcons.strokeRoundedPackage,
          color: AppColors.success,
        ),
      );

      state = state.copyWith(isSubmitting: false, createdOrderResult: result);
      return result;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: ApiError.toUserFriendlyMessage(e),
      );
      return null;
    }
  }
}
