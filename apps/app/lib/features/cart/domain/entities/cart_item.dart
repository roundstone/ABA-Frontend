import '../../../shop/domain/product.dart';
import '../../../shop/domain/product_variant.dart';

/// Single item in the customer's cart.
class CartItem {
  const CartItem({
    this.id,
    required this.product,
    required this.quantity,
    this.productVariantId,
    this.variant,
    this.selectedColor,
    this.selectedSize,
    this.unitPrice,
    this.isAvailable = true,
    this.availabilityMessage,
  });

  /// Backend cart item ID (used for PATCH and DELETE /api/v1/cart/mobile-app/items/{itemId})
  final String? id;

  /// Associated product
  final Product product;

  /// Quantity in cart
  final int quantity;

  /// Backend productVariantId (used for POST /api/v1/cart/mobile-app/items)
  final int? productVariantId;

  /// Full variant details if available
  final ProductVariant? variant;

  final String? selectedColor;
  final String? selectedSize;
  final double? unitPrice;

  /// Whether this item is currently available in stock
  final bool isAvailable;
  final String? availabilityMessage;

  String get effectiveId => id ?? product.id;

  int? get effectiveVariantId {
    if (productVariantId != null && productVariantId! > 0) {
      return productVariantId;
    }
    if (variant != null && variant!.id > 0) {
      return variant!.id;
    }
    return null;
  }

  double get price => unitPrice ?? variant?.price ?? product.price;

  double get itemTotal => price * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    int? productVariantId,
    ProductVariant? variant,
    String? selectedColor,
    String? selectedSize,
    double? unitPrice,
    bool? isAvailable,
    String? availabilityMessage,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      productVariantId: productVariantId ?? this.productVariantId,
      variant: variant ?? this.variant,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      unitPrice: unitPrice ?? this.unitPrice,
      isAvailable: isAvailable ?? this.isAvailable,
      availabilityMessage: availabilityMessage ?? this.availabilityMessage,
    );
  }

  factory CartItem.fromJson(
    Map<String, dynamic> json, {
    List<Product> catalogue = const [],
  }) {
    Map<String, dynamic>? variantMap;
    if (json['productVariant'] is Map) {
      variantMap = Map<String, dynamic>.from(json['productVariant'] as Map);
    } else if (json['product_variant'] is Map) {
      variantMap = Map<String, dynamic>.from(json['product_variant'] as Map);
    } else if (json['variant'] is Map) {
      variantMap = Map<String, dynamic>.from(json['variant'] as Map);
    }

    Product? prod;
    if (json['product'] is Map) {
      prod = Product.fromJson(Map<String, dynamic>.from(json['product'] as Map));
    } else if (variantMap != null && variantMap['product'] is Map) {
      prod = Product.fromJson(Map<String, dynamic>.from(variantMap['product'] as Map));
    }

    final rawVariantId = json['productVariantId'] ??
        json['product_variant_id'] ??
        json['variantId'] ??
        json['variant_id'] ??
        variantMap?['id'];

    int? vId;
    if (rawVariantId is num) {
      vId = rawVariantId.toInt();
    } else if (rawVariantId is String) {
      vId = int.tryParse(rawVariantId);
    }

    if (prod == null) {
      final pid = json['productId']?.toString() ??
          json['product_id']?.toString() ??
          variantMap?['product_id']?.toString() ??
          variantMap?['productId']?.toString() ??
          '';

      if (pid.isNotEmpty && catalogue.isNotEmpty) {
        prod = catalogue.where((p) => p.id == pid).firstOrNull;
      }

      if (prod == null && pid.isNotEmpty) {
        final prodName = (variantMap?['name'] as String?) ??
            (json['name'] as String?) ??
            (json['productName'] as String?) ??
            'Product';
        final price = (json['price'] as num?)?.toDouble() ??
            (json['unitPrice'] as num?)?.toDouble() ??
            (variantMap != null ? double.tryParse(variantMap['price']?.toString() ?? '') : null) ??
            0.0;
        prod = Product(
          id: pid,
          name: prodName,
          slug: 'product-$pid',
          price: price,
          category: 'General',
          brand: 'Store',
          rating: 5.0,
          reviewCount: 0,
          stock: 100,
          images: const [],
        );
      }
    }

    prod ??= Product(
      id: json['product_id']?.toString() ??
          json['productId']?.toString() ??
          variantMap?['product_id']?.toString() ??
          'item',
      name: (json['name'] as String?) ??
          (json['productName'] as String?) ??
          (variantMap?['name'] as String?) ??
          'Product',
      slug: 'item',
      price: (json['price'] as num?)?.toDouble() ??
          (json['unitPrice'] as num?)?.toDouble() ??
          0.0,
      category: 'General',
      brand: 'Store',
      rating: 5.0,
      reviewCount: 0,
      stock: 100,
      images: const [],
    );

    final color = json['selectedColor'] as String? ??
        json['color'] as String? ??
        (variantMap != null && variantMap['attributes'] is Map
            ? variantMap['attributes']['color']?.toString()
            : null);
    final size = json['selectedSize'] as String? ??
        json['size'] as String? ??
        (variantMap != null && variantMap['attributes'] is Map
            ? variantMap['attributes']['size']?.toString()
            : null);
    final unitPrice = (json['price'] as num?)?.toDouble() ??
        (json['unitPrice'] as num?)?.toDouble() ??
        (variantMap != null ? double.tryParse(variantMap['price']?.toString() ?? '') : null) ??
        prod.price;

    return CartItem(
      id: json['id']?.toString() ?? json['itemId']?.toString(),
      product: prod,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      productVariantId: vId,
      unitPrice: unitPrice,
      selectedColor: color,
      selectedSize: size,
      isAvailable: json['isAvailable'] as bool? ?? json['available'] as bool? ?? true,
      availabilityMessage: json['availabilityMessage'] as String? ?? json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': product.id,
      'productVariantId': effectiveVariantId,
      'name': product.name,
      'price': price,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'isAvailable': isAvailable,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        (other.id == id || other.effectiveId == effectiveId) &&
        other.effectiveVariantId == effectiveVariantId &&
        other.quantity == quantity &&
        other.selectedColor == selectedColor &&
        other.selectedSize == selectedSize;
  }

  @override
  int get hashCode =>
      effectiveId.hashCode ^
      (effectiveVariantId ?? 0).hashCode ^
      quantity.hashCode ^
      (selectedColor ?? '').hashCode ^
      (selectedSize ?? '').hashCode;
}

