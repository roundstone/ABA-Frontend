import 'shop_entities.dart';

/// Repository contract — the application layer talks only to this interface.
/// The data layer provides the implementation (mock today, real API tomorrow).
abstract class ShopRepository {
  /// Fetch full shop catalogue (products + categories).
  /// On real API: GET /api/shop/catalogue
  Future<ShopCatalogue> fetchCatalogue();

  /// Fetch a single product by ID.
  /// On real API: GET /api/shop/products/:id
  Future<Product?> fetchProductById(String id);

  /// Fetch products filtered and sorted server-side.
  /// On real API: GET /api/shop/products?category=&sort=&page=
  Future<List<Product>> fetchProducts({
    ShopFilter? filter,
    SortOrder sort = SortOrder.featured,
    int page = 1,
    int pageSize = 20,
  });

  /// Fetch all categories.
  /// On real API: GET /api/shop/categories
  Future<List<ShopCategory>> fetchCategories();
}
