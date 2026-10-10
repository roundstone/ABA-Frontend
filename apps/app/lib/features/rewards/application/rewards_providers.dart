import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/rewards_mock_repository.dart';
import '../domain/rewards_entities.dart';
import '../domain/rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  return RewardsMockRepository();
});

final rewardsUserIdProvider = StateProvider<String>((ref) {
  return 'user-1';
});

final rewardSummaryProvider =
    FutureProvider.autoDispose<RewardSummary>((ref) async {
  final repo = ref.watch(rewardsRepositoryProvider);
  final userId = ref.watch(rewardsUserIdProvider);
  return repo.getRewardSummary(userId);
});

final rewardRulesProvider =
    FutureProvider.autoDispose<List<RewardRule>>((ref) async {
  final repo = ref.watch(rewardsRepositoryProvider);
  return repo.getRewardRules();
});

final rewardLedgerProvider =
    FutureProvider.autoDispose<List<RewardLedgerEntry>>((ref) async {
  final repo = ref.watch(rewardsRepositoryProvider);
  final userId = ref.watch(rewardsUserIdProvider);
  return repo.getRewardLedger(userId);
});

final rewardLedgerFilterProvider = StateProvider<String>((ref) {
  return 'all';
});

final filteredRewardLedgerProvider =
    Provider.autoDispose<AsyncValue<List<RewardLedgerEntry>>>((ref) {
  final ledgerAsync = ref.watch(rewardLedgerProvider);
  final filter = ref.watch(rewardLedgerFilterProvider);

  return ledgerAsync.whenData((entries) {
    if (filter == 'all') return entries;
    return entries.where((e) => e.type.value == filter).toList();
  });
});
