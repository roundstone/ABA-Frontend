import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/auth_entities.dart';
import '../logging/app_logger.dart';
import 'api_endpoints.dart';
import 'api_response.dart';

/// Interceptor that handles access token expiry (after 14 minutes) and 401 recovery
/// by exchanging refresh tokens (valid for 6 days) at [ApiEndpoints.auth.refresh].
class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required this.dio,
    required this.prefs,
    this.onSessionExpired,
  });

  final Dio dio;
  final SharedPreferences? prefs;
  final void Function(UserRole role)? onSessionExpired;

  static const _tokenKey = 'auth_access_token';
  static const _refreshKey = 'auth_refresh_token';
  static const _userKey = 'auth_user_data';
  static const _tokenTimestampKey = 'auth_token_timestamp';
  static const _refreshTokenTimestampKey = 'auth_refresh_token_timestamp';
  static const _lastKnownRoleKey = 'auth_last_known_role';

  /// Access token is valid for 14 minutes.
  static const Duration _accessTokenValidityDuration = Duration(minutes: 14);

  /// Refresh token is valid for 6 days.
  static const Duration _refreshTokenValidityDuration = Duration(days: 6);

  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Completer<String?>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;
    final isAuthEndpoint = path.contains('/auth/login') ||
        path.contains('/auth/signup') ||
        path.contains('/auth/refresh') ||
        path.contains('/auth/forgot-password') ||
        path.contains('/auth/reset-password');

    var token = prefs?.getString(_tokenKey);
    final refreshToken = prefs?.getString(_refreshKey);
    final tokenTimestamp = prefs?.getInt(_tokenTimestampKey);
    final refreshTimestamp = prefs?.getInt(_refreshTokenTimestampKey);

    if (!isAuthEndpoint && token != null && token.isNotEmpty) {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        // 1. Check if refresh token has expired (6 days)
        if (refreshTimestamp != null) {
          final refreshAge = DateTime.now().millisecondsSinceEpoch - refreshTimestamp;
          if (refreshAge >= _refreshTokenValidityDuration.inMilliseconds) {
            AppLogger.w('Refresh token expired after 6 days (${(refreshAge / 86400000).toStringAsFixed(1)} days). Re-auth required.');
            final role = _resolveUserRole();
            await _clearSession();
            onSessionExpired?.call(role);
            return handler.next(options);
          }
        }

        // 2. Check if access token has elapsed 14 minutes since generation/refresh
        if (tokenTimestamp != null) {
          final age = DateTime.now().millisecondsSinceEpoch - tokenTimestamp;
          if (age >= _accessTokenValidityDuration.inMilliseconds) {
            AppLogger.i('Access token is older than 14 minutes (${(age / 60000).toStringAsFixed(1)} mins). Proactively refreshing...');
            final refreshed = await _performTokenRefresh(refreshToken, token);
            if (refreshed != null && refreshed.isNotEmpty) {
              token = refreshed;
            }
          }
        }
      }

      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;
    final isAuthEndpoint = path.contains('/auth/login') ||
        path.contains('/auth/signup') ||
        path.contains('/auth/refresh') ||
        path.contains('/auth/forgot-password') ||
        path.contains('/auth/reset-password');

    final refreshToken = prefs?.getString(_refreshKey);
    final refreshTimestamp = prefs?.getInt(_refreshTokenTimestampKey);
    final role = _resolveUserRole();
    final hadSession = (prefs?.getString(_tokenKey)?.isNotEmpty ?? false) ||
        (refreshToken != null && refreshToken.isNotEmpty);

    if (statusCode == 401 && !isAuthEndpoint && refreshToken != null && refreshToken.isNotEmpty) {
      // Check if refresh token is within 6 days
      if (refreshTimestamp != null) {
        final refreshAge = DateTime.now().millisecondsSinceEpoch - refreshTimestamp;
        if (refreshAge >= _refreshTokenValidityDuration.inMilliseconds) {
          AppLogger.w('Cannot refresh on 401: Refresh token has expired after 6 days.');
          await _clearSession();
          if (hadSession) onSessionExpired?.call(role);
          return handler.next(err);
        }
      }

      AppLogger.w('Received 401 Unauthorized for $path. Attempting token refresh...');
      final currentToken = prefs?.getString(_tokenKey) ?? '';
      final newToken = await _performTokenRefresh(refreshToken, currentToken);

      if (newToken != null && newToken.isNotEmpty) {
        final reqOptions = err.requestOptions;
        reqOptions.headers['Authorization'] = 'Bearer $newToken';

        try {
          final retryResponse = await dio.fetch(reqOptions);
          return handler.resolve(retryResponse);
        } on DioException catch (retryErr) {
          if (retryErr.response?.statusCode == 401) {
            await _clearSession();
            if (hadSession) onSessionExpired?.call(role);
          }
          return handler.next(retryErr);
        }
      } else {
        await _clearSession();
        if (hadSession) onSessionExpired?.call(role);
      }
    } else if (statusCode == 401 && !isAuthEndpoint) {
      await _clearSession();
      if (hadSession) onSessionExpired?.call(role);
    }

    return handler.next(err);
  }

  UserRole _resolveUserRole() {
    final rawUser = prefs?.getString(_userKey);
    if (rawUser != null && rawUser.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawUser);
        if (decoded is Map<String, dynamic>) {
          return UserRole.fromString(decoded['role'] as String?);
        }
      } catch (_) {}
    }
    final lastKnown = prefs?.getString(_lastKnownRoleKey);
    if (lastKnown != null && lastKnown.isNotEmpty) {
      return UserRole.fromString(lastKnown);
    }
    return UserRole.customer;
  }

  Future<void> _clearSession() async {
    if (prefs != null) {
      await prefs!.remove(_tokenKey);
      await prefs!.remove(_refreshKey);
      await prefs!.remove(_tokenTimestampKey);
      await prefs!.remove(_refreshTokenTimestampKey);
      await prefs!.remove(_userKey);
    }
  }

  Future<String?> _performTokenRefresh(String refreshToken, String currentToken) async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    try {
      final res = await _refreshDio.post(
        ApiEndpoints.auth.refresh,
        data: {'refresh_token': refreshToken},
      );

      final data = ApiResponse.unwrapMap(res.data);
      final newAccess = (data['access_token'] ?? data['token']) as String?;
      final newRefresh = data['refresh_token'] as String?;

      if (newAccess != null && newAccess.isNotEmpty) {
        if (prefs != null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          await prefs!.setString(_tokenKey, newAccess);
          await prefs!.setInt(_tokenTimestampKey, now);
          if (newRefresh != null && newRefresh.isNotEmpty) {
            await prefs!.setString(_refreshKey, newRefresh);
            await prefs!.setInt(_refreshTokenTimestampKey, now);
          }
        }
        AppLogger.i('Token refresh successful');
        _refreshCompleter?.complete(newAccess);
        return newAccess;
      }

      _refreshCompleter?.complete(null);
      return null;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to refresh token: $e', error: e, stackTrace: stackTrace);
      _refreshCompleter?.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }
}
