import '../../../shop/domain/product.dart';
import 'cart_item.dart';

export 'cart_item.dart';
export 'cart_availability.dart';

/// Customer's cart representation.
class Cart {
  const Cart({
    this.id,
    this.items = const [],
    this.isAvailable = true,
    this.availabilityMessage,
  });

  final String? id;
  final List<CartItem> items;
  final bool isAvailable;
  final String? availabilityMessage;

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.itemTotal);

  double get shipping => subtotal >= 100000 ? 0.0 : 2000.0;

  double get tax => subtotal * 0.075; // 7.5% VAT

  double get total => subtotal + shipping + tax;

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  bool get isEmpty => items.isEmpty;

  bool containsProduct(Product product) {
    return items.any((i) {
      if (i.product.id == product.id) return true;
      if (product.slug.isNotEmpty && i.product.slug == product.slug) return true;
      if (i.effectiveVariantId != null &&
          i.effectiveVariantId! > 0 &&
          product.variants.any((v) => v.id == i.effectiveVariantId)) {
        return true;
      }
      return false;
    });
  }

  Cart addItem(CartItem newItem) {
    final existingIndex = items.indexWhere((i) {
      final sameProduct = i.product.id == newItem.product.id ||
          (i.product.slug.isNotEmpty && i.product.slug == newItem.product.slug);
      if (newItem.id != null && i.id != null && i.id == newItem.id) {
        return sameProduct;
      }
      if (!sameProduct) return false;

      final sameVariant = newItem.effectiveVariantId == null ||
          i.effectiveVariantId == null ||
          i.effectiveVariantId == newItem.effectiveVariantId;
      final sameColor = i.selectedColor == newItem.selectedColor;
      final sameSize = i.selectedSize == newItem.selectedSize;
      return sameVariant && sameColor && sameSize;
    });
    final updated = List<CartItem>.from(items);
    if (existingIndex >= 0) {
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + newItem.quantity,
      );
    } else {
      updated.add(newItem);
    }
    return Cart(id: id, items: updated);
  }

  Cart removeItem(String productIdOrItemId) {
    return Cart(
      id: id,
      items: items.where((i) {
        if (i.id != null && i.id == productIdOrItemId) return false;
        if (i.product.id == productIdOrItemId) return false;
        if (i.effectiveId == productIdOrItemId) return false;
        return true;
      }).toList(),
    );
  }

  Cart updateQuantity(String productIdOrItemId, int quantity) {
    if (quantity <= 0) return removeItem(productIdOrItemId);
    return Cart(
      id: id,
      items: items.map((i) {
        final matches = (i.id != null && i.id == productIdOrItemId) ||
            i.product.id == productIdOrItemId ||
            i.effectiveId == productIdOrItemId;
        if (matches) return i.copyWith(quantity: quantity);
        return i;
      }).toList(),
    );
  }

  Cart clear() => const Cart();

  factory Cart.fromJson(
    dynamic json, {
    List<Product> catalogue = const [],
  }) {
    if (json == null) return const Cart();
    if (json is List) {
      return Cart(
        items: json
            .whereType<Map>()
            .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item), catalogue: catalogue))
            .toList(),
      );
    }
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      final rawItems = map['items'] ?? map['cartItems'] ?? map['data'];
      final parsedItems = <CartItem>[];
      if (rawItems is List) {
        for (final item in rawItems) {
          if (item is Map) {
            parsedItems.add(
              CartItem.fromJson(Map<String, dynamic>.from(item), catalogue: catalogue),
            );
          }
        }
      }
      return Cart(
        id: map['id']?.toString() ?? map['cartId']?.toString(),
        items: parsedItems,
        isAvailable: map['isAvailable'] as bool? ?? map['available'] as bool? ?? true,
        availabilityMessage: map['message'] as String? ?? map['availabilityMessage'] as String?,
      );
    }
    return const Cart();
  }
}
