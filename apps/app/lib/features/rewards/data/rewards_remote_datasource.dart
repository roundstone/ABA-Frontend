import 'package:dio/dio.dart';
import '../domain/rewards_entities.dart';
import '../domain/rewards_repository.dart';

class RewardsRemoteDataSource implements RewardsRepository {
  const RewardsRemoteDataSource(this._dio);
  final Dio _dio;

  @override
  Future<RewardSummary> getRewardSummary(String userId) async {
    try {
      final response = await _dio.get(
        '/api/rewards/summary',
        queryParameters: {'userId': userId},
      );
      final data = response.data as Map<String, dynamic>;
      return RewardSummary.fromJson(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<RewardLedgerEntry>> getRewardLedger(String userId) async {
    try {
      final response = await _dio.get(
        '/api/rewards/ledger',
        queryParameters: {'userId': userId},
      );
      final list = (response.data['data'] as List<dynamic>?) ?? [];
      return list
          .map((json) => RewardLedgerEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<RewardRule>> getRewardRules() async {
    try {
      final response = await _dio.get('/api/rewards/rules');
      final list = (response.data as List<dynamic>?) ?? [];
      return list
          .map((json) => RewardRule.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      rethrow;
    }
  }
}
