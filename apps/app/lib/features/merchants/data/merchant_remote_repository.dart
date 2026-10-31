import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/list_query_params.dart';
import '../domain/merchant_entities.dart';
import '../domain/merchant_repository.dart';
import 'merchant_mock_repository.dart';

class MerchantRemoteRepository implements MerchantRepository {
  MerchantRemoteRepository(this._dio);
  final Dio _dio;

  @override
  Future<MerchantDirectoryResult> getMerchants([
    MerchantFilterParams params = const MerchantFilterParams(),
    ListQueryParams? queryParams,
  ]) async {
    try {
      final query = <String, dynamic>{
        'page': queryParams?.page ?? 1,
        'limit': queryParams?.limit ?? 20,
        'orderBy': queryParams?.orderBy ?? 'createdAt:DESC',
      };

      final effectiveSearch = queryParams?.search ?? params.query;
      if (effectiveSearch.trim().isNotEmpty) {
        query['search'] = effectiveSearch.trim();
      }
      if (queryParams?.startDate != null) {
        query['startDate'] = queryParams!.startDate!.toIso8601String();
      }
      if (queryParams?.endDate != null) {
        query['endDate'] = queryParams!.endDate!.toIso8601String();
      }

      if (params.state.isNotEmpty && params.state != 'All') {
        query['state'] = params.state;
      }
      if (params.category.isNotEmpty && params.category != 'All') {
        query['category'] = params.category;
      }
      if (params.verifiedOnly) {
        query['isVerified'] = true;
      }
      if (params.minRating != null && params.minRating! > 0) {
        query['rating'] = params.minRating;
      }

      final response = await _dio.get(
        ApiEndpoints.merchants.base,
        queryParameters: query,
      );

      final rawData = response.data;
      var list = ApiResponse.unwrapList(rawData);
      int total = list.length;

      if (rawData is Map<String, dynamic> && rawData.containsKey('meta')) {
        final meta = rawData['meta'] as Map<String, dynamic>?;
        if (meta != null && meta['total'] is num) {
          total = (meta['total'] as num).toInt();
        }
      }

      final merchants = list
          .whereType<Map>()
          .map((json) => Merchant.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      final states = merchants
          .map((m) => m.state)
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
      final categories = merchants
          .map((m) => m.category)
          .where((c) => c.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      return MerchantDirectoryResult(
        merchants: merchants,
        totalCount: total,
        availableStates: states.isNotEmpty
            ? states
            : const ['Lagos', 'Abia', 'Abuja', 'Kano', 'Rivers'],
        availableCategories: categories.isNotEmpty
            ? categories
            : const ['Clothing', 'Bags', 'Shoes', 'Electronics'],
      );
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('MerchantRemoteRepository.getMerchants fallback: ${e.message}');
        return MerchantMockRepository().getMerchants(params, queryParams);
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return MerchantMockRepository().getMerchants(params, queryParams);
      }
      rethrow;
    }
  }

  @override
  Future<Merchant?> getMerchantById(String id) async {
    final isNumeric = int.tryParse(id) != null;
    if (isNumeric) {
      try {
        final response = await _dio.get(ApiEndpoints.merchants.byId(id));
        final map = ApiResponse.unwrapMap(response.data);
        return map.isNotEmpty ? Merchant.fromJson(map) : null;
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) return null;
        if (AppConfig.isMockMode) {
          return MerchantMockRepository().getMerchantById(id);
        }
        throw ApiError.fromDio(e);
      } catch (e) {
        if (AppConfig.isMockMode) {
          return MerchantMockRepository().getMerchantById(id);
        }
        rethrow;
      }
    } else {
      try {
        final list = await getMerchants(
          const MerchantFilterParams(),
          ListQueryParams(search: id, limit: 5),
        );
        final match = list.merchants
            .where((m) =>
                m.id == id || m.name.toLowerCase() == id.toLowerCase())
            .firstOrNull;
        if (match != null &&
            match.id.isNotEmpty &&
            int.tryParse(match.id) != null) {
          return getMerchantById(match.id);
        }
        return match;
      } catch (e) {
        if (AppConfig.isMockMode) {
          return MerchantMockRepository().getMerchantById(id);
        }
        rethrow;
      }
    }
  }

  @override
  Future<List<Merchant>> getMerchantsSpotlight() async {
    try {
      final response =
          await _dio.get(ApiEndpoints.storefront.merchantsSpotlight);
      final list = ApiResponse.unwrapList(response.data);
      return list
          .whereType<Map>()
          .map((json) => Merchant.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w(
          'MerchantRemoteRepository.getMerchantsSpotlight fallback: ${e.message}',
        );
        return MerchantMockRepository().getMerchantsSpotlight();
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return MerchantMockRepository().getMerchantsSpotlight();
      }
      rethrow;
    }
  }
}
