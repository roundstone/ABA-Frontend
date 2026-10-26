import 'package:app/core/network/token_refresh_interceptor.dart';
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
      SharedPreferences.setMockInitialValues({
        'auth_access_token': 'some-access-token',
        'auth_refresh_token': 'expired-refresh-token',
        'auth_token_timestamp':
            DateTime.now().subtract(const Duration(minutes: 10)).millisecondsSinceEpoch,
        // 7 days ago
        'auth_refresh_token_timestamp':
            DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch,
      });

      final prefs = await SharedPreferences.getInstance();
      final dio = Dio();
      final interceptor = TokenRefreshInterceptor(dio: dio, prefs: prefs);

      final options = RequestOptions(path: '/api/v1/products');
      final handler = _TestRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(handler.forwardedOptions, isNotNull);
      // Expired tokens should be removed
      expect(prefs.getString('auth_access_token'), isNull);
      expect(prefs.getString('auth_refresh_token'), isNull);
    });
  });
}
