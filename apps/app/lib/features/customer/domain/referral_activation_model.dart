enum ReferralActivationStatus {
  /// User has no referral code or has not completed activation.
  inactive,

  /// KYC documents submitted, waiting for verification or fee payment.
  pending,

  /// Referral code is generated and actively earns commissions.
  active,
}

class ReferralActivationState {
  const ReferralActivationState({
    this.id,
    this.referralCode,
    this.isActive = false,
    this.isLoading = false,
    this.isGenerating = false,
    this.errorMessage,
    this.status = ReferralActivationStatus.inactive,
    this.feeAmountNaira = 5000,
    this.isKycCompleted = false,
    this.isFeePaid = false,
    this.ninNumber,
    this.idType,
    this.idDocumentName,
    this.proofOfAddressName,
    this.activatedAt,
  });

  final int? id;
  final String? referralCode;
  final bool isActive;
  final bool isLoading;
  final bool isGenerating;
  final String? errorMessage;

  final ReferralActivationStatus status;
  final int feeAmountNaira;
  final bool isKycCompleted;
  final bool isFeePaid;
  final String? ninNumber;
  final String? idType;
  final String? idDocumentName;
  final String? proofOfAddressName;
  final DateTime? activatedAt;

  bool get hasCode => referralCode != null && referralCode!.trim().isNotEmpty;

  ReferralActivationState copyWith({
    int? id,
    String? referralCode,
    bool clearReferralCode = false,
    bool? isActive,
    bool? isLoading,
    bool? isGenerating,
    String? errorMessage,
    bool clearError = false,
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
      id: id ?? this.id,
      referralCode: clearReferralCode ? null : (referralCode ?? this.referralCode),
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
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
