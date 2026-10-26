import 'package:dio/dio.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shop_entities.dart';
import '../domain/shop_repository.dart';
import 'shop_mock_repository.dart';

/// Real API implementation of [ShopRepository].
/// Talks directly to ABA ERP backend endpoints:
/// - Product Categories: [ApiEndpoints.productCategories.base]
/// - Products: [ApiEndpoints.products.base]
class ShopRemoteRepository implements ShopRepository {
  ShopRemoteRepository({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  final Dio _dio;

  static String _mapSortOrder(SortOrder sort) {
    switch (sort) {
      case SortOrder.priceLow:
        return 'base_selling_price:ASC';
      case SortOrder.priceHigh:
        return 'base_selling_price:DESC';
      case SortOrder.nameAsc:
        return 'name:ASC';
      case SortOrder.nameDesc:
        return 'name:DESC';
      case SortOrder.newest:
      case SortOrder.featured:
        return 'createdAt:DESC';
    }
  }

  @override
  Future<List<ShopCategory>> fetchCategories({ListQueryParams? params}) async {
    try {
      final query = params ??
          const ListQueryParams(
            page: 1,
            limit: 10,
            orderBy: 'createdAt:DESC',
            isActive: true,
          );

      final res = await _dio.get(
        ApiEndpoints.productCategories.base,
        queryParameters: query.toMap(),
      );

      final list = ApiResponse.unwrapList(res.data);
      final categories = list
          .whereType<Map>()
          .map((item) => ShopCategory.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      if (categories.isNotEmpty) {
        return categories;
      }
      return ShopMockRepository.defaultCategories;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        AppLogger.i('ShopRemoteRepository: Categories endpoint requires authentication (401). Serving local categories.');
      } else {
        AppLogger.w('ShopRemoteRepository: fetchCategories failed (${e.message}), falling back to local');
      }
      return ShopMockRepository.defaultCategories;
    } catch (e) {
      AppLogger.e('ShopRemoteRepository: unexpected error in fetchCategories', error: e);
      return ShopMockRepository.defaultCategories;
    }
  }

  @override
  Future<ShopCatalogue> fetchCatalogue() async {
    try {
      final categories = await fetchCategories();
      final products = await fetchProducts();
      return ShopCatalogue(
        products: products,
        categories: categories,
        featuredBannerUrl: '',
      );
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchCatalogue fallback: $e');
      final fallbackRepo = ShopMockRepository();
      return fallbackRepo.fetchCatalogue();
    }
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    try {
      final res = await _dio.get(
        ApiEndpoints.products.byId(id),
        queryParameters: const {'includeVariants': true},
      );
      final map = ApiResponse.unwrapMap(res.data);
      if (map.isNotEmpty) {
        return Product.fromJson(map);
      }
    } on DioException catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchProductById($id) failed: ${e.message}');
    } catch (e) {
      AppLogger.e('ShopRemoteRepository: error in fetchProductById($id)', error: e);
    }
    final fallbackRepo = ShopMockRepository();
    return fallbackRepo.fetchProductById(id);
  }

  @override
  Future<List<Product>> fetchProducts({
    ShopFilter? filter,
    SortOrder sort = SortOrder.featured,
    int page = 1,
    int pageSize = 20,
    String? search,
    int? categoryId,
    int? brandId,
    int? vendorId,
    double? minPrice,
    double? maxPrice,
    double? rating,
    ListQueryParams? queryParams,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': queryParams?.page ?? page,
        'limit': queryParams?.limit ?? pageSize,
        'orderBy': queryParams?.orderBy ?? _mapSortOrder(sort),
        'isActive': queryParams?.isActive ?? true,
        'includeVariants': queryParams?.includeVariants ?? true,
      };

      final effectiveSearch = queryParams?.search ?? search;
      if (effectiveSearch != null && effectiveSearch.trim().isNotEmpty) {
        query['search'] = effectiveSearch.trim();
      }

      final effectiveCategoryId = queryParams?.categoryId ??
          categoryId ??
          (filter?.categories.isNotEmpty == true
              ? int.tryParse(filter!.categories.first)
              : null);
      if (effectiveCategoryId != null) {
        query['categoryId'] = effectiveCategoryId;
      }

      final effectiveBrandId = brandId ??
          (filter?.brands.isNotEmpty == true
              ? int.tryParse(filter!.brands.first.replaceAll(RegExp(r'[^0-9]'), ''))
              : null);
      if (effectiveBrandId != null) {
        query['brandId'] = effectiveBrandId;
      }

      final effectiveVendorId = vendorId ??
          (filter?.merchants.isNotEmpty == true
              ? int.tryParse(filter!.merchants.first.replaceAll(RegExp(r'[^0-9]'), ''))
              : null);
      if (effectiveVendorId != null) {
        query['vendorId'] = effectiveVendorId;
      }

      final effectiveMinPrice = minPrice ??
          (filter != null && filter.priceRange.$1 > 0 ? filter.priceRange.$1 : null);
      if (effectiveMinPrice != null) {
        query['minPrice'] = effectiveMinPrice;
      }

      final effectiveMaxPrice = maxPrice ??
          (filter != null && filter.priceRange.$2 < 500000 ? filter.priceRange.$2 : null);
      if (effectiveMaxPrice != null) {
        query['maxPrice'] = effectiveMaxPrice;
      }

      final effectiveRating = rating ??
          (filter != null && filter.ratings.isNotEmpty
              ? filter.ratings.reduce((a, b) => a < b ? a : b).toDouble()
              : null);
      if (effectiveRating != null) {
        query['rating'] = effectiveRating;
      }

      if (queryParams?.customParams.isNotEmpty == true) {
        query.addAll(queryParams!.customParams);
      }

      final res = await _dio.get(
        ApiEndpoints.products.base,
        queryParameters: query,
      );
      final list = ApiResponse.unwrapList(res.data);
      if (list.isNotEmpty) {
        return list
            .whereType<Map>()
            .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        AppLogger.i('ShopRemoteRepository: Products endpoint requires authentication (401). Serving local catalogue.');
      } else {
        AppLogger.w('ShopRemoteRepository: fetchProducts failed (${e.message}), falling back to local');
      }
    } catch (e) {
      AppLogger.e('ShopRemoteRepository: error in fetchProducts', error: e);
    }

    final fallbackRepo = ShopMockRepository();
    return fallbackRepo.fetchProducts(
      filter: filter,
      sort: sort,
      page: page,
      pageSize: pageSize,
      search: search,
      categoryId: categoryId,
      brandId: brandId,
      vendorId: vendorId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      rating: rating,
      queryParams: queryParams,
    );
  }
}
