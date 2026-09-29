
import 'package:app/features/shop/domain/shop_entities.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product.id == product.id &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => product.id.hashCode ^ quantity.hashCode;
}

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + (item.product.discountedPrice * item.quantity));
  }

  double get shipping {
    // Free shipping for orders over 100,000
    return subtotal >= 100000 ? 0.0 : 2000.0;
  }

  double get tax {
    return subtotal * 0.075; // 7.5% tax
  }

  double get total {
    return subtotal + shipping + tax;
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}