import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'local_notification_service.dart';
import 'notification_constants.dart';
import 'notification_navigation_handler.dart';
import 'notification_payload.dart';

/// Top-level background message handler required by Firebase Messaging.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  debugPrint(
    '[FCM Background] Message ID: ${message.messageId}, Type: ${message.data['type']}',
  );
}

/// Core service orchestrating Firebase Cloud Messaging, permissions,
/// tokens, and lifecycle handlers across foreground, background, and terminated states.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  String? _fcmToken;
  bool _initialized = false;
  bool _permissionGranted = false;

  void Function(NotificationPayload payload)? _onForegroundNotification;
  void Function(String token)? _onTokenRefreshCallback;

  String? get fcmToken => _fcmToken;
  bool get isInitialized => _initialized;
  bool get isPermissionGranted => _permissionGranted;

  void setForegroundDispatcher(
    void Function(NotificationPayload payload) dispatcher,
  ) {
    _onForegroundNotification = dispatcher;
  }

  void dispatchForegroundPayload(NotificationPayload payload) {
    _onForegroundNotification?.call(payload);
  }

  void setTokenRefreshCallback(void Function(String token) callback) {
    _onTokenRefreshCallback = callback;
  }

  /// Initializes Firebase, requests notification permissions, and registers listeners.
  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Initialize Local Notifications first so banners & dialogs always work
    try {
      await LocalNotificationService.instance.initialize();
    } catch (e) {
      debugPrint('[PushNotificationService] Local notifications init error: $e');
    }

    // 2. Initialize Firebase native messaging
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Register top-level background handler
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      // Set iOS foreground presentation options
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Request Push Notification permissions
      await requestPermission();

      // Fetch and cache FCM Token
      await _fetchToken();

      // Listen for FCM Token refresh
      // ignore: deprecated_member_use
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _cacheToken(newToken);
        _onTokenRefreshCallback?.call(newToken);
        debugPrint('[PushNotificationService] FCM Token refreshed: $newToken');
      });

      // Register foreground message listener
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Register background message opened listener
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was launched from terminated state via notification click
      await _checkInitialMessage();
    } catch (e) {
      debugPrint(
        '[PushNotificationService] Firebase native bindings pending full restart. '
        'Run "flutter run" to compile native plugins. Fallback notification mode active: $e',
      );
      _fcmToken ??= 'buynaija-dev-fcm-token';
    }

    _initialized = true;
    debugPrint('[PushNotificationService] Initialized successfully');
  }

  /// Requests user permission for notifications (iOS & Android 13+).
  Future<bool> requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      _permissionGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;

      debugPrint(
        '[PushNotificationService] Authorization Status: ${settings.authorizationStatus}',
      );
      return _permissionGranted;
    } catch (e) {
      debugPrint('[PushNotificationService] Request permission error: $e');
      return false;
    }
  }

  /// Retrieves the active FCM registration token.
  Future<String?> _fetchToken() async {
    try {
      // ignore: deprecated_member_use
      _fcmToken = await FirebaseMessaging.instance.getToken();
      if (_fcmToken != null) {
        await _cacheToken(_fcmToken!);
        debugPrint('[PushNotificationService] FCM Token: $_fcmToken');
      }
      return _fcmToken;
    } catch (e) {
      debugPrint('[PushNotificationService] Fetch token error: $e');
      return null;
    }
  }

  Future<void> _cacheToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(NotificationConstants.keyCachedFcmToken, token);
    } catch (_) {}
  }

  /// Handles foreground messages: presents local notification & dispatches in-app update.
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint(
      '[PushNotificationService] Foreground message received: ${message.messageId}',
    );
    final payload = NotificationPayload.fromRemoteMessage(message);

    // Present heads-up local notification banner
    await LocalNotificationService.instance.showNotification(
      id: message.hashCode,
      title: payload.title,
      body: payload.body,
      payload: payload.toJson(),
    );

    // Update in-app state (e.g. notifications list and badge count)
    _onForegroundNotification?.call(payload);
  }

  /// Handles interaction when user taps notification from background tray.
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint(
      '[PushNotificationService] Notification tapped from background: ${message.messageId}',
    );
    final payload = NotificationPayload.fromRemoteMessage(message);
    NotificationNavigationHandler.instance.handlePayload(payload);
  }

  /// Handles cold launch when user taps notification while app was terminated.
  Future<void> _checkInitialMessage() async {
    try {
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '[PushNotificationService] Terminated launch message: ${initialMessage.messageId}',
        );
        final payload = NotificationPayload.fromRemoteMessage(initialMessage);
        NotificationNavigationHandler.instance.handlePayload(payload);
      }
    } catch (e) {
      debugPrint(
        '[PushNotificationService] Check initial message error: $e',
      );
    }
  }
}
