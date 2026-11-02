import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  await Future.delayed(const Duration(milliseconds: 400));
  return MarketerProfileData(
    alias: 'Chima Obi',
    level: 4,
    joinedDate: DateTime(2023, 5, 10),
    performancePercentile: 5,
    networkSales: 45000000,
    personalSales: 1200000,
    totalTeamSize: 142,
    activeMembers: 85,
    networkData: NetworkNode(
      id: 'root',
      name: 'Chima Obi',
      code: 'CHIMA001',
      level: 4,
      sales: 45000000,
      personalSales: 1200000,
      active: true,
      performancePercentile: 5,
      joinedDate: DateTime(2023, 5, 10),
      children: [
        NetworkNode(
          id: 'child1',
          name: 'Aisha Bello',
          code: 'AISHA001',
          level: 3,
          sales: 12000000,
          personalSales: 500000,
          active: true,
          performancePercentile: 15,
          children: [
            NetworkNode(
              id: 'grandchild1',
              name: 'Samuel O.',
              code: 'SAM001',
              level: 2,
              sales: 3000000,
              personalSales: 100000,
              active: false,
              performancePercentile: 60,
            ),
          ],
        ),
        NetworkNode(
          id: 'child2',
          name: 'Ibrahim M.',
          code: 'IBR001',
          level: 2,
          sales: 5000000,
          personalSales: 200000,
          active: true,
          performancePercentile: 45,
        ),
      ],
    ),
    teamSizeByLevel: [
      LevelStat('Level 1', 20),
      LevelStat('Level 2', 45),
      LevelStat('Level 3', 77),
    ],
    salesByLevel: [
      LevelStat('Level 1', 12000000),
      LevelStat('Level 2', 15000000),
      LevelStat('Level 3', 18000000),
    ],
  );
});

