import '../../../core/network/list_query_params.dart';
import 'shop_entities.dart';

/// Repository contract — the application layer talks only to this interface.
/// The data layer provides the implementation (mock today, real API tomorrow).
abstract class ShopRepository {
  /// Fetch full shop catalogue (products + categories).
  /// On real API: GET /api/v1/products and GET /api/v1/product-categories
  Future<ShopCatalogue> fetchCatalogue();

  /// Fetch a single product by ID.
  /// On real API: GET /api/v1/products/:id
  Future<Product?> fetchProductById(String id);

  /// Fetch products filtered and sorted server-side.
  /// On real API: GET /api/v1/products?page=1&limit=10&orderBy=createdAt:DESC&isActive=true&includeVariants=true
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
  });

  /// Fetch product categories from /api/v1/product-categories.
  Future<List<ShopCategory>> fetchCategories({ListQueryParams? params});

  /// Fetch product subcategories from /api/v1/product-subcategories.
  Future<List<ShopCategory>> fetchSubcategories({ListQueryParams? params});

  /// Fetch a single product subcategory by ID from /api/v1/product-subcategories/:id.
  Future<ShopCategory?> fetchSubcategoryById(String id);

  /// Fetch a single product variant by ID from /api/v1/product-variants/:id.
  Future<ProductVariant?> fetchProductVariantById(String id);

  /// Fetch featured products from /api/v1/storefront/mobile-app/featured-products.
  Future<List<Product>> fetchFeaturedProducts();

  /// Fetch trending products from /api/v1/storefront/mobile-app/trending-products.
  Future<List<Product>> fetchTrendingProducts();

  /// Fetch popular brands from /api/v1/storefront/popular-brands.
  Future<List<Brand>> fetchPopularBrands();
}
