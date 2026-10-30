export 'brand.dart';
export 'product.dart';
export 'product_review.dart';
export 'product_variant.dart';
export 'shop_category.dart';
export '../../cart/domain/entities/cart_entities.dart';
import 'product.dart';
import 'shop_category.dart';

// ─── Enums ────────────────────────────────────────────────────────────────

enum SortOrder { featured, nameAsc, nameDesc, priceLow, priceHigh, newest }

enum ViewMode { grid, list }

// ─── Filter state ─────────────────────────────────────────────────────────

class ShopFilter {
  const ShopFilter({
    this.categories = const [],
    this.subcategories = const [],
    this.brands = const [],
    this.merchants = const [],
    this.colors = const [],
    this.ratings = const [],
    this.priceRange = const (0.0, 500000.0),
  });

  final List<String> categories;
  final List<String> subcategories;
  final List<String> brands;
  final List<String> merchants;
  final List<String> colors;
  final List<int> ratings;
  final (double min, double max) priceRange;

  bool get isActive =>
      categories.isNotEmpty ||
      subcategories.isNotEmpty ||
      brands.isNotEmpty ||
      merchants.isNotEmpty ||
      colors.isNotEmpty ||
      ratings.isNotEmpty ||
      priceRange.$1 > 0 ||
      priceRange.$2 < 500000;

  ShopFilter copyWith({
    List<String>? categories,
    List<String>? subcategories,
    List<String>? brands,
    List<String>? merchants,
    List<String>? colors,
    List<int>? ratings,
    (double, double)? priceRange,
  }) =>
      ShopFilter(
        categories: categories ?? this.categories,
        subcategories: subcategories ?? this.subcategories,
        brands: brands ?? this.brands,
        merchants: merchants ?? this.merchants,
        colors: colors ?? this.colors,
        ratings: ratings ?? this.ratings,
        priceRange: priceRange ?? this.priceRange,
      );

  ShopFilter reset() => const ShopFilter();
}

// ─── Shop catalogue state ─────────────────────────────────────────────────

class ShopCatalogue {
  const ShopCatalogue({
    required this.products,
    required this.categories,
    required this.featuredBannerUrl,
  });

  final List<Product> products;
  final List<ShopCategory> categories;
  final String featuredBannerUrl;
}
