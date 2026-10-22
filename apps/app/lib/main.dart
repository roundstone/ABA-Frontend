import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/logging/app_logger.dart';
import 'core/logging/app_provider_observer.dart';
import 'core/notifications/push_notification_providers.dart';
import 'core/notifications/push_notification_service.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  // Must be called before any plugin (SharedPreferences, etc.)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global logger with development / production profiles
  AppLogger.initialize();

  // Catch unhandled Flutter framework errors (rendering, layout, widget lifecycle)
  FlutterError.onError = (details) {
    AppLogger.e(
      'Flutter Framework Error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  // Catch unhandled asynchronous & platform dispatcher errors
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.e(
      'Unhandled Asynchronous Error: $error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  // Pre-warm SharedPreferences so the platform channel is ready.
  final prefs = await SharedPreferences.getInstance();

  // Initialize Firebase Cloud Messaging & Local Notifications
  await PushNotificationService.instance.initialize();

  AppLogger.i('App bootstrap complete. Launching root application widget.');

  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const ABAApp(),
    ),
  );
}

class ABAApp extends ConsumerWidget {
  const ABAApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activate push notification state bridge (updates in-app notification center & token)
    ref.watch(pushNotificationInitializerProvider);

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'BUYNAIJA',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

