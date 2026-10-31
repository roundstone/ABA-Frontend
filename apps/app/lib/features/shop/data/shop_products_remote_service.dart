import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shop_entities.dart';
import 'shop_mock_repository.dart';
import 'shop_remote_helpers.dart';

/// Remote service handling single product, featured, trending and brand queries.
class ShopProductsRemoteService {
  ShopProductsRemoteService(this._dio);

  final Dio _dio;

  Future<Product?> fetchProductById(
    String id, {
    required Future<List<Product>> Function({String? search, int pageSize})
        searchProducts,
  }) async {
    if (int.tryParse(id) != null) {
      try {
        final res = await _dio.get(
          ApiEndpoints.products.byId(id),
          queryParameters: const {'includeVariants': true},
        );
        final map = ApiResponse.unwrapMap(res.data);
        return map.isNotEmpty ? Product.fromJson(map) : null;
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) return null;
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchProductById(id);
        }
        throw ApiError.fromDio(e);
      } catch (e) {
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchProductById(id);
        }
        rethrow;
      }
    } else {
      try {
        final matching = await searchProducts(search: id, pageSize: 5);
        final match = matching
                .where((p) => p.slug == id || p.id == id)
                .firstOrNull ??
            (matching.isNotEmpty ? matching.first : null);
        if (match != null && match.id.isNotEmpty && int.tryParse(match.id) != null) {
          return fetchProductById(match.id, searchProducts: searchProducts);
        }
        return match;
      } catch (e) {
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchProductById(id);
        }
        rethrow;
      }
    }
  }

  Future<ProductVariant?> fetchProductVariantById(String id) async {
    if (int.tryParse(id) != null) {
      try {
        final res = await _dio.get(ApiEndpoints.productVariants.byId(id));
        final map = ApiResponse.unwrapMap(res.data);
        return map.isNotEmpty ? ProductVariant.fromJson(map) : null;
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) return null;
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchProductVariantById(id);
        }
        throw ApiError.fromDio(e);
      } catch (e) {
        if (AppConfig.isMockMode) {
          return ShopMockRepository().fetchProductVariantById(id);
        }
        rethrow;
      }
    }
    return null;
  }

  Future<List<Product>> fetchFeaturedProducts() async {
    try {
      final res = await _dio.get(ApiEndpoints.storefront.featuredProducts);
      return ShopRemoteHelpers.parseProducts(res.data);
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchFeaturedProducts();
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchFeaturedProducts();
      }
      rethrow;
    }
  }

  Future<List<Product>> fetchTrendingProducts() async {
    try {
      final res = await _dio.get(ApiEndpoints.storefront.trendingProducts);
      return ShopRemoteHelpers.parseProducts(res.data);
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchTrendingProducts();
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchTrendingProducts();
      }
      rethrow;
    }
  }

  Future<List<Brand>> fetchPopularBrands() async {
    try {
      final res = await _dio.get(ApiEndpoints.storefront.popularBrands);
      final list = ApiResponse.unwrapList(res.data);
      return list
          .whereType<Map>()
          .map((i) => Brand.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchPopularBrands();
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchPopularBrands();
      }
      rethrow;
    }
  }
}
