import 'kyc_payment_models.dart';
export 'kyc_payment_models.dart';

String kycDocumentTypeLabel(int type) {
  switch (type) {
    case 1:
      return 'National ID';
    case 2:
      return 'International passport';
    case 3:
      return "Driver's license";
    case 4:
      return 'Proof of address';
    case 5:
      return 'Business registration';
    default:
      return 'Document';
  }
}

class KycDocument {
  const KycDocument({
    required this.id,
    required this.kycProfileId,
    required this.documentType,
    required this.mediaId,
    this.documentReference,
    this.originalName,
    this.mimeType,
    this.url,
    this.createdAt,
  });

  final int id;
  final int kycProfileId;
  final int documentType;
  final int mediaId;
  final String? documentReference;
  final String? originalName;
  final String? mimeType;
  final String? url;
  final DateTime? createdAt;

  factory KycDocument.fromJson(Map<String, dynamic> json) {
    final media = json['media'] is Map
        ? Map<String, dynamic>.from(json['media'] as Map)
        : null;
    return KycDocument(
      id: (json['id'] as num?)?.toInt() ?? 0,
      kycProfileId:
          (json['kyc_profile_id'] ?? json['kycProfileId'] as num?)?.toInt() ??
              0,
      documentType:
          (json['document_type'] ?? json['documentType'] as num?)?.toInt() ?? 1,
      mediaId: (json['media_id'] ?? json['mediaId'] as num?)?.toInt() ?? 0,
      documentReference:
          (json['document_reference'] ?? json['documentReference'])?.toString(),
      originalName: media?['original_name']?.toString(),
      mimeType: media?['mime_type']?.toString(),
      url: media?['url']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class KycProfile {
  const KycProfile({
    required this.id,
    required this.userId,
    this.dateOfBirth,
    this.nationality,
    this.residentialAddress,
    this.city,
    this.state,
    this.lga,
    required this.status,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    this.activationPayment,
    this.documents = const [],
  });

  final int id;
  final int userId;
  final String? dateOfBirth;
  final String? nationality;
  final String? residentialAddress;
  final String? city;
  final String? state;
  final String? lga;
  final int status;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final KycActivationPayment? activationPayment;
  final List<KycDocument> documents;

  bool get isPending => status == 1;
  bool get isUnderReview => status == 2;
  bool get isApproved => status == 3;
  bool get isRejected => status == 4;
  bool get isEditable => status == 0 || status == 1 || status == 4;
  bool get isSubmitted => submittedAt != null || status >= 2;
  bool get isActivationPaid => activationPayment?.isSuccessful == true;

  String get statusLabel {
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'Under review';
      case 3:
        return 'Approved';
      case 4:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  factory KycProfile.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] : json;
    final map = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};
    final profileMap = map['profile'] is Map
        ? Map<String, dynamic>.from(map['profile'] as Map)
        : map;
    final docsList = (map['documents'] ?? profileMap['documents']) is List
        ? ((map['documents'] ?? profileMap['documents']) as List)
        : const [];
    final rawPayment =
        map['activationPayment'] ??
        map['activation_payment'] ??
        profileMap['activationPayment'] ??
        profileMap['activation_payment'];
    final payment = rawPayment is Map
        ? KycActivationPayment.fromJson(Map<String, dynamic>.from(rawPayment))
        : null;

    return KycProfile(
      id: (profileMap['id'] as num?)?.toInt() ?? 0,
      userId:
          (profileMap['user_id'] ?? profileMap['userId'] as num?)?.toInt() ?? 0,
      dateOfBirth:
          (profileMap['date_of_birth'] ?? profileMap['dateOfBirth'])
              ?.toString(),
      nationality: profileMap['nationality']?.toString(),
      residentialAddress: (profileMap['residential_address'] ??
              profileMap['residentialAddress'])
          ?.toString(),
      city: profileMap['city']?.toString(),
      state: profileMap['state']?.toString(),
      lga: profileMap['lga']?.toString(),
      status: (profileMap['status'] as num?)?.toInt() ?? 0,
      rejectionReason:
          (profileMap['rejection_reason'] ?? profileMap['rejectionReason'])
              ?.toString(),
      submittedAt:
          (profileMap['submitted_at'] ?? profileMap['submittedAt']) != null
              ? DateTime.tryParse(
                  (profileMap['submitted_at'] ?? profileMap['submittedAt'])
                      .toString(),
                )
              : null,
      reviewedAt:
          (profileMap['reviewed_at'] ?? profileMap['reviewedAt']) != null
              ? DateTime.tryParse(
                  (profileMap['reviewed_at'] ?? profileMap['reviewedAt'])
                      .toString(),
                )
              : null,
      activationPayment: payment,
      documents: docsList
          .whereType<Map>()
          .map((d) => KycDocument.fromJson(Map<String, dynamic>.from(d)))
          .toList(),
    );
  }
}
