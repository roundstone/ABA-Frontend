/// Global application configuration and environment flags.
class AppConfig {
  /// When true, repositories and features fall back to or directly use mock data.
  /// When false (production default), integrated endpoints throw errors on failure
  /// so that the UI displays user-friendly error states with retry actions.
  static bool isMockMode =
      const bool.fromEnvironment('IS_MOCK', defaultValue: false);
}

