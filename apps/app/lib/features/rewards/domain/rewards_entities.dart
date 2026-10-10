class RewardRule {
  const RewardRule({
    required this.id,
    required this.key,
    required this.triggeringEvent,
    required this.points,
    this.dailyCap,
    this.lifetimeCap,
    this.needsVerifiedPurchase = false,
    this.active = true,
  });

  final String id;
  final String key;
  final String triggeringEvent;
  final int points;
  final int? dailyCap;
  final int? lifetimeCap;
  final bool needsVerifiedPurchase;
  final bool active;

  String get formattedTitle {
    final words = key.split('_');
    return words
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  factory RewardRule.fromJson(Map<String, dynamic> json) {
    return RewardRule(
      id: json['id'] as String,
      key: json['key'] as String,
      triggeringEvent: json['triggeringEvent'] as String? ?? '',
      points: (json['points'] as num).toInt(),
      dailyCap: (json['dailyCap'] as num?)?.toInt(),
      lifetimeCap: (json['lifetimeCap'] as num?)?.toInt(),
      needsVerifiedPurchase: json['needsVerifiedPurchase'] as bool? ?? false,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'triggeringEvent': triggeringEvent,
    'points': points,
    if (dailyCap != null) 'dailyCap': dailyCap,
    if (lifetimeCap != null) 'lifetimeCap': lifetimeCap,
    'needsVerifiedPurchase': needsVerifiedPurchase,
    'active': active,
  };
}

enum RewardEntryType {
  earn('earn', 'Earned'),
  redeem('redeem', 'Redeemed'),
  adjust('adjust', 'Adjustment'),
  expire('expire', 'Expired'),
  reverse('reverse', 'Reversal');

  const RewardEntryType(this.value, this.label);
  final String value;
  final String label;

  factory RewardEntryType.fromString(String val) {
    return RewardEntryType.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => RewardEntryType.earn,
    );
  }
}

enum RewardEntryStatus {
  available('available', 'Available'),
  pending('pending', 'Pending');

  const RewardEntryStatus(this.value, this.label);
  final String value;
  final String label;

  factory RewardEntryStatus.fromString(String val) {
    return RewardEntryStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => RewardEntryStatus.available,
    );
  }
}

class RewardLedgerEntry {
  const RewardLedgerEntry({
    required this.id,
    required this.userId,
    required this.type,
    required this.points,
    this.sourceEvent,
    this.reference,
    required this.balanceAfter,
    required this.status,
    this.optionalExpiry,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final RewardEntryType type;
  final int points;
  final String? sourceEvent;
  final String? reference;
  final int balanceAfter;
  final RewardEntryStatus status;
  final DateTime? optionalExpiry;
  final DateTime createdAt;

  factory RewardLedgerEntry.fromJson(Map<String, dynamic> json) {
    return RewardLedgerEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: RewardEntryType.fromString(json['type'] as String? ?? 'earn'),
      points: (json['points'] as num).toInt(),
      sourceEvent: json['sourceEvent'] as String?,
      reference: json['reference'] as String?,
      balanceAfter: (json['balanceAfter'] as num).toInt(),
      status: RewardEntryStatus.fromString(json['status'] as String? ?? 'available'),
      optionalExpiry: json['optionalExpiry'] != null
          ? DateTime.tryParse(json['optionalExpiry'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type.value,
    'points': points,
    if (sourceEvent != null) 'sourceEvent': sourceEvent,
    if (reference != null) 'reference': reference,
    'balanceAfter': balanceAfter,
    'status': status.value,
    if (optionalExpiry != null) 'optionalExpiry': optionalExpiry!.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };
}

class RewardSummary {
  const RewardSummary({
    required this.available,
    required this.pending,
    required this.lifetime,
  });

  final int available;
  final int pending;
  final int lifetime;

  factory RewardSummary.fromJson(Map<String, dynamic> json) {
    return RewardSummary(
      available: (json['available'] as num? ?? 0).toInt(),
      pending: (json['pending'] as num? ?? 0).toInt(),
      lifetime: (json['lifetime'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'available': available,
    'pending': pending,
    'lifetime': lifetime,
  };
}
