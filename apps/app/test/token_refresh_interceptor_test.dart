import 'dart:convert';
import 'package:app/core/network/token_refresh_interceptor.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestRequestHandler extends RequestInterceptorHandler {
  RequestOptions? forwardedOptions;

  @override
  void next(RequestOptions options) {
    forwardedOptions = options;
  }
}

class _TestErrorHandler extends ErrorInterceptorHandler {
  DioException? forwardedError;
  Response? resolvedResponse;

  @override
  void next(DioException err) {
    forwardedError = err;
  }

  @override
  void resolve(Response response) {
    resolvedResponse = response;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TokenRefreshInterceptor Tests', () {
    test('does not refresh when access token is younger than 14 minutes', () async {
      SharedPreferences.setMockInitialValues({
        'auth_access_token': 'valid-access-token',
        'auth_refresh_token': 'valid-refresh-token',
        // 5 minutes ago
        'auth_token_timestamp':
            DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch,
        'auth_refresh_token_timestamp':
            DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      });

      final prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      final interceptor = TokenRefreshInterceptor(dio: dio, prefs: prefs);

      final options = RequestOptions(path: '/api/v1/products');
      final handler = _TestRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(handler.forwardedOptions, isNotNull);
      expect(handler.forwardedOptions!.headers['Authorization'], 'Bearer valid-access-token');
      // Token was not changed
      expect(prefs.getString('auth_access_token'), 'valid-access-token');
    });

    test('clears session when refresh token is older than 6 days', () async {
      UserRole? expiredRole;
      SharedPreferences.setMockInitialValues({
        'auth_access_token': 'some-access-token',
        'auth_refresh_token': 'expired-refresh-token',
        'auth_token_timestamp':
            DateTime.now().subtract(const Duration(minutes: 10)).millisecondsSinceEpoch,
        // 7 days ago
        'auth_refresh_token_timestamp':
            DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch,
        'auth_user_data': jsonEncode({'role': 'merchant'}),
      });

      final prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      final interceptor = TokenRefreshInterceptor(
        dio: dio,
        prefs: prefs,
        onSessionExpired: (role) => expiredRole = role,
      );

      final options = RequestOptions(path: '/api/v1/products');
      final handler = _TestRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(handler.forwardedOptions, isNotNull);
      // Expired tokens should be removed
      expect(prefs.getString('auth_access_token'), isNull);
      expect(prefs.getString('auth_refresh_token'), isNull);
      expect(expiredRole, UserRole.merchant);
    });

    test('calls onSessionExpired with customer role when 401 occurs and refresh fails', () async {
      UserRole? expiredRole;
      SharedPreferences.setMockInitialValues({
        'auth_access_token': 'invalid-access-token',
        'auth_refresh_token': 'bad-refresh-token',
        'auth_token_timestamp': DateTime.now().millisecondsSinceEpoch,
        'auth_refresh_token_timestamp': DateTime.now().millisecondsSinceEpoch,
        'auth_user_data': jsonEncode({'role': 'customer'}),
      });

      final prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      final interceptor = TokenRefreshInterceptor(
        dio: dio,
        prefs: prefs,
        onSessionExpired: (role) => expiredRole = role,
      );

      final requestOptions = RequestOptions(path: '/api/v1/customer/profile');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      final errorHandler = _TestErrorHandler();
      await interceptor.onError(dioException, errorHandler);

      expect(expiredRole, UserRole.customer);
      expect(prefs.getString('auth_access_token'), isNull);
      expect(errorHandler.forwardedError, isNotNull);
    });

    test('calls onSessionExpired with merchant role when 401 occurs and no refresh token is present', () async {
      UserRole? expiredRole;
      SharedPreferences.setMockInitialValues({
        'auth_access_token': 'expired-token',
        'auth_user_data': jsonEncode({'role': 'merchant'}),
      });

      final prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      final interceptor = TokenRefreshInterceptor(
        dio: dio,
        prefs: prefs,
        onSessionExpired: (role) => expiredRole = role,
      );

      final requestOptions = RequestOptions(path: '/api/v1/merchant/products');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      final errorHandler = _TestErrorHandler();
      await interceptor.onError(dioException, errorHandler);

      expect(expiredRole, UserRole.merchant);
      expect(prefs.getString('auth_access_token'), isNull);
    });

    test('does NOT trigger onSessionExpired on 401 for auth endpoints like /auth/login', () async {
      UserRole? expiredRole;
      SharedPreferences.setMockInitialValues({
        'auth_user_data': jsonEncode({'role': 'customer'}),
      });

      final prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      final interceptor = TokenRefreshInterceptor(
        dio: dio,
        prefs: prefs,
        onSessionExpired: (role) => expiredRole = role,
      );

      final requestOptions = RequestOptions(path: '/api/v1/auth/login');
      final dioException = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      final errorHandler = _TestErrorHandler();
      await interceptor.onError(dioException, errorHandler);

      expect(expiredRole, isNull);
    });
  });
}

