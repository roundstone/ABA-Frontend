import '../domain/rewards_entities.dart';
import '../domain/rewards_repository.dart';

class RewardsMockRepository implements RewardsRepository {
  final List<RewardRule> _rules = [
    const RewardRule(
      id: 'rule-1',
      key: 'review_published',
      triggeringEvent: 'review.published',
      points: 50,
      needsVerifiedPurchase: true,
      active: true,
    ),
    const RewardRule(
      id: 'rule-2',
      key: 'first_purchase',
      triggeringEvent: 'order.completed',
      points: 200,
      lifetimeCap: 200,
      needsVerifiedPurchase: true,
      active: false,
    ),
    const RewardRule(
      id: 'rule-3',
      key: 'profile_completed',
      triggeringEvent: 'profile.completed',
      points: 100,
      lifetimeCap: 100,
      needsVerifiedPurchase: false,
      active: false,
    ),
    const RewardRule(
      id: 'rule-4',
      key: 'referral_qualified',
      triggeringEvent: 'referral.qualified',
      points: 500,
      needsVerifiedPurchase: false,
      active: false,
    ),
  ];

  final List<RewardLedgerEntry> _ledger = [
    RewardLedgerEntry(
      id: 'led-1',
      userId: 'user-1',
      type: RewardEntryType.earn,
      points: 50,
      sourceEvent: 'review.published',
      reference: 'REV-1001',
      balanceAfter: 50,
      status: RewardEntryStatus.available,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    RewardLedgerEntry(
      id: 'led-2',
      userId: 'user-1',
      type: RewardEntryType.earn,
      points: 50,
      sourceEvent: 'review.published',
      reference: 'REV-1002',
      balanceAfter: 100,
      status: RewardEntryStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RewardLedgerEntry(
      id: 'led-3',
      userId: 'user-1',
      type: RewardEntryType.adjust,
      points: 100,
      sourceEvent: 'manual.adjustment',
      reference: 'Apology for delay',
      balanceAfter: 200,
      status: RewardEntryStatus.available,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    RewardLedgerEntry(
      id: 'led-4',
      userId: 'user-1',
      type: RewardEntryType.reverse,
      points: -50,
      sourceEvent: 'review.removed',
      reference: 'REV-1001',
      balanceAfter: 150,
      status: RewardEntryStatus.available,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    RewardLedgerEntry(
      id: 'led-5',
      userId: 'user-2',
      type: RewardEntryType.earn,
      points: 500,
      sourceEvent: 'referral.qualified',
      reference: 'REF-2001',
      balanceAfter: 500,
      status: RewardEntryStatus.available,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<List<RewardRule>> getRewardRules() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_rules);
  }

  @override
  Future<List<RewardLedgerEntry>> getRewardLedger(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final entries = _ledger
        .where((e) => userId.isEmpty || e.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  @override
  Future<RewardSummary> getRewardSummary(String userId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final userEntries = _ledger.where((e) => e.userId == userId).toList();

    final available = userEntries
        .where((e) => e.status == RewardEntryStatus.available)
        .fold<int>(0, (sum, e) => sum + e.points);

    final pending = userEntries
        .where((e) => e.status == RewardEntryStatus.pending)
        .fold<int>(0, (sum, e) => sum + e.points);

    final lifetime = userEntries
        .where((e) => e.type == RewardEntryType.earn)
        .fold<int>(0, (sum, e) => sum + e.points);

    return RewardSummary(
      available: available,
      pending: pending,
      lifetime: lifetime,
    );
  }
}
