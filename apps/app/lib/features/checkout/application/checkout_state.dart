import '../domain/checkout_entities.dart';

class CheckoutState {
  const CheckoutState({
    this.step = 1,
    this.customerInfo = const CheckoutCustomerInfo(
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane.doe@example.com',
      phone: '+234 801 234 5678',
    ),
    this.savedAddresses = const [],
    this.selectedAddress,
    this.isNewAddressMode = false,
    this.deliveryMethods = const [],
    this.selectedDeliveryMethod,
    this.paymentType = CheckoutPaymentType.card,
    this.appliedReferral,
    this.referralQuery = '',
    this.referralSearchResults = const [],
    this.isSearchingReferral = false,
    this.isSubmitting = false,
    this.isLoadingInit = true,
    this.errorMessage,
    this.createdOrderResult,
  });

  final int step;
  final CheckoutCustomerInfo customerInfo;
  final List<CheckoutAddress> savedAddresses;
  final CheckoutAddress? selectedAddress;
  final bool isNewAddressMode;
  final List<DeliveryMethod> deliveryMethods;
  final DeliveryMethod? selectedDeliveryMethod;
  final CheckoutPaymentType paymentType;
  final ReferralCandidate? appliedReferral;
  final String referralQuery;
  final List<ReferralCandidate> referralSearchResults;
  final bool isSearchingReferral;
  final bool isSubmitting;
  final bool isLoadingInit;
  final String? errorMessage;
  final CheckoutOrderResult? createdOrderResult;

  CheckoutState copyWith({
    int? step,
    CheckoutCustomerInfo? customerInfo,
    List<CheckoutAddress>? savedAddresses,
    CheckoutAddress? selectedAddress,
    bool? isNewAddressMode,
    List<DeliveryMethod>? deliveryMethods,
    DeliveryMethod? selectedDeliveryMethod,
    CheckoutPaymentType? paymentType,
    ReferralCandidate? appliedReferral,
    bool clearAppliedReferral = false,
    String? referralQuery,
    List<ReferralCandidate>? referralSearchResults,
    bool? isSearchingReferral,
    bool? isSubmitting,
    bool? isLoadingInit,
    String? errorMessage,
    bool clearError = false,
    CheckoutOrderResult? createdOrderResult,
  }) {
    return CheckoutState(
      step: step ?? this.step,
      customerInfo: customerInfo ?? this.customerInfo,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isNewAddressMode: isNewAddressMode ?? this.isNewAddressMode,
      deliveryMethods: deliveryMethods ?? this.deliveryMethods,
      selectedDeliveryMethod:
          selectedDeliveryMethod ?? this.selectedDeliveryMethod,
      paymentType: paymentType ?? this.paymentType,
      appliedReferral: clearAppliedReferral
          ? null
          : (appliedReferral ?? this.appliedReferral),
      referralQuery: referralQuery ?? this.referralQuery,
      referralSearchResults:
          referralSearchResults ?? this.referralSearchResults,
      isSearchingReferral: isSearchingReferral ?? this.isSearchingReferral,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingInit: isLoadingInit ?? this.isLoadingInit,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdOrderResult: createdOrderResult ?? this.createdOrderResult,
    );
  }
}
