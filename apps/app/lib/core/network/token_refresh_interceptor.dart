import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logging/app_logger.dart';
import 'api_endpoints.dart';
import 'api_response.dart';

/// Interceptor that handles access token expiry (after 1 hour) and 401 recovery
/// by exchanging refresh tokens at [ApiEndpoints.auth.refresh].
class TokenRefreshInterceptor extends QueuedInterceptor {
  TokenRefreshInterceptor({
    required this.dio,
    required this.prefs,
  });

  final Dio dio;
  final SharedPreferences? prefs;

  static const _tokenKey = 'auth_access_token';
  static const _refreshKey = 'auth_refresh_token';
  static const _tokenTimestampKey = 'auth_token_timestamp';
  static const Duration _tokenValidityDuration = Duration(hours: 1);

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

    if (!isAuthEndpoint && token != null && token.isNotEmpty) {
      // Check if 1 hour has elapsed since last token generation/refresh
      if (tokenTimestamp != null && refreshToken != null && refreshToken.isNotEmpty) {
        final age = DateTime.now().millisecondsSinceEpoch - tokenTimestamp;
        if (age >= _tokenValidityDuration.inMilliseconds) {
          AppLogger.i('Token is older than 1 hour (${(age / 60000).toStringAsFixed(1)} mins). Proactively refreshing...');
          final refreshed = await _performTokenRefresh(refreshToken, token);
          if (refreshed != null && refreshed.isNotEmpty) {
            token = refreshed;
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
        path.contains('/auth/refresh');

    final refreshToken = prefs?.getString(_refreshKey);

    if (statusCode == 401 && !isAuthEndpoint && refreshToken != null && refreshToken.isNotEmpty) {
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
          return handler.next(retryErr);
        }
      }
    }

    return handler.next(err);
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
        options: Options(
          headers: {
            if (currentToken.isNotEmpty) 'Authorization': 'Bearer $currentToken',
          },
        ),
      );

      final data = ApiResponse.unwrapMap(res.data);
      final newAccess = (data['access_token'] ?? data['token']) as String?;
      final newRefresh = data['refresh_token'] as String?;

      if (newAccess != null && newAccess.isNotEmpty) {
        if (prefs != null) {
          await prefs!.setString(_tokenKey, newAccess);
          await prefs!.setInt(_tokenTimestampKey, DateTime.now().millisecondsSinceEpoch);
          if (newRefresh != null && newRefresh.isNotEmpty) {
            await prefs!.setString(_refreshKey, newRefresh);
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
