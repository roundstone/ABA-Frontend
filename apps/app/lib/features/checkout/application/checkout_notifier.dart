import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/providers/notifications_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../shop/application/shop_providers.dart';
import '../../shop/domain/shop_entities.dart';
import '../domain/checkout_entities.dart';
import '../domain/checkout_repository.dart';
import 'checkout_state.dart';

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier({
    required this.repository,
    required this.ref,
  }) : super(const CheckoutState()) {
    init();
  }

  final CheckoutRepository repository;
  final Ref ref;

  Future<void> init() async {
    state = state.copyWith(isLoadingInit: true, clearError: true);
    try {
      final addresses = await repository.getSavedAddresses();
      final methods = await repository.getDeliveryMethods();

      final defaultAddress = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.isNotEmpty
            ? addresses.first
            : const CheckoutAddress(
                id: 'new_1',
                label: 'Home',
                fullName: 'Jane Doe',
                street: '123 Market Street, Victoria Island',
                city: 'Lagos',
                state: 'Lagos',
                zipCode: '101241',
                phone: '+234 801 234 5678',
              ),
      );

      final defaultMethod = methods.isNotEmpty ? methods.first : null;

      state = state.copyWith(
        isLoadingInit: false,
        savedAddresses: addresses,
        selectedAddress: defaultAddress,
        deliveryMethods: methods,
        selectedDeliveryMethod: defaultMethod,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingInit: false,
        errorMessage: 'Failed to initialize checkout: ${e.toString()}',
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
    state = state.copyWith(
      selectedAddress: address,
      isNewAddressMode: false,
    );
  }

  void updateCustomAddress(CheckoutAddress address) {
    state = state.copyWith(
      selectedAddress: address,
      isNewAddressMode: true,
    );
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

  Future<CheckoutOrderResult?> submitOrder(Cart cart) async {
    if (state.selectedAddress == null || state.selectedDeliveryMethod == null) {
      state = state.copyWith(
        errorMessage: 'Please complete all address and delivery details.',
      );
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final result = await repository.placeOrder(
        cart: cart,
        customerInfo: state.customerInfo,
        address: state.selectedAddress!,
        deliveryMethod: state.selectedDeliveryMethod!,
        paymentType: state.paymentType,
        referral: state.appliedReferral,
      );

      // Clear the user's cart
      ref.read(cartProvider.notifier).clearCart();

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

      state = state.copyWith(
        isSubmitting: false,
        createdOrderResult: result,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }
}
