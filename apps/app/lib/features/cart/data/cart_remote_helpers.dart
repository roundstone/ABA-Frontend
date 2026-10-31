/// Helper parsing functions for [CartRemoteRepository].
class CartRemoteHelpers {
  CartRemoteHelpers._();

  static Map<String, dynamic> extractItemMap(
    Map<String, dynamic> data, {
    int? productVariantId,
    String? itemId,
  }) {
    if (data.containsKey('items') && data['items'] is List) {
      final items = (data['items'] as List).whereType<Map>().toList();
      if (productVariantId != null) {
        final match = items.firstWhere(
          (m) =>
              m['product_variant_id'] == productVariantId ||
              m['productVariantId'] == productVariantId ||
              (m['productVariant'] is Map &&
                  (m['productVariant']['id'] == productVariantId ||
                      m['productVariant']['id']?.toString() ==
                          productVariantId.toString())),
          orElse: () => items.isNotEmpty ? items.last : const {},
        );
        if (match.isNotEmpty) return Map<String, dynamic>.from(match);
      }
      if (itemId != null) {
        final match = items.firstWhere(
          (m) =>
              m['id']?.toString() == itemId ||
              m['itemId']?.toString() == itemId,
          orElse: () => items.isNotEmpty ? items.last : const {},
        );
        if (match.isNotEmpty) return Map<String, dynamic>.from(match);
      }
      if (items.isNotEmpty) return Map<String, dynamic>.from(items.last);
    }
    return data;
  }
}

