import '../../shop/domain/shop_entities.dart';
import 'checkout_entities.dart';

abstract class CheckoutRepository {
  Future<List<CheckoutAddress>> getSavedAddresses();

  Future<List<DeliveryMethod>> getDeliveryMethods();

  Future<List<ReferralCandidate>> searchReferrals(String query);

  Future<CheckoutOrderResult> placeOrder({
    required Cart cart,
    required CheckoutCustomerInfo customerInfo,
    required CheckoutAddress address,
    required DeliveryMethod deliveryMethod,
    required CheckoutPaymentType paymentType,
    ReferralCandidate? referral,
  });
}
