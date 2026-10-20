enum ReferralActivationStatus {
  /// User has a referral code, but has not completed payment & KYC to earn.
  inactive,

  /// KYC documents submitted, waiting for verification or fee payment.
  pending,

  /// Fee paid and KYC verified. Referral code actively earns commissions.
  active,
}

class ReferralActivationState {
  const ReferralActivationState({
    required this.referralCode,
    required this.status,
    required this.feeAmountNaira,
    required this.isKycCompleted,
    required this.isFeePaid,
    this.ninNumber,
    this.idType,
    this.idDocumentName,
    this.proofOfAddressName,
    this.activatedAt,
  });

  final String referralCode;
  final ReferralActivationStatus status;
  final int feeAmountNaira;
  final bool isKycCompleted;
  final bool isFeePaid;
  final String? ninNumber;
  final String? idType;
  final String? idDocumentName;
  final String? proofOfAddressName;
  final DateTime? activatedAt;

  bool get isActive => status == ReferralActivationStatus.active;

  ReferralActivationState copyWith({
    String? referralCode,
    ReferralActivationStatus? status,
    int? feeAmountNaira,
    bool? isKycCompleted,
    bool? isFeePaid,
    String? ninNumber,
    String? idType,
    String? idDocumentName,
    String? proofOfAddressName,
    DateTime? activatedAt,
  }) {
    return ReferralActivationState(
      referralCode: referralCode ?? this.referralCode,
      status: status ?? this.status,
      feeAmountNaira: feeAmountNaira ?? this.feeAmountNaira,
      isKycCompleted: isKycCompleted ?? this.isKycCompleted,
      isFeePaid: isFeePaid ?? this.isFeePaid,
      ninNumber: ninNumber ?? this.ninNumber,
      idType: idType ?? this.idType,
      idDocumentName: idDocumentName ?? this.idDocumentName,
      proofOfAddressName: proofOfAddressName ?? this.proofOfAddressName,
      activatedAt: activatedAt ?? this.activatedAt,
    );
  }
}
