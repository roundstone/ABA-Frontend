import 'package:app/core/logging/app_logger.dart';
import 'package:app/core/logging/log_sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogSanitizer Tests', () {
    test('masks sensitive keys in Map', () {
      final input = {
        'email': 'user@example.com',
        'password': 'SuperSecretPassword123!',
        'confirm_password': 'SuperSecretPassword123!',
        'access_token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        'refresh_token': 'refresh-secret-123',
        'pin': '1234',
        'card_number': '5199112233445566',
        'bvn': '22334455667',
        'nested': {
          'token': 'secret-sub-token',
          'public_info': 'storefront-item',
        },
      };

      final sanitized = LogSanitizer.sanitize(input) as Map<String, dynamic>;

      expect(sanitized['email'], equals('user@example.com'));
      expect(sanitized['password'], equals('[REDACTED]'));
      expect(sanitized['confirm_password'], equals('[REDACTED]'));
      expect(sanitized['access_token'], equals('[REDACTED]'));
      expect(sanitized['refresh_token'], equals('[REDACTED]'));
      expect(sanitized['pin'], equals('[REDACTED]'));
      expect(sanitized['card_number'], equals('****5566'));
      expect(sanitized['bvn'], equals('****5667'));

      final nested = sanitized['nested'] as Map<String, dynamic>;
      expect(nested['token'], equals('[REDACTED]'));
      expect(nested['public_info'], equals('storefront-item'));
    });

    test('masks Authorization Bearer tokens in strings', () {
      const raw = 'Request header: Bearer abc123def456.xyz789';
      final clean = LogSanitizer.sanitizeString(raw);
      expect(clean, contains('Bearer [REDACTED_TOKEN]'));
      expect(clean, isNot(contains('abc123def456')));
    });

    test('masks URL query parameters containing tokens or passwords', () {
      const url = 'https://api.buynaija.ng/v1/auth?token=super-secret&foo=bar&password=mypass';
      final clean = LogSanitizer.sanitizeString(url);
      expect(clean, contains('token=[REDACTED]'));
      expect(clean, contains('password=[REDACTED]'));
      expect(clean, contains('foo=bar'));
    });

    test('sanitizes headers dictionary', () {
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer test-token-value',
        'x-api-key': 'secret-api-key',
      };

      final clean = LogSanitizer.sanitizeHeaders(headers);
      expect(clean['Accept'], equals('application/json'));
      expect(clean['Authorization'], equals('[REDACTED]'));
      expect(clean['x-api-key'], equals('[REDACTED]'));
    });
  });

  group('AppLogger Tests', () {
    setUpAll(() {
      AppLogger.initialize();
    });

    test('can log messages without throwing', () {
      expect(() => AppLogger.d('Test debug message'), returnsNormally);
      expect(() => AppLogger.i('Test info message'), returnsNormally);
      expect(() => AppLogger.w('Test warning message'), returnsNormally);
      expect(
        () => AppLogger.e(
          'Test error message',
          error: Exception('Test exception with password=secret'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });

    test('logRequest and logResponse sanitize data safely', () {
      expect(
        () => AppLogger.logRequest(
          method: 'POST',
          url: 'https://api.buynaija.ng/v1/auth/signup',
          headers: {'Authorization': 'Bearer secret'},
          body: {
            'email': 'test@example.com',
            'password': 'plain_password',
          },
        ),
        returnsNormally,
      );

      expect(
        () => AppLogger.logResponse(
          method: 'POST',
          url: 'https://api.buynaija.ng/v1/auth/signup',
          statusCode: 200,
          durationMs: 150,
          data: {'access_token': 'jwt_token_here', 'user': {'id': '1'}},
        ),
        returnsNormally,
      );
    });
  });
}
