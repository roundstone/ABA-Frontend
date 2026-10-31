import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/network/api_error.dart';

void main() {
  group('ApiError User Friendly Sanitization Tests', () {
    test('sanitizes raw Dio 404 badResponse developer paragraph', () {
      const rawDioVerboseMessage =
          'This exception was thrown because the response has a status code of 404 and '
          'RequestOptions.validateStatus was configured to throw for this status code. '
          'The status code of 404 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled" '
          'Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status '
          'In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.';

      final dioException = DioException(
        requestOptions: RequestOptions(path: '/api/v1/order/mobile-app'),
        type: DioExceptionType.badResponse,
        message: rawDioVerboseMessage,
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/order/mobile-app'),
          statusCode: 404,
          data: '<html><body>404 Not Found</body></html>',
        ),
      );

      final apiError = ApiError.fromDio(dioException);
      expect(apiError.message, isNot(contains('RequestOptions')));
      expect(apiError.message, isNot(contains('validateStatus')));
      expect(apiError.message, isNot(contains('developer.mozilla.org')));
      expect(apiError.message, isNot(contains('This exception was thrown')));
      expect(apiError.message, equals('The requested item or service could not be found. Please try again.'));

      final friendlyMsg = ApiError.toUserFriendlyMessage(dioException);
      expect(friendlyMsg, equals('The requested item or service could not be found. Please try again.'));
    });

    test('sanitizes framework Cannot POST / Cannot GET routes', () {
      final jsonResponse = {
        'statusCode': 404,
        'message': 'Cannot POST /api/v1/orders/mobile-app',
        'error': 'Not Found',
      };

      final error = ApiError.fromJson(jsonResponse);
      expect(error.message, isNot(contains('Cannot POST')));
      expect(error.message, equals('The requested item or service could not be found. Please try again.'));
    });

    test('retains genuine human readable server messages', () {
      final jsonResponse = {
        'statusCode': 400,
        'message': 'Selected delivery address does not exist',
        'error': 'Bad Request',
      };

      final error = ApiError.fromJson(jsonResponse);
      expect(error.message, equals('Selected delivery address does not exist'));
    });

    test('provides clean fallback for 500 server errors', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/checkout'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/checkout'),
          statusCode: 500,
          data: 'Internal server error stacktrace',
        ),
      );

      final friendly = ApiError.toUserFriendlyMessage(dioException);
      expect(friendly, equals('Our server is temporarily unavailable. Please try again in a few moments.'));
    });
  });
}

