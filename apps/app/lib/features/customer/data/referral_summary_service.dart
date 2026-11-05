import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/referral_summary_models.dart';

class ReferralSummaryService {
  ReferralSummaryService({required this.dio});

  final Dio dio;

  static final ReferralData mockReferralSummary = ReferralData(
    referralCode: 'CUSTOMER-638-033F5078',
    metrics: const ReferralMetrics(
      totalNetwork: 1,
      activeBuyers: 1,
      totalEarned: 10000,
    ),
    stats: [
      ReferralStat(
        referredUserId: '946',
        referredUserName: 'CustomerB B',
        username: 'customerb.b',
        level: 1,
        joinedDate: DateTime.parse('2026-11-05T08:32:52.586Z'),
        status: 'Active',
        earnings: 10000,
      ),
    ],
  );

  Future<ReferralData> fetchSummary() async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return mockReferralSummary;
    }

    try {
      AppLogger.d('GET ${ApiEndpoints.referrals.summary}');
      final response = await dio.get(ApiEndpoints.referrals.summary);
      final body = response.data;
      final rawData = body is Map ? (body['data'] ?? body) : body;

      if (rawData is Map) {
        return ReferralData.fromJson(Map<String, dynamic>.from(rawData));
      }
      return mockReferralSummary;
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch referral summary', error: e);
      if (AppConfig.isMockMode) return mockReferralSummary;
      throw ApiError.fromDio(e);
    } catch (e) {
      AppLogger.e('Unexpected error fetching referral summary', error: e);
      if (AppConfig.isMockMode) return mockReferralSummary;
      rethrow;
    }
  }
}

