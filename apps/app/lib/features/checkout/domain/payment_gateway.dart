/// Supported payment gateway types across the app.
enum PaymentGatewayType {
  paystack,
  flutterwave,
  monnify,
  bankTransfer,
  cashOnDelivery;

  static PaymentGatewayType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'paystack':
        return PaymentGatewayType.paystack;
      case 'flutterwave':
        return PaymentGatewayType.flutterwave;
      case 'monnify':
        return PaymentGatewayType.monnify;
      case 'bank_transfer':
      case 'banktransfer':
        return PaymentGatewayType.bankTransfer;
      case 'cash_on_delivery':
      case 'cod':
      default:
        return PaymentGatewayType.cashOnDelivery;
    }
  }
}

/// Standardized initialization response returned by any payment gateway backend.
class GatewayPaymentInitResult {
  const GatewayPaymentInitResult({
    required this.authorizationUrl,
    required this.reference,
    this.orderId,
    this.amount,
    this.currency = 'NGN',
    this.paymentId,
    this.status = 'pending',
    this.rawResponse,
  });

  final String authorizationUrl;
  final String reference;
  final dynamic orderId;
  final double? amount;
  final String currency;
  final dynamic paymentId;
  final String status;
  final Map<String, dynamic>? rawResponse;

  factory GatewayPaymentInitResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    final payment = data['payment'] is Map
        ? data['payment'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawAmount = payment['amount'] ?? data['amount'];
    final parsedAmount = rawAmount is num
        ? rawAmount.toDouble()
        : double.tryParse(rawAmount?.toString() ?? '');

    return GatewayPaymentInitResult(
      authorizationUrl: (data['authorizationUrl'] ??
              data['authorization_url'] ??
              payment['authorizationUrl'] ??
              '')
          .toString(),
      reference: (data['reference'] ??
              payment['reference'] ??
              data['trxref'] ??
              '')
          .toString(),
      orderId: payment['order_id'] ?? data['order_id'] ?? data['orderId'],
      amount: parsedAmount,
      currency: (payment['currency'] ?? data['currency'] ?? 'NGN').toString(),
      paymentId: payment['id'] ?? data['payment_id'] ?? data['paymentId'],
      status: (payment['status'] ?? data['status'] ?? 'pending').toString(),
      rawResponse: json,
    );
  }
}

/// Decoupled interface for any payment provider.
/// Implement this interface for new gateways (e.g. Flutterwave, Monnify, Stripe).
abstract class PaymentGatewayService {
  PaymentGatewayType get type;

  /// Initializes payment on the backend for an existing order.
  Future<GatewayPaymentInitResult> initializePayment({
    required dynamic orderId,
    required double amount,
    required String email,
    Map<String, dynamic>? extra,
  });

  /// Verifies transaction completion with the backend.
  Future<bool> verifyPayment(String reference);
}

