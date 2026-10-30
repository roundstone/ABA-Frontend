/// Paystack Payment Gateway configuration for mobile app checkout.
abstract final class PaystackConfig {
  /// Public key used for initializing transactions & client-side UI
  static const String publicKey =
      'pk_test_a3c52ce327f5f3e830c62d7d2209ca361833dbb9';

  /// Secret key (test environment)
  static const String secretKey =
      'sk_test_5bc54e726c9ac247f8b16e85f39d20b20a528052';

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

