import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/commission_models.dart';

class CommissionService {
  CommissionService({required this.dio});

  final Dio dio;

  static final List<CommissionRecord> mockCommissionRecords = [
    CommissionRecord(
      id: 42,
      userId: 18,
      commissionRuleId: 7,
      sourceType: 'order',
      sourceId: 1254,
      commissionLevel: 1,
      calculationBase: 10000.00,
      appliedRate: 10.0,
      amount: 1000.00,
      currency: 'NGN',
      status: 2,
      eligibleAt: DateTime.parse('2026-11-07T08:30:00.000Z'),
      commissionRule: const CommissionRuleInfo(
        id: 7,
        title: 'Merchant Referral Plan',
        merchantId: 3,
      ),
      sourceOrderNumber: 'ORD-1793953140000-AB12CD34',
      sourceCustomerName: 'Chinedu Okafor',
      createdAt: DateTime.parse('2026-11-05T08:30:00.000Z'),
      updatedAt: DateTime.parse('2026-11-05T08:30:00.000Z'),
    ),
    CommissionRecord(
      id: 41,
      userId: 18,
      commissionRuleId: 7,
      sourceType: 'order',
      sourceId: 1254,
      commissionLevel: 2,
      calculationBase: 10000.00,
      appliedRate: 5.0,
      amount: 500.00,
      currency: 'NGN',
      status: 3,
      eligibleAt: DateTime.parse('2026-11-04T08:30:00.000Z'),
      releasedAt: DateTime.parse('2026-11-05T07:10:00.000Z'),
      commissionRule: const CommissionRuleInfo(
        id: 7,
        title: 'Merchant Referral Plan',
        merchantId: 3,
      ),
      sourceOrderNumber: 'ORD-1793953140000-AB12CD34',
      sourceCustomerName: 'Chinedu Okafor',
      createdAt: DateTime.parse('2026-11-03T08:30:00.000Z'),
      updatedAt: DateTime.parse('2026-11-05T07:10:00.000Z'),
    ),
  ];

  static const CommissionOverview mockOverview = CommissionOverview(
    generatedPeriod: 1500.0,
    pendingApproval: 1000.0,
    approvedUnpaid: 1000.0,
    paidPeriod: 500.0,
    reversedPeriod: 0.0,
    outstandingLiability: 1000.0,
  );

  Future<CommissionOverview> getOverview() async {
    if (AppConfig.isMockMode) return mockOverview;

    try {
      AppLogger.d('GET ${ApiEndpoints.commissions.overview}');
      final response = await dio.get(ApiEndpoints.commissions.overview);
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          return CommissionOverview.fromJson(data);
        }
      }
      return mockOverview;
    } catch (e) {
      AppLogger.e('Failed to fetch commission overview', error: e);
      if (AppConfig.isMockMode) return mockOverview;
      if (e is DioException) throw ApiError.fromDio(e);
      rethrow;
    }
  }

  Future<PaginatedCommissions> getCommissions({
    int page = 1,
    int limit = 10,
    int? status,
  }) async {
    if (AppConfig.isMockMode) {
      var list = List<CommissionRecord>.from(mockCommissionRecords);
      if (status != null) {
        list = list.where((item) => item.status == status).toList();
      }
      return PaginatedCommissions(
        items: list,
        totalItems: list.length,
        totalPages: 1,
        currentPage: page,
        hasNext: false,
      );
    }

    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      };

      AppLogger.d('GET ${ApiEndpoints.commissions.base} with $queryParams');
      final response = await dio.get(
        ApiEndpoints.commissions.base,
        queryParameters: queryParams,
      );

      final body = response.data;
      List rawList = [];
      Map<String, dynamic>? meta;

      if (body is Map) {
        final data = body['data'];
        if (data is Map) {
          if (data['data'] is List) rawList = data['data'] as List;
          if (data['meta'] is Map) meta = data['meta'] as Map<String, dynamic>;
        } else if (data is List) {
          rawList = data;
        }
      }

      final items = rawList
          .whereType<Map<String, dynamic>>()
          .map((json) => CommissionRecord.fromJson(json))
          .toList();

      final totalItems = meta?['totalItems'] as int? ?? items.length;
      final totalPages = meta?['totalPages'] as int? ??
          (totalItems / limit).ceil().clamp(1, 999);
      final currentPage = meta?['currentPage'] as int? ?? page;

      return PaginatedCommissions(
        items: items,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: currentPage,
        hasNext: currentPage < totalPages,
      );
    } catch (e) {
      AppLogger.e('Failed to fetch commissions list', error: e);
      if (AppConfig.isMockMode) {
        return PaginatedCommissions(
          items: mockCommissionRecords,
          totalItems: mockCommissionRecords.length,
          totalPages: 1,
          currentPage: page,
          hasNext: false,
        );
      }
      if (e is DioException) throw ApiError.fromDio(e);
      rethrow;
    }
  }
}

