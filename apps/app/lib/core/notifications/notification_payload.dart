import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_constants.dart';

/// Structured payload model representing push notification messages and data.
class NotificationPayload {
  const NotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.route,
    required this.data,
    required this.receivedAt,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final String route;
  final Map<String, dynamic> data;
  final DateTime receivedAt;

  /// Creates a [NotificationPayload] from a Firebase [RemoteMessage].
  factory NotificationPayload.fromRemoteMessage(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);
    final title = message.notification?.title ??
        (data['title'] as String?) ??
        'BuyNaija Update';
    final body = message.notification?.body ??
        (data['body'] as String?) ??
        'You have a new update.';
    final type = (data['type'] as String?) ??
        (data['notification_type'] as String?) ??
        NotificationConstants.typeSystemAlert;

    final resolvedRoute = _resolveRoute(type: type, data: data);

    return NotificationPayload(
      id: message.messageId ??
          data['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      route: resolvedRoute,
      data: data,
      receivedAt: DateTime.now(),
    );
  }

  /// Creates a [NotificationPayload] from a JSON-compatible Map.
  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    final data = map['data'] != null
        ? Map<String, dynamic>.from(map['data'] as Map)
        : <String, dynamic>{};
    final type = (map['type'] as String?) ??
        (data['type'] as String?) ??
        NotificationConstants.typeSystemAlert;
    final explicitRoute = map['route'] as String?;
    final resolvedRoute = explicitRoute != null && explicitRoute.isNotEmpty
        ? explicitRoute
        : _resolveRoute(type: type, data: data);

    return NotificationPayload(
      id: (map['id'] as String?) ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: (map['title'] as String?) ?? 'BuyNaija Update',
      body: (map['body'] as String?) ?? '',
      type: type,
      route: resolvedRoute,
      data: data,
      receivedAt: map['receivedAt'] != null
          ? DateTime.tryParse(map['receivedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory NotificationPayload.fromJson(String source) =>
      NotificationPayload.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'route': route,
        'data': data,
        'receivedAt': receivedAt.toIso8601String(),
      };

  String toJson() => json.encode(toMap());

  /// Resolves the in-app route based on payload type and metadata.
  static String _resolveRoute({
    required String type,
    required Map<String, dynamic> data,
  }) {
    // 1. Explicit route provided by server
    final explicitRoute = data['route'] as String?;
    if (explicitRoute != null && explicitRoute.trim().isNotEmpty) {
      return explicitRoute.trim();
    }

    final orderId = data['order_id'] ?? data['orderId'] ?? data['id'];
    final productId = data['product_id'] ?? data['productId'];

    // 2. Derive route based on application flow type
    switch (type) {
      case NotificationConstants.typeOrderPlaced:
      case NotificationConstants.typeOrderConfirmed:
      case NotificationConstants.typeOrderShipped:
      case NotificationConstants.typeOrderDelivered:
      case NotificationConstants.typeOrderCancelled:
        return orderId != null && orderId.toString().isNotEmpty
            ? '/account/orders/$orderId'
            : '/account/orders';

      case NotificationConstants.typeMerchantNewOrder:
      case NotificationConstants.typeMerchantOrderCancelled:
        return orderId != null && orderId.toString().isNotEmpty
            ? '/merchant/orders/$orderId'
            : '/merchant/orders';

      case NotificationConstants.typeMerchantLowStock:
        return '/merchant/products';

      case NotificationConstants.typeWalletCredit:
      case NotificationConstants.typeWalletDebit:
      case NotificationConstants.typeCommissionEarned:
        return '/wallet';

      case NotificationConstants.typeReferralJoined:
        return '/referrals';

      case NotificationConstants.typeReferralReward:
        return '/rewards';

      case NotificationConstants.typePromotion:
        return productId != null && productId.toString().isNotEmpty
            ? '/product/$productId'
            : '/shop';

      case NotificationConstants.typeCartReminder:
        return '/cart';

      case NotificationConstants.typeSystemAlert:
      default:
        return '/notifications';
    }
  }
}
