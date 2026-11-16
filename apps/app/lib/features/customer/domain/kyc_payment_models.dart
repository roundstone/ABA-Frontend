class KycActivationPayment {
  const KycActivationPayment({
    required this.id,
    this.paymentType,
    this.reference,
    this.gatewayTransactionId,
    required this.amount,
    this.currency = 'NGN',
    required this.status,
    this.paymentMethod,
    this.paidAt,
    this.failureReason,
    this.createdAt,
  });

  final int id;
  final String? paymentType;
  final String? reference;
  final String? gatewayTransactionId;
  final String amount;
  final String currency;
  final String status;
  final String? paymentMethod;
  final DateTime? paidAt;
  final String? failureReason;
  final DateTime? createdAt;

  bool get isSuccessful {
    final s = status.toLowerCase();
    return s == 'successful' || s == 'success' || s == 'paid' || paidAt != null;
  }

  bool get isPending => status.toLowerCase() == 'pending';

  factory KycActivationPayment.fromJson(Map<String, dynamic> json) {
    return KycActivationPayment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      paymentType: (json['payment_type'] ?? json['paymentType'])?.toString(),
      reference: json['reference']?.toString(),
      gatewayTransactionId:
          (json['gateway_transaction_id'] ?? json['gatewayTransactionId'])
              ?.toString(),
      amount: json['amount']?.toString() ?? '5000.00',
      currency: json['currency']?.toString() ?? 'NGN',
      status: json['status']?.toString() ?? 'pending',
      paymentMethod:
          (json['payment_method'] ?? json['paymentMethod'])?.toString(),
      paidAt: (json['paid_at'] ?? json['paidAt']) != null
          ? DateTime.tryParse((json['paid_at'] ?? json['paidAt']).toString())
          : null,
      failureReason:
          (json['failure_reason'] ?? json['failureReason'])?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class KycPaymentInitResult {
  const KycPaymentInitResult({
    required this.reference,
    required this.email,
    required this.amountInKobo,
    required this.publicKey,
    this.authorizationUrl,
    this.paymentId,
    this.status,
  });

  final String reference;
  final String email;
  final int amountInKobo;
  final String publicKey;
  final String? authorizationUrl;
  final int? paymentId;
  final String? status;

  double get amountNaira => amountInKobo / 100.0;

  factory KycPaymentInitResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    final payment = data['payment'] is Map
        ? Map<String, dynamic>.from(data['payment'] as Map)
        : null;
    final rawAmount = data['amount'];
    int kobo = 500000;
    if (rawAmount is int) {
      kobo = rawAmount;
    } else if (rawAmount is num) {
      kobo = rawAmount.toInt();
    } else if (rawAmount != null) {
      kobo = int.tryParse(rawAmount.toString()) ?? 500000;
    }

    return KycPaymentInitResult(
      reference:
          (data['reference'] ?? payment?['reference'])?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      amountInKobo: kobo,
      publicKey: data['publicKey']?.toString() ?? '',
      authorizationUrl: (data['authorizationUrl'] ?? data['authorization_url'])
          ?.toString(),
      paymentId: (payment?['id'] as num?)?.toInt(),
      status: payment?['status']?.toString(),
    );
  }
}
