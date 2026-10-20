/// Verification statuses representing the business approval workflow on BuyNaija.
enum MerchantVerificationStatus {
  /// Initial submission under review by admin team (typically 24-48 hours).
  pendingReview('Under Review', 'Your verification documents are being processed.'),

  /// Successfully verified with valid CAC, identity, and address.
  verified('Verified Merchant', 'Your store is fully verified with verified business badge.'),

  /// Temporary onboarding without CAC registration (60-day provisional grace period).
  provisional('Provisional Seller', 'You have 60 days to submit your CAC registration.'),

  /// Rejected or requires correction of documents.
  rejected('Action Required', 'Some verification documents could not be validated.');

  const MerchantVerificationStatus(this.label, this.description);
  final String label;
  final String description;
}

/// Regulatory or industry certification held by a merchant (e.g. NAFDAC, SON).
class MerchantCertification {
  const MerchantCertification({
    required this.type,
    required this.number,
    this.documentName,
    this.isVerified = false,
  });

  final String type; // e.g. 'NAFDAC', 'SON', 'NEPC'
  final String number;
  final String? documentName;
  final bool isVerified;
}
