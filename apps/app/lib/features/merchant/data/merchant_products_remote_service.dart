import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/network/api_response.dart';
import '../domain/merchant_product_entities.dart';
import 'merchant_mock_repository.dart';

/// Remote service handling product CRUD and inventory adjustments for [MerchantRemoteRepository].
class MerchantProductsRemoteService {
  MerchantProductsRemoteService(this.dio, this._mock);

  final Dio dio;
  final MerchantMockRepository _mock;

  Future<List<MerchantProduct>> getProducts(
    String merchantId, {
    String? query,
    String? category,
    int? categoryId,
    int? subcategoryId,
    String? stockFilter,
  }) async {
    try {
      final numericId =
          int.tryParse(merchantId.replaceAll(RegExp(r'[^0-9]'), ''));
      final qParams = <String, dynamic>{
        'limit': 100,
        'page': 1,
        'orderBy': 'createdAt:DESC',
        'isActive': true,
        'includeVariants': true,
        if (query != null && query.isNotEmpty) 'search': query,
        if (categoryId != null) 'categoryId': categoryId,
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
      };

      Response<dynamic>? response;
      try {
        response =
            await dio.get(ApiEndpoints.products.base, queryParameters: qParams);
      } catch (_) {
        try {
          response = await dio.get('/api/v1/merchants/$merchantId/products',
              queryParameters: {
                if (query != null && query.isNotEmpty) 'q': query,
                if (category != null && category != 'All') 'category': category,
                if (stockFilter != null && stockFilter != 'All')
                  'stock': stockFilter,
              });
        } catch (_) {}
      }

      final rawData = response?.data;
      var list = rawData != null ? ApiResponse.unwrapList(rawData) : <dynamic>[];

      if (list.isNotEmpty) {
        var products = list.whereType<Map>().map((item) {
          return MerchantProduct.fromJson(Map<String, dynamic>.from(item));
        }).toList();

        if (numericId != null) {
          final merchantMatches =
              products.where((p) => p.vendorId == numericId).toList();
          if (merchantMatches.isNotEmpty) {
            products = merchantMatches;
          }
        }

        if (category != null && category != 'All') {
          products = products
              .where((p) => p.category.toLowerCase() == category.toLowerCase())
              .toList();
        }
        if (categoryId != null) {
          products = products.where((p) => p.categoryId == categoryId).toList();
        }
        if (subcategoryId != null) {
          products =
              products.where((p) => p.subcategoryId == subcategoryId).toList();
        }
        if (stockFilter != null && stockFilter != 'All') {
          if (stockFilter == 'In Stock') {
            products = products.where((p) => p.isInStock).toList();
          }
          if (stockFilter == 'Low Stock') {
            products = products.where((p) => p.isLowStock).toList();
          }
          if (stockFilter == 'Out of Stock') {
            products = products.where((p) => p.isOutOfStock).toList();
          }
        }
        return products;
      }
      return const [];
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('MerchantRemoteRepository.getProducts fallback: $e');
        return _mock.getProducts(
          merchantId,
          query: query,
          category: category,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          stockFilter: stockFilter,
        );
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return _mock.getProducts(
          merchantId,
          query: query,
          category: category,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          stockFilter: stockFilter,
        );
      }
      rethrow;
    }
  }

  Future<MerchantProduct> addProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    try {
      final payload = product.toCreatePayload();
      Response<dynamic>? res;
      try {
        res = await dio.post(ApiEndpoints.products.base, data: payload);
      } catch (_) {
        res = await dio.post(
          '/api/v1/merchants/$merchantId/products',
          data: payload,
        );
      }

      final map = ApiResponse.unwrapMap(res.data);
      return map.isNotEmpty ? MerchantProduct.fromJson(map) : product;
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.addProduct(merchantId, product);
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.addProduct(merchantId, product);
      rethrow;
    }
  }

  Future<MerchantProduct> updateProduct(
    String merchantId,
    MerchantProduct product,
  ) async {
    try {
      final payload = product.toCreatePayload();
      Response<dynamic>? res;
      try {
        res = await dio.patch(
          ApiEndpoints.products.byId(product.id),
          data: payload,
        );
      } catch (_) {
        res = await dio.put(
          ApiEndpoints.products.byId(product.id),
          data: payload,
        );
      }

      final map = ApiResponse.unwrapMap(res.data);
      return map.isNotEmpty ? MerchantProduct.fromJson(map) : product;
    } on DioException catch (e) {
      if (AppConfig.isMockMode) return _mock.updateProduct(merchantId, product);
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) return _mock.updateProduct(merchantId, product);
      rethrow;
    }
  }

  Future<void> deleteProduct(String merchantId, String productId) async {
    try {
      try {
        await dio.delete(ApiEndpoints.products.byId(productId));
      } catch (_) {
        await dio.delete('/api/v1/merchants/$merchantId/products/$productId');
      }
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        await _mock.deleteProduct(merchantId, productId);
        return;
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        await _mock.deleteProduct(merchantId, productId);
        return;
      }
      rethrow;
    }
  }

  Future<void> adjustStock(
    String merchantId,
    String productId,
    int adjustment,
    String reason,
  ) =>
      _mock.adjustStock(merchantId, productId, adjustment, reason);
}

