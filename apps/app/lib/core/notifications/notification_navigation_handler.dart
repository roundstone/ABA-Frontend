import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'notification_payload.dart';

/// Central navigation coordinator for notifications across all lifecycle states:
/// Foreground tap, Background resume, and Terminated launch.
class NotificationNavigationHandler {
  NotificationNavigationHandler._();
  static final NotificationNavigationHandler instance =
      NotificationNavigationHandler._();

  GoRouter? _router;
  String? _pendingRoute;

  final _payloadController =
      StreamController<NotificationPayload>.broadcast();

  Stream<NotificationPayload> get onPayloadClicked =>
      _payloadController.stream;

  String? get pendingRoute => _pendingRoute;

  /// Registers the active [GoRouter] instance.
  /// If a deep link route was pending from a cold launch, it executes immediately.
  void attachRouter(GoRouter router) {
    _router = router;
    if (_pendingRoute != null) {
      final routeToOpen = _pendingRoute!;
      _pendingRoute = null;
      debugPrint('[NotificationNavigation] Executing pending route: $routeToOpen');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateToRoute(routeToOpen);
      });
    }
  }

  /// Processes an incoming [NotificationPayload] when the user interacts with it.
  void handlePayload(NotificationPayload payload) {
    debugPrint(
      '[NotificationNavigation] Handling payload for type: ${payload.type}, route: ${payload.route}',
    );
    _payloadController.add(payload);
    navigateToRoute(payload.route);
  }

  /// Navigates directly to a target path or queues it if the router is not yet attached.
  void navigateToRoute(String route) {
    if (route.isEmpty) return;

    if (_router != null) {
      try {
        _router!.push(route);
      } catch (e) {
        debugPrint('[NotificationNavigation] Error pushing route $route: $e');
        try {
          _router!.go(route);
        } catch (goError) {
          debugPrint('[NotificationNavigation] Error with go fallback: $goError');
        }
      }
    } else {
      debugPrint(
        '[NotificationNavigation] Router not ready yet. Queuing route: $route',
      );
      _pendingRoute = route;
    }
  }

  void clearPendingRoute() {
    _pendingRoute = null;
  }
}
