import 'package:app/core/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/notifications/push_notification_providers.dart';
import 'core/notifications/push_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  // Must be called before any plugin (SharedPreferences, etc.)
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-warm SharedPreferences so the platform channel is ready.
  // We pass the instance as a ProviderScope override so CartNotifier
  // never has to call getInstance() on a cold channel.
  final prefs = await SharedPreferences.getInstance();

  // Initialize Firebase Cloud Messaging & Local Notifications
  await PushNotificationService.instance.initialize();

  runApp(
    ProviderScope(
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

