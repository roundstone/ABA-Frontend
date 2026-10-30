/// Domain models and request payloads for Product Reviews (`/api/v1/reviews`).
class ProductReview {
  const ProductReview({
    required this.id,
    required this.reviewableType,
    required this.reviewableId,
    required this.rating,
    required this.comment,
    this.customerId,
    this.userId,
    this.authorName = 'Verified Customer',
    this.authorUsername,
    this.authorEmail,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int? customerId;
  final int? userId;
  final double rating;
  final String reviewableType;
  final int reviewableId;
  final String comment;
  final String authorName;
  final String? authorUsername;
  final String? authorEmail;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static int _parseInt(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double _parseDouble(dynamic value, [double fallback = 0.0]) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] is Map
        ? Map<String, dynamic>.from(json['customer'] as Map)
        : null;
    final user = customer != null && customer['user'] is Map
        ? Map<String, dynamic>.from(customer['user'] as Map)
        : (json['user'] is Map ? Map<String, dynamic>.from(json['user'] as Map) : null);

    final firstName = (user?['first_name'] ?? user?['firstName'])?.toString().trim();
    final middleName = (user?['middle_name'] ?? user?['middleName'])?.toString().trim();
    final lastName = (user?['last_name'] ?? user?['lastName'])?.toString().trim();
    final username = user?['username']?.toString().trim();
    final email = user?['email']?.toString().trim();

    final nameParts = [firstName, middleName, lastName]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toList();

    final resolvedName = nameParts.isNotEmpty
        ? nameParts.join(' ')
        : (username != null && username.isNotEmpty
            ? username
            : (json['authorName']?.toString() ?? 'Verified Customer'));

    return ProductReview(
      id: _parseInt(json['id']),
      customerId: _parseIntNullable(json['customer_id'] ?? json['customerId'] ?? customer?['id']),
      userId: _parseIntNullable(customer?['user_id'] ?? customer?['userId'] ?? user?['id']),
      rating: _parseDouble(json['rating'], 5.0).clamp(0.0, 5.0),
      reviewableType: (json['reviewable_type'] ?? json['reviewableType'] ?? 'product').toString(),
      reviewableId: _parseInt(json['reviewable_id'] ?? json['reviewableId']),
      comment: (json['comment'] ?? json['body'] ?? '').toString(),
      authorName: resolvedName,
      authorUsername: username,
      authorEmail: email,
      createdAt: DateTime.tryParse((json['createdAt'] ?? json['created_at'] ?? '').toString()),
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? json['updated_at'] ?? '').toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'rating': rating,
        'reviewable_type': reviewableType,
        'reviewable_id': reviewableId,
        'comment': comment,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  ProductReview copyWith({
    int? id,
    int? customerId,
    int? userId,
    double? rating,
    String? reviewableType,
    int? reviewableId,
    String? comment,
    String? authorName,
    String? authorUsername,
    String? authorEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ProductReview(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        userId: userId ?? this.userId,
        rating: rating ?? this.rating,
        reviewableType: reviewableType ?? this.reviewableType,
        reviewableId: reviewableId ?? this.reviewableId,
        comment: comment ?? this.comment,
        authorName: authorName ?? this.authorName,
        authorUsername: authorUsername ?? this.authorUsername,
        authorEmail: authorEmail ?? this.authorEmail,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

/// Request payload for `POST /api/v1/reviews`.
class CreateReviewInput {
  const CreateReviewInput({
    this.reviewableType = 'product',
    required this.reviewableId,
    required this.rating,
    required this.comment,
  });

  final String reviewableType;
  final int reviewableId;
  final double rating;
  final String comment;

  Map<String, dynamic> toJson() => {
        'reviewableType': reviewableType,
        'reviewableId': reviewableId,
        'rating': rating,
        'comment': comment.trim(),
      };
}

/// Request payload for `PATCH /api/v1/reviews/{id}`.
class UpdateReviewInput {
  const UpdateReviewInput({
    this.rating,
    this.comment,
    this.reviewableType,
    this.reviewableId,
  });

  final double? rating;
  final String? comment;
  final String? reviewableType;
  final int? reviewableId;

  Map<String, dynamic> toJson() => {
        if (reviewableType != null) 'reviewableType': reviewableType,
        if (reviewableId != null) 'reviewableId': reviewableId,
        if (rating != null) 'rating': rating,
        if (comment != null) 'comment': comment!.trim(),
      };
}

