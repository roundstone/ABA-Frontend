/// Paystack Payment Gateway configuration for mobile app checkout.
abstract final class PaystackConfig {
  /// Public key used for initializing transactions & client-side UI
  static const String publicKey =
      'pk_test_ad74b402d4c878d8686d2764f310204cd8dcb71e';

  /// Secret key (test environment)
  static const String secretKey =
      'sk_test_b38c266331e3062701cebd6c7de1e075545b268c';

  /// Standard currency for ABA Marketplace transactions
  static const String currency = 'NGN';

  /// Paystack Standard Transaction fee rate: 1.5% + NGN 100 (capped at 2000)
  static double calculateFee(double amount) {
    if (amount <= 0) return 0;
    final variable = amount * 0.015;
    final flat = amount >= 2500 ? 100.0 : 0.0;
    final total = variable + flat;
    return total > 2000 ? 2000 : total;
  }
}

