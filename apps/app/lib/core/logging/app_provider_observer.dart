import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_logger.dart';

/// Riverpod ProviderObserver to log provider errors, failures, and mutations cleanly.
class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.e(
      '🚨 Provider Error [${provider.name ?? provider.runtimeType}]: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Only log state transitions if provider is not noisy and in debug mode
    final name = provider.name ?? provider.runtimeType.toString();
    if (name.contains('Auth') || name.contains('Order') || name.contains('Wallet')) {
      AppLogger.d('🔄 Provider Updated [$name]');
    }
  }
}
