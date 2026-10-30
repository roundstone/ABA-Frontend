/// Result returned from GET /api/v1/cart/mobile-app/availability
class CartAvailabilityResult {
  const CartAvailabilityResult({
    required this.isAvailable,
    this.message,
    this.unavailableVariantIds = const [],
    this.items = const [],
  });

  final bool isAvailable;
  final String? message;
  final List<int> unavailableVariantIds;
  final List<CartItemAvailability> items;

  factory CartAvailabilityResult.fromJson(dynamic json) {
    if (json == null) return const CartAvailabilityResult(isAvailable: true);
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      final avail = map['isAvailable'] as bool? ??
          map['available'] as bool? ??
          map['status'] == 'available' ||
          map['status'] == 'success' ||
          map['allAvailable'] == true;

      final unavailList = <int>[];
      final rawUnavail = map['unavailableVariantIds'] ?? map['unavailableItems'];
      if (rawUnavail is List) {
        for (final it in rawUnavail) {
          if (it is num) unavailList.add(it.toInt());
          if (it is Map && it['productVariantId'] != null) {
            unavailList.add((it['productVariantId'] as num).toInt());
          }
        }
      }

      return CartAvailabilityResult(
        isAvailable: avail && unavailList.isEmpty,
        message: map['message'] as String?,
        unavailableVariantIds: unavailList,
      );
    }
    return const CartAvailabilityResult(isAvailable: true);
  }
}

class CartItemAvailability {
  const CartItemAvailability({
    required this.productVariantId,
    required this.isAvailable,
    this.availableQuantity,
    this.message,
  });

  final int productVariantId;
  final bool isAvailable;
  final int? availableQuantity;
  final String? message;
}

