import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/referral_network_member.dart';

abstract class ReferralsNetworkRepository {
  Future<List<ReferralNetworkMember>> getUpline({int depth = 1});
  Future<List<ReferralNetworkMember>> getDownline({int depth = 1});
}

class ReferralsNetworkRemoteRepository implements ReferralsNetworkRepository {
  ReferralsNetworkRemoteRepository({required this.dio});

  final Dio dio;

  @override
  Future<List<ReferralNetworkMember>> getUpline({int depth = 1}) async {
    final clampedDepth = depth.clamp(1, 3);
    if (AppConfig.isMockMode) {
      return _mockUpline(clampedDepth);
    }

    try {
      AppLogger.d('GET ${ApiEndpoints.referrals.upline} with depth=$clampedDepth');
      final res = await dio.get(
        ApiEndpoints.referrals.upline,
        queryParameters: {'depth': clampedDepth},
      );
      return _parseMemberList(res.data);
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch upline network', error: e);
      if (AppConfig.isMockMode) return _mockUpline(clampedDepth);
      throw ApiError.fromDio(e);
    } catch (e) {
      AppLogger.e('Unexpected error fetching upline network', error: e);
      if (AppConfig.isMockMode) return _mockUpline(clampedDepth);
      rethrow;
    }
  }

  @override
  Future<List<ReferralNetworkMember>> getDownline({int depth = 1}) async {
    final clampedDepth = depth.clamp(1, 3);
    if (AppConfig.isMockMode) {
      return _mockDownline(clampedDepth);
    }

    try {
      AppLogger.d('GET ${ApiEndpoints.referrals.downline} with depth=$clampedDepth');
      final res = await dio.get(
        ApiEndpoints.referrals.downline,
        queryParameters: {'depth': clampedDepth},
      );
      return _parseMemberList(res.data);
    } on DioException catch (e) {
      AppLogger.e('Failed to fetch downline network', error: e);
      if (AppConfig.isMockMode) return _mockDownline(clampedDepth);
      throw ApiError.fromDio(e);
    } catch (e) {
      AppLogger.e('Unexpected error fetching downline network', error: e);
      if (AppConfig.isMockMode) return _mockDownline(clampedDepth);
      rethrow;
    }
  }

  List<ReferralNetworkMember> _parseMemberList(dynamic data) {
    final rawData = data is Map ? (data['data'] ?? data) : data;
    if (rawData is List) {
      return rawData
          .whereType<Map>()
          .map((item) => ReferralNetworkMember.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return const [];
  }

  Future<List<ReferralNetworkMember>> _mockUpline(int depth) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = [
      const ReferralNetworkMember(
        id: 11,
        referrerUserId: 5,
        referredUserId: 10,
        level: 1,
        userId: 8,
        username: 'nwosu.marketer',
        user: ReferralNetworkUser(
          id: 8,
          firstName: 'Emeka',
          lastName: 'Nwosu',
          username: 'nwosu.marketer',
        ),
      ),
      const ReferralNetworkMember(
        id: 10,
        referrerUserId: 2,
        referredUserId: 8,
        level: 2,
        userId: 5,
        username: 'chioma.lead',
        user: ReferralNetworkUser(
          id: 5,
          firstName: 'Chioma',
          lastName: 'Okoye',
          username: 'chioma.lead',
        ),
      ),
      const ReferralNetworkMember(
        id: 9,
        referrerUserId: 1,
        referredUserId: 5,
        level: 3,
        userId: 2,
        username: 'aba.master',
        user: ReferralNetworkUser(
          id: 2,
          firstName: 'Ifeanyi',
          lastName: 'Eze',
          username: 'aba.master',
        ),
      ),
    ];
    return list.where((m) => m.level <= depth).toList();
  }

  Future<List<ReferralNetworkMember>> _mockDownline(int depth) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = [
      const ReferralNetworkMember(
        id: 12,
        referrerUserId: 10,
        referredUserId: 21,
        level: 1,
        userId: 21,
        username: 'john.doe',
        user: ReferralNetworkUser(
          id: 21,
          firstName: 'John',
          lastName: 'Doe',
          username: 'john.doe',
        ),
      ),
      const ReferralNetworkMember(
        id: 13,
        referrerUserId: 10,
        referredUserId: 22,
        level: 1,
        userId: 22,
        username: 'ngozi.crafts',
        user: ReferralNetworkUser(
          id: 22,
          firstName: 'Ngozi',
          lastName: 'Kalu',
          username: 'ngozi.crafts',
        ),
      ),
      const ReferralNetworkMember(
        id: 14,
        referrerUserId: 21,
        referredUserId: 31,
        level: 2,
        userId: 31,
        username: 'samuel.leather',
        user: ReferralNetworkUser(
          id: 31,
          firstName: 'Samuel',
          lastName: 'Okafor',
          username: 'samuel.leather',
        ),
      ),
      const ReferralNetworkMember(
        id: 15,
        referrerUserId: 31,
        referredUserId: 41,
        level: 3,
        userId: 41,
        username: 'blessing.textiles',
        user: ReferralNetworkUser(
          id: 41,
          firstName: 'Blessing',
          lastName: 'Amadi',
          username: 'blessing.textiles',
        ),
      ),
    ];
    return list.where((m) => m.level <= depth).toList();
  }
}

