import '../../domain/referral_network_member.dart';
import 'network_tree_node.dart';

class NetworkTreeBuilder {
  static NetworkNode buildTree({
    required String rootName,
    required List<ReferralNetworkMember> members,
    required bool isDownline,
  }) {
    if (members.isEmpty) {
      return NetworkNode(
        id: 'root',
        name: rootName,
        code: 'YOU',
        level: 0,
        sales: 0,
        personalSales: 0,
        active: true,
        children: const [],
      );
    }

    if (!isDownline) {
      final sorted = List<ReferralNetworkMember>.from(members)
        ..sort((a, b) => a.level.compareTo(b.level));
      NetworkNode? current;
      for (final m in sorted.reversed) {
        current = NetworkNode(
          id: m.id.toString(),
          name: m.displayName,
          alias: m.username,
          code: m.username ?? 'MENTOR-${m.id}',
          level: m.level,
          sales: 0,
          personalSales: 0,
          active: true,
          children: current != null ? [current] : const [],
        );
      }
      return NetworkNode(
        id: 'root',
        name: rootName,
        code: 'YOU',
        level: 0,
        sales: 0,
        personalSales: 0,
        active: true,
        children: current != null ? [current] : const [],
      );
    }

    final level1 = members.where((m) => m.level == 1).toList();
    final level2 = members.where((m) => m.level == 2).toList();
    final level3 = members.where((m) => m.level == 3).toList();

    final l2Assigned = <int>{};
    final l1Nodes = level1.map((l1) {
      final l1UserId = l1.userId ?? l1.referredUserId;
      final myL2 = level2.where((l2) {
        if (l2.referrerUserId != null &&
            l1UserId != null &&
            l2.referrerUserId == l1UserId) {
          l2Assigned.add(l2.id);
          return true;
        }
        return false;
      }).toList();

      final l2Nodes = myL2.map((l2) {
        final l2UserId = l2.userId ?? l2.referredUserId;
        final myL3 = level3.where((l3) {
          return l3.referrerUserId != null &&
              l2UserId != null &&
              l3.referrerUserId == l2UserId;
        }).toList();

        return _createNode(
          l2,
          myL3.map((l3) => _createNode(l3, const [])).toList(),
        );
      }).toList();

      return _createNode(l1, l2Nodes);
    }).toList();

    final unassignedL2 = level2
        .where((l2) => !l2Assigned.contains(l2.id))
        .map((l2) => _createNode(l2, const []))
        .toList();

    return NetworkNode(
      id: 'root',
      name: rootName,
      code: 'YOU',
      level: 0,
      sales: 0,
      personalSales: 0,
      active: true,
      children: [...l1Nodes, ...unassignedL2],
    );
  }

  static NetworkNode _createNode(
    ReferralNetworkMember m,
    List<NetworkNode> children,
  ) {
    return NetworkNode(
      id: m.id.toString(),
      name: m.displayName,
      alias: m.username,
      code: m.username ?? 'USER-${m.id}',
      level: m.level,
      sales: 0,
      personalSales: 0,
      active: true,
      children: children,
    );
  }
}

