import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/network/api_response.dart';
import '../../shop/domain/shop_entities.dart';
import 'merchant_mock_repository.dart';

/// Remote service handling category, subcategory and brand fetching for [MerchantRemoteRepository].
class MerchantCatalogRemoteService {
  MerchantCatalogRemoteService(this.dio, this._mock);

  final Dio dio;
  final MerchantMockRepository _mock;

  Future<List<ShopCategory>> getCategories() async {
    try {
      final res = await dio.get(
        ApiEndpoints.productCategories.base,
        queryParameters: const {'page': 1, 'limit': 50, 'isActive': true},
      );
      final list = ApiResponse.unwrapList(res.data);
      return list
          .whereType<Map>()
          .map((i) => ShopCategory.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.getCategories();
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.getCategories();
      rethrow;
    }
  }

  Future<List<ShopCategory>> getSubcategories({int? categoryId}) async {
    try {
      final res = await dio.get(
        ApiEndpoints.productSubcategories.base,
        queryParameters: {
          'page': 1,
          'limit': 100,
          'isActive': true,
          if (categoryId != null) 'categoryId': categoryId,
        },
      );
      final list = ApiResponse.unwrapList(res.data);
      final subcats = list
          .whereType<Map>()
          .map((i) => ShopCategory.fromJson(Map<String, dynamic>.from(i)))
          .toList();
      if (categoryId != null) {
        return subcats.where((s) => s.parentId == '$categoryId').toList();
      }
      return subcats;
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        return _mock.getSubcategories(categoryId: categoryId);
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return _mock.getSubcategories(categoryId: categoryId);
      }
      rethrow;
    }
  }

  Future<List<Brand>> getBrands() async {
    try {
      Response<dynamic>? res;
      try {
        res = await dio.get(ApiEndpoints.brands.base);
      } catch (_) {
        res = await dio.get(ApiEndpoints.storefront.popularBrands);
      }
      final list = ApiResponse.unwrapList(res.data);
      return list
          .whereType<Map>()
          .map((i) => Brand.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.getBrands();
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.getBrands();
      rethrow;
    }
  }
}

