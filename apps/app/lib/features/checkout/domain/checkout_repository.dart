import '../../shop/domain/shop_entities.dart';
import 'checkout_entities.dart';

abstract class CheckoutRepository {
  Future<List<CheckoutAddress>> getSavedAddresses();

  Future<List<DeliveryMethod>> getDeliveryMethods();

  Future<List<ReferralCandidate>> searchReferrals(String query);

  /// Verifies Paystack transaction via GET /api/v1/payments/mobile-app/paystack/{reference}/verify
  Future<bool> verifyPaystackPayment(String reference);

  /// Creates mobile order via POST /api/v1/orders/mobile-app
  Future<CheckoutOrderResult> placeOrder({
    required Cart cart,
    required CheckoutCustomerInfo customerInfo,
    required CheckoutAddress address,
    required DeliveryMethod deliveryMethod,
    required CheckoutPaymentType paymentType,
    ReferralCandidate? referral,
    String? paymentReference,
  });
}
