/// Result returned from GET /api/v1/cart/mobile-app/availability
class CartAvailabilityResult {
  const CartAvailabilityResult({
    required this.isAvailable,
    this.cartId,
    this.message,
    this.unavailableVariantIds = const [],
    this.items = const [],
  });

  final bool isAvailable;
  final int? cartId;
  final String? message;
  final List<int> unavailableVariantIds;
  final List<CartItemAvailability> items;

  factory CartAvailabilityResult.fromJson(dynamic json) {
    if (json == null) return const CartAvailabilityResult(isAvailable: true);
    if (json is Map) {
      final raw = Map<String, dynamic>.from(json);
      final data = raw['data'] is Map
          ? Map<String, dynamic>.from(raw['data'] as Map)
          : raw;

      final cartId = (data['cart_id'] ?? data['cartId'] ?? raw['cart_id'] ?? raw['cartId']) as int?;
      final avail = data['is_available'] as bool? ??
          data['isAvailable'] as bool? ??
          data['available'] as bool? ??
          data['status'] == 'available' ||
          data['status'] == 'success' ||
          data['allAvailable'] == true;

      final itemsList = <CartItemAvailability>[];
      final unavailList = <int>[];

      final rawItems = data['items'] ?? raw['items'];
      if (rawItems is List) {
        for (final it in rawItems) {
          if (it is Map) {
            final item = CartItemAvailability.fromJson(Map<String, dynamic>.from(it));
            itemsList.add(item);
            if (!item.isAvailable && item.productVariantId > 0) {
              unavailList.add(item.productVariantId);
            }
          }
        }
      }

      final rawUnavail = data['unavailableVariantIds'] ??
          data['unavailableItems'] ??
          raw['unavailableVariantIds'] ??
          raw['unavailableItems'];
      if (rawUnavail is List) {
        for (final it in rawUnavail) {
          if (it is num) unavailList.add(it.toInt());
          if (it is Map && (it['product_variant_id'] != null || it['productVariantId'] != null)) {
            final id = (it['product_variant_id'] ?? it['productVariantId']) as num;
            unavailList.add(id.toInt());
          }
        }
      }

      return CartAvailabilityResult(
        isAvailable: avail && unavailList.isEmpty,
        cartId: cartId,
        message: raw['message'] as String? ?? data['message'] as String?,
        unavailableVariantIds: unavailList.toSet().toList(),
        items: itemsList,
      );
    }
    return const CartAvailabilityResult(isAvailable: true);
  }
}

class CartItemAvailability {
  const CartItemAvailability({
    this.cartItemId,
    required this.productVariantId,
    this.requestedQuantity = 1,
    this.availableQuantity,
    required this.isAvailable,
    this.message,
  });

  final int? cartItemId;
  final int productVariantId;
  final int requestedQuantity;
  final int? availableQuantity;
  final bool isAvailable;
  final String? message;

  factory CartItemAvailability.fromJson(Map<String, dynamic> map) {
    final pvId = (map['product_variant_id'] ?? map['productVariantId'] ?? 0) as num;
    final reqQty = (map['requested_quantity'] ?? map['requestedQuantity'] ?? map['quantity'] ?? 1) as num;
    final availQty = (map['available_quantity'] ?? map['availableQuantity'] ?? map['stock']) as num?;
    final isAvail = map['is_available'] as bool? ??
        map['isAvailable'] as bool? ??
        (availQty != null ? availQty >= reqQty : true);

    return CartItemAvailability(
      cartItemId: (map['cart_item_id'] ?? map['cartItemId'] ?? map['itemId']) is num
          ? (map['cart_item_id'] ?? map['cartItemId'] ?? map['itemId'] as num).toInt()
          : null,
      productVariantId: pvId.toInt(),
      requestedQuantity: reqQty.toInt(),
      availableQuantity: availQty?.toInt(),
      isAvailable: isAvail,
      message: map['message'] as String?,
    );
  }
}
