import 'rewards_entities.dart';

abstract class RewardsRepository {
  Future<RewardSummary> getRewardSummary(String userId);
  Future<List<RewardLedgerEntry>> getRewardLedger(String userId);
  Future<List<RewardRule>> getRewardRules();
}
