import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/dio_client.dart';
import '../domain/shop_entities.dart';
import '../domain/shop_repository.dart';
import 'shop_categories_remote_service.dart';
import 'shop_mock_repository.dart';
import 'shop_products_remote_service.dart';
import 'shop_remote_helpers.dart';
import 'shop_reviews_remote_service.dart';

/// Real API implementation of [ShopRepository].
class ShopRemoteRepository implements ShopRepository {
  ShopRemoteRepository({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl)),
        _categories = ShopCategoriesRemoteService(
          dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl)),
        ),
        _productsService = ShopProductsRemoteService(
          dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl)),
        ),
        _reviews = ShopReviewsRemoteService(
          dio ?? Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl)),
        );

  final Dio _dio;
  final ShopCategoriesRemoteService _categories;
  final ShopProductsRemoteService _productsService;
  final ShopReviewsRemoteService _reviews;

  @override
  Future<List<ShopCategory>> fetchCategories({ListQueryParams? params}) =>
      _categories.fetchCategories(params: params);

  @override
  Future<List<ShopCategory>> fetchSubcategories({ListQueryParams? params}) =>
      _categories.fetchSubcategories(params: params);

  @override
  Future<ShopCategory?> fetchSubcategoryById(String id) =>
      _categories.fetchSubcategoryById(id);

  @override
  Future<ShopCatalogue> fetchCatalogue() async {
    try {
      final products = await fetchProducts();
      final categories = await fetchCategories();
      return ShopCatalogue(
        products: products,
        categories: categories,
        featuredBannerUrl: '',
      );
    } catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w('ShopRemoteRepository: fetchCatalogue fallback: $e');
        return ShopMockRepository().fetchCatalogue();
      }
      rethrow;
    }
  }

  @override
  Future<Product?> fetchProductById(String id) =>
      _productsService.fetchProductById(
        id,
        searchProducts: ({search, pageSize = 5}) =>
            fetchProducts(search: search, pageSize: pageSize),
      );

  @override
  Future<ProductVariant?> fetchProductVariantById(String id) =>
      _productsService.fetchProductVariantById(id);

  @override
  Future<List<Product>> fetchFeaturedProducts() =>
      _productsService.fetchFeaturedProducts();

  @override
  Future<List<Product>> fetchTrendingProducts() =>
      _productsService.fetchTrendingProducts();

  @override
  Future<List<Brand>> fetchPopularBrands() =>
      _productsService.fetchPopularBrands();

  @override
  Future<PaginatedData<ProductReview>> fetchReviews({
    ListQueryParams? params,
    int? reviewableId,
    String reviewableType = 'product',
  }) =>
      _reviews.fetchReviews(
        params: params,
        reviewableId: reviewableId,
        reviewableType: reviewableType,
      );

  @override
  Future<ProductReview> createReview(CreateReviewInput input) =>
      _reviews.createReview(input);

  @override
  Future<ProductReview> updateReview(String id, UpdateReviewInput input) =>
      _reviews.updateReview(id, input);

  @override
  Future<void> deleteReview(String id) => _reviews.deleteReview(id);

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
      final query = ShopRemoteHelpers.buildProductQuery(
        filter: filter,
        sort: sort,
        page: page,
        pageSize: pageSize,
        search: search,
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        brandId: brandId,
        vendorId: vendorId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        rating: rating,
        queryParams: queryParams,
      );

      final res = await _dio.get(
        ApiEndpoints.products.base,
        queryParameters: query,
      );
      return ShopRemoteHelpers.parseProducts(res.data);
    } on DioException catch (e) {
      if (AppConfig.isMockMode) {
        AppLogger.w(
          'ShopRemoteRepository: fetchProducts failed ($e), fallback to mock',
        );
        return ShopMockRepository().fetchProducts(
          filter: filter,
          sort: sort,
          page: page,
          pageSize: pageSize,
          search: search,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          brandId: brandId,
          vendorId: vendorId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          rating: rating,
          queryParams: queryParams,
        );
      }
      throw ApiError.fromDio(e);
    } catch (e) {
      if (AppConfig.isMockMode) {
        return ShopMockRepository().fetchProducts(
          filter: filter,
          sort: sort,
          page: page,
          pageSize: pageSize,
          search: search,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          brandId: brandId,
          vendorId: vendorId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          rating: rating,
          queryParams: queryParams,
        );
      }
      rethrow;
    }
  }
}
