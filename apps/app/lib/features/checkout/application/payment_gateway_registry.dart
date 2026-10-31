import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/paystack_gateway_service.dart';
import '../domain/payment_gateway.dart';

/// Registry holding all configured [PaymentGatewayService] instances.
/// Allows adding new gateways (Flutterwave, Monnify, etc.) without altering UI.
class PaymentGatewayRegistry {
  PaymentGatewayRegistry(Map<PaymentGatewayType, PaymentGatewayService> gateways)
      : _gateways = Map.unmodifiable(gateways);

  final Map<PaymentGatewayType, PaymentGatewayService> _gateways;

  PaymentGatewayService getGateway(PaymentGatewayType type) {
    final gateway = _gateways[type];
    if (gateway == null) {
      throw UnsupportedError('No payment gateway registered for $type');
    }
    return gateway;
  }

  bool isSupported(PaymentGatewayType type) => _gateways.containsKey(type);
}

final paymentGatewayRegistryProvider = Provider<PaymentGatewayRegistry>((ref) {
  final dio = ref.watch(dioProvider);
  final paystackService = PaystackGatewayService(dio);

  return PaymentGatewayRegistry({
    PaymentGatewayType.paystack: paystackService,
  });
});

final paymentGatewayServiceProvider =
    Provider.family<PaymentGatewayService, PaymentGatewayType>((ref, type) {
  final registry = ref.watch(paymentGatewayRegistryProvider);
  return registry.getGateway(type);
});
