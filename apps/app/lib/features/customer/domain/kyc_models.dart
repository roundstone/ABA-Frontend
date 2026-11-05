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
  final List<KycDocument> documents;

  bool get isSubmitted => submittedAt != null || status >= 2;

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
      documents: docsList
          .whereType<Map>()
          .map((d) => KycDocument.fromJson(Map<String, dynamic>.from(d)))
          .toList(),
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
