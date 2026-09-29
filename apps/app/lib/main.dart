import 'package:app/core/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  // Must be called before any plugin (SharedPreferences, etc.)
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-warm SharedPreferences so the platform channel is ready.
  // We pass the instance as a ProviderScope override so CartNotifier
  // never has to call getInstance() on a cold channel.
  final prefs = await SharedPreferences.getInstance();

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
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'ABA ERP',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
