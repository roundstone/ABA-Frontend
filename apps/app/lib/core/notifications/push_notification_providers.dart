import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../providers/notifications_provider.dart';
import '../theme/app_colors.dart';
import 'notification_constants.dart';
import 'notification_payload.dart';
import 'push_notification_service.dart';

final fcmTokenProvider = StateProvider<String?>((ref) {
  return PushNotificationService.instance.fcmToken;
});

final notificationPermissionProvider = StateProvider<bool>((ref) {
  return PushNotificationService.instance.isPermissionGranted;
});

/// Hook to initialize and connect push notification events to Riverpod state.
final pushNotificationInitializerProvider = Provider<void>((ref) {
  final service = PushNotificationService.instance;

  // Dispatch incoming foreground notifications directly into the in-app notification center
  service.setForegroundDispatcher((NotificationPayload payload) {
    final notification = AppNotification(
      id: payload.id,
      title: payload.title,
      body: payload.body,
      time: 'Just now',
      isRead: false,
      icon: _resolveIcon(payload.type),
      color: _resolveColor(payload.type),
      route: payload.route,
    );

    ref.read(notificationsProvider.notifier).addNotification(notification);
  });

  // Keep fcmTokenProvider synchronized on token refresh
  service.setTokenRefreshCallback((String token) {
    ref.read(fcmTokenProvider.notifier).state = token;
  });

  // Ensure current token is reflected
  if (service.fcmToken != null) {
    ref.read(fcmTokenProvider.notifier).state = service.fcmToken;
  }
});

List<List<dynamic>> _resolveIcon(String type) {
  switch (type) {
    case NotificationConstants.typeOrderPlaced:
    case NotificationConstants.typeOrderConfirmed:
    case NotificationConstants.typeOrderShipped:
    case NotificationConstants.typeOrderDelivered:
    case NotificationConstants.typeMerchantNewOrder:
      return HugeIcons.strokeRoundedPackage;

    case NotificationConstants.typeOrderCancelled:
    case NotificationConstants.typeMerchantOrderCancelled:
      return HugeIcons.strokeRoundedCancel01;

    case NotificationConstants.typeMerchantLowStock:
      return HugeIcons.strokeRoundedAlertCircle;

    case NotificationConstants.typeWalletCredit:
    case NotificationConstants.typeWalletDebit:
    case NotificationConstants.typeCommissionEarned:
      return HugeIcons.strokeRoundedWallet01;

    case NotificationConstants.typeReferralJoined:
    case NotificationConstants.typeReferralReward:
      return HugeIcons.strokeRoundedAward01;

    case NotificationConstants.typePromotion:
      return HugeIcons.strokeRoundedDiscount01;

    case NotificationConstants.typeCartReminder:
      return HugeIcons.strokeRoundedShoppingCart01;

    case NotificationConstants.typeSystemAlert:
    default:
      return HugeIcons.strokeRoundedNotification01;
  }
}

Color _resolveColor(String type) {
  switch (type) {
    case NotificationConstants.typeOrderDelivered:
    case NotificationConstants.typeWalletCredit:
    case NotificationConstants.typeCommissionEarned:
    case NotificationConstants.typeReferralReward:
      return AppColors.success;

    case NotificationConstants.typeOrderCancelled:
    case NotificationConstants.typeMerchantOrderCancelled:
    case NotificationConstants.typeMerchantLowStock:
      return AppColors.error;

    case NotificationConstants.typeMerchantNewOrder:
    case NotificationConstants.typeOrderShipped:
    case NotificationConstants.typePromotion:
      return const Color(0xFFF59E0B);

    case NotificationConstants.typeOrderPlaced:
    case NotificationConstants.typeOrderConfirmed:
    case NotificationConstants.typeReferralJoined:
    case NotificationConstants.typeWalletDebit:
    case NotificationConstants.typeCartReminder:
    case NotificationConstants.typeSystemAlert:
    default:
      return AppColors.primary;
  }
}
