import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';
import '../application/referrals_network_providers.dart';
import 'widgets/network_tree.dart';

class LevelStat {
  final String name;
  final int value;
  LevelStat(this.name, this.value);
}

class MarketerProfileData {
  final String alias;
  final int level;
  final DateTime? joinedDate;
  final int? performancePercentile;
  final int networkSales;
  final int personalSales;
  final int totalTeamSize;
  final int activeMembers;
  final NetworkNode networkData;
  final List<LevelStat> teamSizeByLevel;
  final List<LevelStat> salesByLevel;

  MarketerProfileData({
    required this.alias,
    required this.level,
    this.joinedDate,
    this.performancePercentile,
    required this.networkSales,
    required this.personalSales,
    required this.totalTeamSize,
    required this.activeMembers,
    required this.networkData,
    required this.teamSizeByLevel,
    required this.salesByLevel,
  });
}

final marketerProfileProvider =
    FutureProvider.autoDispose<MarketerProfileData>((ref) async {
  final user = ref.watch(currentUserProvider);
  final displayName = user?.name.trim().isNotEmpty == true
      ? user!.name.trim()
      : (user?.referralCode?.trim().isNotEmpty == true
          ? user!.referralCode!.trim()
          : 'You');
  final userCode = user?.referralCode ?? 'YOU';
  final joined = user?.createdAt ?? DateTime.now();

  // Load actual downline members for real team size
  List<ReferralNetworkMember> downline = const [];
  try {
    downline = await ref.watch(referralDownlineProvider(1).future);
  } catch (_) {}

  final teamSize = downline.length;

  return MarketerProfileData(
    alias: displayName,
    level: 1,
    joinedDate: joined,
    performancePercentile: null,
    networkSales: 0,
    personalSales: 0,
    totalTeamSize: teamSize,
    activeMembers: teamSize,
    networkData: NetworkNode(
      id: 'root',
      name: displayName,
      code: userCode,
      level: 0,
      sales: 0,
      personalSales: 0,
      active: true,
      children: const [],
    ),
    teamSizeByLevel: [
      LevelStat('Level 1', teamSize),
      LevelStat('Level 2', 0),
      LevelStat('Level 3', 0),
    ],
    salesByLevel: [
      LevelStat('Level 1', 0),
      LevelStat('Level 2', 0),
      LevelStat('Level 3', 0),
    ],
  );
});

