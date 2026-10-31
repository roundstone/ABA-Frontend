import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_snackbar.dart';

final networkConnectivityProvider = Provider<NetworkConnectivityNotifier>((ref) {
  final notifier = NetworkConnectivityNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Listens to device connectivity state and shows an [AppSnackbar] ONLY when
/// the network status transitions in the course of using the app (never on restart).
class NetworkConnectivityNotifier {
  NetworkConnectivityNotifier({
    Connectivity? connectivity,
    Duration startupGracePeriod = const Duration(seconds: 2),
  })  : _connectivity = connectivity ?? Connectivity(),
        _startupGracePeriod = startupGracePeriod {
    _init();
  }

  /// Global flag reflecting whether the device is currently offline.
  static bool isOffline = false;

  final Connectivity _connectivity;
  final Duration _startupGracePeriod;
  final DateTime _initTime = DateTime.now();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _initialized = false;
  bool _wasOffline = false;

  Future<void> _init() async {
    try {
      final initial = await _connectivity.checkConnectivity();
      final offline = _isResultsOffline(initial);
      isOffline = offline;
      _wasOffline = offline;
      _initialized = true;
    } catch (_) {
      _initialized = true;
    }

    _subscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChanged);
  }

  bool _isResultsOffline(List<ConnectivityResult> results) {
    return results.isEmpty || results.every((r) => r == ConnectivityResult.none);
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) {
    final offline = _isResultsOffline(results);
    isOffline = offline;

    // Suppress popups during initial startup grace period or before baseline check
    if (!_initialized || DateTime.now().difference(_initTime) < _startupGracePeriod) {
      _wasOffline = offline;
      return;
    }

    // Only alert when the connectivity status actually changes while using the app:
    if (offline && !_wasOffline) {
      _wasOffline = true;
      AppSnackbar.errorGlobal('No internet connection. Please check your network.');
    } else if (!offline && _wasOffline) {
      _wasOffline = false;
      AppSnackbar.successGlobal('Internet connection restored.');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
