import '../../../core/network/api_response.dart';
import '../../../core/network/list_query_params.dart';
import '../domain/shop_entities.dart';

/// Helper utilities for [ShopRemoteRepository] query building and parsing.
class ShopRemoteHelpers {
  ShopRemoteHelpers._();

  static String mapSortOrder(SortOrder sort) => switch (sort) {
        SortOrder.priceLow => 'base_selling_price:ASC',
        SortOrder.priceHigh => 'base_selling_price:DESC',
        SortOrder.nameAsc => 'name:ASC',
        SortOrder.nameDesc => 'name:DESC',
        SortOrder.newest || SortOrder.featured => 'createdAt:DESC',
      };

  static List<Product> parseProducts(dynamic data) =>
      ApiResponse.unwrapList(data)
          .whereType<Map>()
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .toList();

  static List<ShopCategory> parseCategories(dynamic data) =>
      ApiResponse.unwrapList(data)
          .whereType<Map>()
          .map((item) => ShopCategory.fromJson(Map<String, dynamic>.from(item)))
          .toList();

  static Map<String, dynamic> buildProductQuery({
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
  }) {
    final query = <String, dynamic>{
      'page': queryParams?.page ?? page,
      'limit': queryParams?.limit ?? pageSize,
      'orderBy': queryParams?.orderBy ?? mapSortOrder(sort),
      'isActive': queryParams?.isActive ?? true,
      'includeVariants': true,
    };
    final effectiveSearch = queryParams?.search ?? search;
    if (effectiveSearch != null && effectiveSearch.isNotEmpty) {
      query['search'] = effectiveSearch;
    }
    final effectiveCatId = categoryId ??
        int.tryParse(queryParams?.customParams['categoryId']?.toString() ?? '');
    if (effectiveCatId != null) query['categoryId'] = effectiveCatId;

    final effectiveSubcatId = subcategoryId ??
        int.tryParse(queryParams?.customParams['subcategoryId']?.toString() ?? '');
    if (effectiveSubcatId != null) query['subcategoryId'] = effectiveSubcatId;

    final effectiveBrandId = brandId ??
        int.tryParse(queryParams?.customParams['brandId']?.toString() ?? '');
    if (effectiveBrandId != null) query['brandId'] = effectiveBrandId;

    final customMerchant = int.tryParse(
        queryParams?.customParams['merchantId']?.toString() ?? '');
    final effectiveVendorId = vendorId ??
        customMerchant ??
        (filter?.merchants.isNotEmpty == true
            ? int.tryParse(filter!.merchants.first.replaceAll(RegExp(r'[^0-9]'), ''))
            : null);
    if (effectiveVendorId != null) {
      query['merchantId'] = effectiveVendorId;
      query['vendorId'] = effectiveVendorId;
    }
    final minP = minPrice ??
        (filter != null && filter.priceRange.$1 > 0
            ? filter.priceRange.$1
            : null);
    if (minP != null) query['minPrice'] = minP;

    final maxP = maxPrice ??
        (filter != null && filter.priceRange.$2 < 500000
            ? filter.priceRange.$2
            : null);
    if (maxP != null) query['maxPrice'] = maxP;

    final r = rating ??
        (filter?.ratings.isNotEmpty == true
            ? filter!.ratings.reduce((a, b) => a < b ? a : b).toDouble()
            : null);
    if (r != null) query['rating'] = r;

    return query;
  }
}
