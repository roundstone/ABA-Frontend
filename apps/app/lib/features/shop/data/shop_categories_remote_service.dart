import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shop_entities.dart';
import 'shop_mock_repository.dart';
import 'shop_remote_helpers.dart';

/// Remote service handling category and subcategory retrieval for [ShopRemoteRepository].
class ShopCategoriesRemoteService {
  ShopCategoriesRemoteService(this._dio);

  final Dio _dio;

  Future<List<ShopCategory>> fetchCategories({ListQueryParams? params}) async {
    try {
      final q = params ??
          const ListQueryParams(
            page: 1,
            limit: 50,
            orderBy: 'createdAt:DESC',
            isActive: true,
            includeCounts: true,
          );
      final res = await _dio.get(
        ApiEndpoints.productCategories.base,
        queryParameters: q.toMap(),
      );
      return ShopRemoteHelpers.parseCategories(res.data);
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('ShopCategoriesRemoteService: fetchCategories fallback: $e');
        return ShopMockRepository.defaultCategories;
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return ShopMockRepository.defaultCategories;
      rethrow;
    }
  }

  Future<List<ShopCategory>> fetchSubcategories({
    ListQueryParams? params,
  }) async {
    try {
      final q = params ??
          const ListQueryParams(
            page: 1,
            limit: 50,
            orderBy: 'createdAt:DESC',
            isActive: true,
            includeCounts: true,
          );
      final res = await _dio.get(
        ApiEndpoints.productSubcategories.base,
        queryParameters: q.toMap(),
      );
      return ShopRemoteHelpers.parseCategories(res.data);
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('ShopCategoriesRemoteService: fetchSubcategories fallback: $e');
        return ShopMockRepository().fetchSubcategories(params: params);
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchSubcategories(params: params);
      }
      rethrow;
    }
  }

  Future<ShopCategory?> fetchSubcategoryById(String id) async {
    if (int.tryParse(id) != null) {
      try {
        final res = await _dio.get(
          ApiEndpoints.productSubcategories.byId(id),
          queryParameters: const {'includeCounts': true},
        );
        final map = ApiResponse.unwrapMap(res.data);
        return map.isNotEmpty ? ShopCategory.fromJson(map) : null;
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) return null;
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchSubcategoryById(id);
        }
        throw ApiError.fromDio(e);
      } catch (e) {
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchSubcategoryById(id);
        }
        rethrow;
      }
    } else {
      try {
        final list = await fetchSubcategories(
          params: ListQueryParams(search: id, limit: 5),
        );
        final match = list.where((s) => s.slug == id || s.id == id).firstOrNull;
        if (match != null && match.id.isNotEmpty && int.tryParse(match.id) != null) {
          return fetchSubcategoryById(match.id);
        }
        return match;
      } catch (e) {
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchSubcategoryById(id);
        }
        rethrow;
      }
    }
  }
}
