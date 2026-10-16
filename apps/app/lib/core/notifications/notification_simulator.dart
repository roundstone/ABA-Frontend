import 'dart:math';
import 'local_notification_service.dart';
import 'notification_constants.dart';
import 'notification_payload.dart';
import 'push_notification_service.dart';

/// Simulator utility allowing end-to-end testing of every push notification flow
/// in debug and staging environments without requiring a live FCM server backend.
class NotificationSimulator {
  NotificationSimulator._();

  static final Random _rng = Random();

  /// Simulates a Customer Order Status notification
  static Future<void> simulateCustomerOrder({
    String type = NotificationConstants.typeOrderConfirmed,
    String orderId = 'ORD-2026-E4F2A',
  }) async {
    final title = switch (type) {
      NotificationConstants.typeOrderPlaced => 'Order Placed Successfully',
      NotificationConstants.typeOrderShipped => 'Order On Its Way! 🚚',
      NotificationConstants.typeOrderDelivered => 'Order Delivered! 🎉',
      NotificationConstants.typeOrderCancelled => 'Order Cancelled',
      _ => 'Order Confirmed #$orderId',
    };

    final body = switch (type) {
      NotificationConstants.typeOrderPlaced =>
        'We received your order #$orderId and it is being processed.',
      NotificationConstants.typeOrderShipped =>
        'Order #$orderId has been dispatched for delivery.',
      NotificationConstants.typeOrderDelivered =>
        'Your package for order #$orderId has arrived safely.',
      NotificationConstants.typeOrderCancelled =>
        'Order #$orderId was cancelled. Your refund has been credited.',
      _ => 'Merchant has confirmed order #$orderId.',
    };

    await _emit(
      type: type,
      title: title,
      body: body,
      data: {'order_id': orderId},
    );
  }

  /// Simulates a Merchant New Order Alert
  static Future<void> simulateMerchantOrder({
    String orderId = 'ORD-2026-M881B',
    String customerName = 'Amara Nwosu',
    String amount = '₦ 48,500.00',
  }) async {
    await _emit(
      type: NotificationConstants.typeMerchantNewOrder,
      title: 'New Customer Order Received! 🛍️',
      body: '$customerName just placed order #$orderId for $amount.',
      data: {'order_id': orderId, 'amount': amount},
    );
  }

  /// Simulates a Merchant Low Stock Alert
  static Future<void> simulateMerchantLowStock({
    String productName = 'Handcrafted Leather Oxford Shoes',
    int remainingStock = 3,
  }) async {
    await _emit(
      type: NotificationConstants.typeMerchantLowStock,
      title: 'Low Stock Alert ⚠️',
      body: '$productName only has $remainingStock units remaining in store.',
      data: {'product_name': productName, 'stock': remainingStock},
    );
  }

  /// Simulates a Wallet Credit or Commission notification
  static Future<void> simulateWalletCredit({
    String amount = '₦ 12,500.00',
    bool isCommission = false,
  }) async {
    final type = isCommission
        ? NotificationConstants.typeCommissionEarned
        : NotificationConstants.typeWalletCredit;

    final title = isCommission
        ? 'Commission Earned! 💰'
        : 'Wallet Credited Successfully 💳';

    final body = isCommission
        ? 'You earned $amount from a downline purchase in your network.'
        : '$amount has been successfully credited to your main balance.';

    await _emit(
      type: type,
      title: title,
      body: body,
      data: {'amount': amount},
    );
  }

  /// Simulates a Referral Network milestone
  static Future<void> simulateReferralMilestone({
    String refereeName = 'Chinedu Eze',
  }) async {
    await _emit(
      type: NotificationConstants.typeReferralJoined,
      title: 'New Downline Registered! 👥',
      body: '$refereeName just joined BuyNaija using your referral link.',
      data: {'referee': refereeName},
    );
  }

  /// Simulates a Reward Milestone unlocked
  static Future<void> simulateRewardMilestone({
    String rewardTitle = 'Silver Ambassador Milestone',
  }) async {
    await _emit(
      type: NotificationConstants.typeReferralReward,
      title: 'Milestone Unlocked! 🏆',
      body: 'Congratulations! You unlocked the $rewardTitle (+250 points).',
      data: {'milestone': rewardTitle},
    );
  }

  /// Simulates a Marketing Promotion / Flash Sale
  static Future<void> simulatePromotion({
    String campaignTitle = 'Aba Fashion Weekend Flash Sale 🔥',
    String discount = 'Up to 40% OFF',
    String? productId,
  }) async {
    await _emit(
      type: NotificationConstants.typePromotion,
      title: campaignTitle,
      body: 'Exclusive discounts on top artisans today only. $discount!',
      data: productId != null ? {'product_id': productId} : {},
    );
  }

  /// Simulates an Abandoned Cart reminder
  static Future<void> simulateCartReminder({
    int itemCount = 2,
  }) async {
    await _emit(
      type: NotificationConstants.typeCartReminder,
      title: 'Items waiting in your cart 🛒',
      body:
          'You left $itemCount items in your cart. Complete checkout before stock runs out!',
      data: {'item_count': itemCount},
    );
  }

  static Future<void> _emit({
    required String type,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    final id = _rng.nextInt(100000);
    final payload = NotificationPayload.fromMap({
      'id': 'sim-$id',
      'title': title,
      'body': body,
      'type': type,
      'data': {...data, 'type': type},
    });

    await LocalNotificationService.instance.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload.toJson(),
    );

    // Call service foreground dispatcher if hooked
    PushNotificationService.instance.dispatchForegroundPayload(payload);
  }
}
