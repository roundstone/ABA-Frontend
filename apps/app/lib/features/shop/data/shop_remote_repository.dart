import 'package:dio/dio.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shop_entities.dart';
import '../domain/shop_repository.dart';
import 'shop_mock_repository.dart';

/// Real API implementation of [ShopRepository].
class ShopRemoteRepository implements ShopRepository {
  ShopRemoteRepository({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  final Dio _dio;

  static String _mapSortOrder(SortOrder sort) => switch (sort) {
        SortOrder.priceLow => 'base_selling_price:ASC',
        SortOrder.priceHigh => 'base_selling_price:DESC',
        SortOrder.nameAsc => 'name:ASC',
        SortOrder.nameDesc => 'name:DESC',
        SortOrder.newest || SortOrder.featured => 'createdAt:DESC',
      };

  static List<Product> _parseProducts(dynamic data) => ApiResponse.unwrapList(data)
      .whereType<Map>()
      .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
      .toList();

  static List<ShopCategory> _parseCategories(dynamic data) => ApiResponse.unwrapList(data)
      .whereType<Map>()
      .map((item) => ShopCategory.fromJson(Map<String, dynamic>.from(item)))
      .toList();

  @override
  Future<List<ShopCategory>> fetchCategories({ListQueryParams? params}) async {
    try {
      final q = params ?? const ListQueryParams(page: 1, limit: 50, orderBy: 'createdAt:DESC', isActive: true, includeCounts: true);
      final res = await _dio.get(ApiEndpoints.productCategories.base, queryParameters: q.toMap());
      final categories = _parseCategories(res.data);
      if (categories.isNotEmpty) return categories;
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchCategories fallback: $e');
    }
    return ShopMockRepository.defaultCategories;
  }

  @override
  Future<List<ShopCategory>> fetchSubcategories({ListQueryParams? params}) async {
    try {
      final q = params ?? const ListQueryParams(page: 1, limit: 50, orderBy: 'createdAt:DESC', isActive: true, includeCounts: true);
      final res = await _dio.get(ApiEndpoints.productSubcategories.base, queryParameters: q.toMap());
      final subcategories = _parseCategories(res.data);
      if (subcategories.isNotEmpty) return subcategories;
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchSubcategories failed, fallback to local');
    }
    return ShopMockRepository().fetchSubcategories(params: params);
  }

  @override
  Future<ShopCategory?> fetchSubcategoryById(String id) async {
    if (int.tryParse(id) != null) {
      try {
        final res = await _dio.get(ApiEndpoints.productSubcategories.byId(id), queryParameters: const {'includeCounts': true});
        final map = ApiResponse.unwrapMap(res.data);
        if (map.isNotEmpty) return ShopCategory.fromJson(map);
      } catch (e) {
        AppLogger.w('ShopRemoteRepository: fetchSubcategoryById($id) failed: $e');
      }
    } else {
      try {
        final list = await fetchSubcategories(params: ListQueryParams(search: id, limit: 5));
        final match = list.where((s) => s.slug == id || s.id == id).firstOrNull;
        if (match != null && match.id.isNotEmpty && int.tryParse(match.id) != null) {
          return fetchSubcategoryById(match.id);
        }
      } catch (_) {}
    }
    return ShopMockRepository().fetchSubcategoryById(id);
  }

  @override
  Future<ShopCatalogue> fetchCatalogue() async {
    try {
      return ShopCatalogue(products: await fetchProducts(), categories: await fetchCategories(), featuredBannerUrl: '');
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchCatalogue fallback: $e');
      return ShopMockRepository().fetchCatalogue();
    }
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    if (int.tryParse(id) != null) {
      try {
        final res = await _dio.get(ApiEndpoints.products.byId(id), queryParameters: const {'includeVariants': true});
        final map = ApiResponse.unwrapMap(res.data);
        if (map.isNotEmpty) return Product.fromJson(map);
      } catch (e) {
        AppLogger.w('ShopRemoteRepository: fetchProductById($id) failed: $e');
      }
    } else {
      try {
        final matching = await fetchProducts(search: id, pageSize: 5);
        final match = matching.where((p) => p.slug == id || p.id == id).firstOrNull ?? (matching.isNotEmpty ? matching.first : null);
        if (match != null && match.id.isNotEmpty && int.tryParse(match.id) != null) {
          return fetchProductById(match.id);
        }
      } catch (_) {}
    }
    return ShopMockRepository().fetchProductById(id);
  }

  @override
  Future<ProductVariant?> fetchProductVariantById(String id) async {
    if (int.tryParse(id) != null) {
      try {
        final res = await _dio.get(ApiEndpoints.productVariants.byId(id));
        final map = ApiResponse.unwrapMap(res.data);
        if (map.isNotEmpty) return ProductVariant.fromJson(map);
      } catch (e) {
        AppLogger.w('ShopRemoteRepository: fetchProductVariantById($id) failed: $e');
      }
    }
    return ShopMockRepository().fetchProductVariantById(id);
  }

  @override
  Future<List<Product>> fetchFeaturedProducts() async {
    try {
      final res = await _dio.get(ApiEndpoints.storefront.featuredProducts);
      final products = _parseProducts(res.data);
      if (products.isNotEmpty) return products;
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchFeaturedProducts fallback: $e');
    }
    return ShopMockRepository().fetchFeaturedProducts();
  }

  @override
  Future<List<Product>> fetchTrendingProducts() async {
    try {
      final res = await _dio.get(ApiEndpoints.storefront.trendingProducts);
      final products = _parseProducts(res.data);
      if (products.isNotEmpty) return products;
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchTrendingProducts fallback: $e');
    }
    return ShopMockRepository().fetchTrendingProducts();
  }

  @override
  Future<List<Brand>> fetchPopularBrands() async {
    try {
      final res = await _dio.get(ApiEndpoints.storefront.popularBrands);
      final list = ApiResponse.unwrapList(res.data);
      final brands = list.whereType<Map>().map((i) => Brand.fromJson(Map<String, dynamic>.from(i))).toList();
      if (brands.isNotEmpty) return brands;
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchPopularBrands fallback: $e');
    }
    return ShopMockRepository().fetchPopularBrands();
  }

  @override
  Future<List<Product>> fetchProducts({
    ShopFilter? filter,
    SortOrder sort = SortOrder.featured,
    int page = 1,
    int pageSize = 20,
    String? search,
    int? categoryId,
    int? subcategoryId,
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
        'includeVariants': true,
      };

      final effectiveSearch = queryParams?.search ?? search;
      if (effectiveSearch != null && effectiveSearch.isNotEmpty) {
        query['search'] = effectiveSearch;
      }

      final effectiveCatId = categoryId ?? int.tryParse(queryParams?.customParams['categoryId']?.toString() ?? '');
      if (effectiveCatId != null) query['categoryId'] = effectiveCatId;

      final effectiveSubcatId = subcategoryId ?? int.tryParse(queryParams?.customParams['subcategoryId']?.toString() ?? '');
      if (effectiveSubcatId != null) query['subcategoryId'] = effectiveSubcatId;

      final effectiveBrandId = brandId ?? int.tryParse(queryParams?.customParams['brandId']?.toString() ?? '');
      if (effectiveBrandId != null) query['brandId'] = effectiveBrandId;

      final customMerchant = int.tryParse(queryParams?.customParams['merchantId']?.toString() ?? '');
      final effectiveVendorId = vendorId ?? customMerchant ??
          (filter?.merchants.isNotEmpty == true ? int.tryParse(filter!.merchants.first.replaceAll(RegExp(r'[^0-9]'), '')) : null);
      if (effectiveVendorId != null) {
        query['merchantId'] = effectiveVendorId;
        query['vendorId'] = effectiveVendorId;
      }

      final minP = minPrice ?? (filter != null && filter.priceRange.$1 > 0 ? filter.priceRange.$1 : null);
      if (minP != null) query['minPrice'] = minP;
      final maxP = maxPrice ?? (filter != null && filter.priceRange.$2 < 500000 ? filter.priceRange.$2 : null);
      if (maxP != null) query['maxPrice'] = maxP;
      final r = rating ?? (filter?.ratings.isNotEmpty == true ? filter!.ratings.reduce((a, b) => a < b ? a : b).toDouble() : null);
      if (r != null) query['rating'] = r;

      final res = await _dio.get(ApiEndpoints.products.base, queryParameters: query);
      final products = _parseProducts(res.data);
      if (products.isNotEmpty) return products;
      if (query.length > 5) return const [];
    } catch (e) {
      AppLogger.w('ShopRemoteRepository: fetchProducts failed ($e), fallback to local');
    }

    return ShopMockRepository().fetchProducts(
      filter: filter, sort: sort, page: page, pageSize: pageSize,
      search: search, categoryId: categoryId, subcategoryId: subcategoryId,
      brandId: brandId, vendorId: vendorId, minPrice: minPrice,
      maxPrice: maxPrice, rating: rating, queryParams: queryParams,
    );
  }
}
