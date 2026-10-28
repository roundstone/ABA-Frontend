export 'brand.dart';
export 'product.dart';
export 'product_variant.dart';
export 'shop_category.dart';
import 'product.dart';
import 'shop_category.dart';

// ─── Enums ────────────────────────────────────────────────────────────────

enum SortOrder { featured, nameAsc, nameDesc, priceLow, priceHigh, newest }

enum ViewMode { grid, list }

// ─── Cart ─────────────────────────────────────────────────────────────────

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  final Product product;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  double get itemTotal => product.discountedPrice * quantity;

  CartItem copyWith({
    int? quantity,
    String? selectedColor,
    String? selectedSize,
  }) =>
      CartItem(
        product: product,
        quantity: quantity ?? this.quantity,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedSize: selectedSize ?? this.selectedSize,
      );
}

class Cart {
  const Cart({this.items = const []});

  final List<CartItem> items;

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.itemTotal);

  double get shipping => subtotal > 50000 ? 0 : 2500;

  double get tax => subtotal * 0.075; // 7.5% VAT

  double get total => subtotal + shipping + tax;

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  bool get isEmpty => items.isEmpty;

  Cart addItem(CartItem newItem) {
    final existingIndex = items.indexWhere(
      (i) =>
          i.product.id == newItem.product.id &&
          i.selectedColor == newItem.selectedColor &&
          i.selectedSize == newItem.selectedSize,
    );
    final updated = List<CartItem>.from(items);
    if (existingIndex >= 0) {
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + newItem.quantity,
      );
    } else {
      updated.add(newItem);
    }
    return Cart(items: updated);
  }

  Cart removeItem(String productId) => Cart(
        items: items.where((i) => i.product.id != productId).toList(),
      );

  Cart updateQuantity(String productId, int quantity) {
    if (quantity <= 0) return removeItem(productId);
    return Cart(
      items: items.map((i) {
        if (i.product.id == productId) return i.copyWith(quantity: quantity);
        return i;
      }).toList(),
    );
  }

  Cart clear() => const Cart();
}

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
