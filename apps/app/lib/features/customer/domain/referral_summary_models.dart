class ReferralMetrics {
  final int totalNetwork;
  final int activeBuyers;
  final int totalEarned; // in minor units (kobo)

  const ReferralMetrics({
    required this.totalNetwork,
    required this.activeBuyers,
    required this.totalEarned,
  });

  factory ReferralMetrics.fromJson(Map<String, dynamic> json) {
    return ReferralMetrics(
      totalNetwork: (json['totalNetwork'] as num?)?.toInt() ?? 0,
      activeBuyers: (json['activeBuyers'] as num?)?.toInt() ?? 0,
      totalEarned: (json['totalEarned'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReferralStat {
  final String referredUserId;
  final String referredUserName;
  final String? username;
  final int level;
  final DateTime joinedDate;
  final String status;
  final int earnings; // in minor units (kobo)

  const ReferralStat({
    this.referredUserId = '',
    required this.referredUserName,
    this.username,
    this.level = 1,
    required this.joinedDate,
    required this.status,
    required this.earnings,
  });

  factory ReferralStat.fromJson(Map<String, dynamic> json) {
    final rawDate = json['joinedDate']?.toString();
    final parsedDate = rawDate != null ? DateTime.tryParse(rawDate) : null;
    return ReferralStat(
      referredUserId: (json['referredUserId'] ?? json['id'])?.toString() ?? '',
      referredUserName: json['referredUserName']?.toString() ??
          json['name']?.toString() ??
          'Customer',
      username: json['username']?.toString(),
      level: (json['level'] as num?)?.toInt() ?? 1,
      joinedDate: parsedDate ?? DateTime.now(),
      status: json['status']?.toString() ?? 'Active',
      earnings: (json['earnings'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReferralData {
  final String? referralCode;
  final ReferralMetrics metrics;
  final List<ReferralStat> stats;

  const ReferralData({
    this.referralCode,
    required this.metrics,
    required this.stats,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json['metrics'];
    final rawStats = json['stats'];
    return ReferralData(
      referralCode: json['referralCode']?.toString(),
      metrics: rawMetrics is Map<String, dynamic>
          ? ReferralMetrics.fromJson(rawMetrics)
          : (rawMetrics is Map
              ? ReferralMetrics.fromJson(Map<String, dynamic>.from(rawMetrics))
              : const ReferralMetrics(
                  totalNetwork: 0,
                  activeBuyers: 0,
                  totalEarned: 0,
                )),
      stats: rawStats is List
          ? rawStats
              .whereType<Map>()
              .map((e) => ReferralStat.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

