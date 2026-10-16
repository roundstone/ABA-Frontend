import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/shared_preferences_provider.dart';

const String _kThemeModeKey = 'app_theme_mode';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  SharedPreferences? prefs;
  try {
    prefs = ref.watch(sharedPreferencesProvider);
  } catch (_) {
    // Fallback for tests where sharedPreferencesProvider is not overridden
  }
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_loadInitialTheme(_prefs));

  final SharedPreferences? _prefs;

  static ThemeMode _loadInitialTheme(SharedPreferences? prefs) {
    if (prefs == null) return ThemeMode.system;
    final saved = prefs.getString(_kThemeModeKey);
    switch (saved) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    if (_prefs != null) {
      final value = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await _prefs.setString(_kThemeModeKey, value);
    }
  }
}
