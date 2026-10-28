import 'package:dio/dio.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/api_endpoints.dart';
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
        query['startDate'] = queryParams!.startDateString;
      }
      if (queryParams?.endDate != null) {
        query['endDate'] = queryParams!.endDateString;
      }

      final response = await _dio.get(
        ApiEndpoints.merchants.base,
        queryParameters: query,
      );

      final list = ApiResponse.unwrapList(response.data);
      var merchants = list
          .whereType<Map>()
          .map((json) => Merchant.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      if (merchants.isNotEmpty) {
        if (params.category.trim().isNotEmpty) {
          merchants = merchants
              .where((m) =>
                  m.category.toLowerCase() ==
                  params.category.trim().toLowerCase())
              .toList();
        }
        if (params.state.trim().isNotEmpty) {
          merchants = merchants
              .where((m) =>
                  m.state.toLowerCase() == params.state.trim().toLowerCase())
              .toList();
        }
        if (params.minRating != null) {
          merchants =
              merchants.where((m) => m.rating >= params.minRating!).toList();
        }
        if (params.verifiedOnly) {
          merchants = merchants.where((m) => m.isVerified).toList();
        }

        int total = merchants.length;
        if (response.data is Map &&
            response.data['data'] is Map &&
            response.data['data']['meta'] is Map) {
          total = (response.data['data']['meta']['totalItems'] as num?)
                  ?.toInt() ??
              merchants.length;
        }

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
      }
    } on DioException catch (e) {
      AppLogger.w('MerchantRemoteRepository.getMerchants failed: ${e.message}');
    } catch (e) {
      AppLogger.e('MerchantRemoteRepository: error in getMerchants', error: e);
    }

    return MerchantMockRepository().getMerchants(params, queryParams);
  }

  @override
  Future<Merchant?> getMerchantById(String id) async {
    final isNumeric = int.tryParse(id) != null;
    if (isNumeric) {
      try {
        final response = await _dio.get(ApiEndpoints.merchants.byId(id));
        final map = ApiResponse.unwrapMap(response.data);
        if (map.isNotEmpty) {
          return Merchant.fromJson(map);
        }
      } catch (e) {
        AppLogger.w('MerchantRemoteRepository.getMerchantById($id) failed: $e');
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
      } catch (_) {}
    }
    return MerchantMockRepository().getMerchantById(id);
  }

  @override
  Future<List<Merchant>> getMerchantsSpotlight() async {
    try {
      final response = await _dio.get(ApiEndpoints.storefront.merchantsSpotlight);
      final list = ApiResponse.unwrapList(response.data);
      final merchants = list
          .whereType<Map>()
          .map((json) => Merchant.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      if (merchants.isNotEmpty) return merchants;
    } on DioException catch (e) {
      AppLogger.w('MerchantRemoteRepository.getMerchantsSpotlight failed: ${e.message}');
    } catch (e) {
      AppLogger.e('MerchantRemoteRepository.getMerchantsSpotlight error', error: e);
    }
    return MerchantMockRepository().getMerchantsSpotlight();
  }
}
