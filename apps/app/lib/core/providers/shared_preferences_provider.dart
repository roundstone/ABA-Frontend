import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance.
/// Defaults to null in unit/widget tests unless overridden in ProviderScope.
final sharedPreferencesProvider = Provider<SharedPreferences?>(
  (ref) => null,
);
