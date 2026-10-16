import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_constants.dart';
import 'notification_navigation_handler.dart';
import 'notification_payload.dart';

/// Local notification service for presenting foreground heads-up banners
/// and handling notification channel configurations on Android & iOS.
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Initializes local notification settings, channels, and tap callbacks.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onSelectNotification,
      );

      // Create Android High Importance Notification Channel
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        const channel = AndroidNotificationChannel(
          NotificationConstants.channelId,
          NotificationConstants.channelName,
          description: NotificationConstants.channelDescription,
          importance: Importance.max,
          playSound: true,
        );
        await androidPlugin.createNotificationChannel(channel);
      }

      _initialized = true;
      debugPrint('[LocalNotificationService] Initialized successfully');
    } catch (e, stack) {
      debugPrint('[LocalNotificationService] Initialization failed: $e\n$stack');
    }
  }

  /// Displays an in-app heads-up notification.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        NotificationConstants.channelId,
        NotificationConstants.channelName,
        channelDescription: NotificationConstants.channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await _localNotifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    } catch (e) {
      debugPrint('[LocalNotificationService] showNotification error: $e');
    }
  }

  /// Cancels a specific notification by ID.
  Future<void> cancel(int id) async {
    await _localNotifications.cancel(id: id);
  }

  /// Clears all presented notifications.
  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
  }

  void _onSelectNotification(NotificationResponse response) {
    final payloadString = response.payload;
    if (payloadString == null || payloadString.isEmpty) return;

    try {
      final payload = NotificationPayload.fromJson(payloadString);
      NotificationNavigationHandler.instance.handlePayload(payload);
    } catch (e) {
      debugPrint('[LocalNotificationService] Failed to parse payload: $e');
    }
  }
}
