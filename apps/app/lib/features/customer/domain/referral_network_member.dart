// Models for referral hierarchy members (upline & downline) per ABA ERP backend.

class ReferralNetworkUser {
  final int id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;

  const ReferralNetworkUser({
    required this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
  });

  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((p) => p != null && p.trim().isNotEmpty)
        .join(' ')
        .trim();
    if (parts.isNotEmpty) return parts;
    if (username != null && username!.trim().isNotEmpty) return username!;
    return 'User #$id';
  }

  factory ReferralNetworkUser.fromJson(Map<String, dynamic> json) {
    return ReferralNetworkUser(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name']?.toString(),
      middleName: json['middle_name']?.toString(),
      lastName: json['last_name']?.toString(),
      username: json['username']?.toString(),
    );
  }
}

class ReferralNetworkMember {
  final int id;
  final int? referrerUserId;
  final int? referredUserId;
  final int level;
  final int? userId;
  final String? username;
  final ReferralNetworkUser? user;

  const ReferralNetworkMember({
    required this.id,
    this.referrerUserId,
    this.referredUserId,
    required this.level,
    this.userId,
    this.username,
    this.user,
  });

  String get displayName => user?.fullName ?? (username ?? 'User #$id');

  String get initials {
    final name = displayName.trim();
    if (name.isEmpty) return 'U';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  factory ReferralNetworkMember.fromJson(Map<String, dynamic> json) {
    final rawUser =
        json['referredUser'] ?? json['referrerUser'] ?? json['user'];
    final userObj = rawUser is Map<String, dynamic>
        ? ReferralNetworkUser.fromJson(rawUser)
        : (rawUser is Map
            ? ReferralNetworkUser.fromJson(Map<String, dynamic>.from(rawUser))
            : null);

    return ReferralNetworkMember(
      id: json['id'] as int? ?? 0,
      referrerUserId: json['referrer_user_id'] as int?,
      referredUserId: json['referred_user_id'] as int?,
      level: json['level'] as int? ?? 1,
      userId: json['user_id'] as int?,
      username: json['username']?.toString() ?? userObj?.username,
      user: userObj,
    );
  }
}
