import 'package:dio/dio.dart';

class ApiError implements Exception {
  const ApiError({
    required this.success,
    required this.statusCode,
    required this.message,
    this.timestamp,
    this.rawDetails,
  });

  final bool success;
  final int statusCode;
  final String message;
  final String? timestamp;
  final dynamic rawDetails;

  @override
  String toString() => message;

  /// Returns a clean, user-friendly explanation for common HTTP status codes.
  static String userFriendlyForStatus(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check the information provided and try again.';
      case 401:
        return 'Your session has expired. Please log in again to continue.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested item or service could not be found. Please try again.';
      case 408:
        return 'Request timed out. Please check your internet connection and try again.';
      case 409:
        return 'A conflicting request was detected. Please refresh and try again.';
      case 422:
        return 'Unable to process your request. Please check the entered details.';
      case 429:
        return 'Too many requests. Please wait a moment before trying again.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Our server is temporarily unavailable. Please try again in a few moments.';
      default:
        return 'Something went wrong. Please check your connection and try again.';
    }
  }

  /// Strips technical debug/framework traces and returns a human-friendly string.
  static String sanitizeMessage(dynamic rawMsg, int statusCode) {
    if (rawMsg is String) {
      final trimmed = rawMsg.trim();
      final isTechnical = trimmed.isEmpty ||
          trimmed.startsWith('Cannot POST') ||
          trimmed.startsWith('Cannot GET') ||
          trimmed.startsWith('Cannot PATCH') ||
          trimmed.startsWith('Cannot DELETE') ||
          trimmed.contains('RequestOptions') ||
          trimmed.contains('validateStatus') ||
          trimmed.contains('developer.mozilla.org') ||
          trimmed.contains('This exception was thrown') ||
          trimmed.contains('SocketException') ||
          trimmed.contains('DioException') ||
          trimmed.contains('OS Error') ||
          trimmed.contains('<!DOCTYPE html>') ||
          trimmed.contains('<html');

      if (!isTechnical) {
        return trimmed;
      }
    } else if (rawMsg is List && rawMsg.isNotEmpty) {
      final joined = rawMsg.map((e) => e.toString()).join('\n').trim();
      if (joined.isNotEmpty && !joined.contains('<!DOCTYPE html>')) {
        return joined;
      }
    }

    return userFriendlyForStatus(statusCode);
  }

  /// Converts any caught error into a polite, user-friendly sentence.
  static String toUserFriendlyMessage(Object? error) {
    if (error == null) return 'An unexpected error occurred.';
    if (error is ApiError) return error.message;
    if (error is DioException) return ApiError.fromDio(error).message;
    final str = error.toString().replaceFirst('Exception: ', '').trim();
    return sanitizeMessage(str, 500);
  }

  factory ApiError.fromJson(
    Map<String, dynamic> json, {
    int defaultStatusCode = 500,
  }) {
    final code = (json['statusCode'] as num?)?.toInt() ?? defaultStatusCode;
    final rawMsg = json['message'] ?? json['error'];
    final success = json['success'] as bool? ?? false;
    final timestamp = json['timestamp'] as String?;

    final parsedMessage = sanitizeMessage(rawMsg, code);

    return ApiError(
      statusCode: code,
      message: parsedMessage,
      success: success,
      timestamp: timestamp,
      rawDetails: json,
    );
  }

  factory ApiError.fromDio(DioException e) {
    final code = e.response?.statusCode ?? 500;

    if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
      return ApiError.fromJson(
        e.response!.data as Map<String, dynamic>,
        defaultStatusCode: code,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiError(
          success: false,
          statusCode: 408,
          message:
              'Connection timed out. Please check your internet connection.',
        );
      case DioExceptionType.connectionError:
        return const ApiError(
          success: false,
          statusCode: 503,
          message:
              'Unable to connect to the server. Please check your network and try again.',
        );
      case DioExceptionType.cancel:
        return const ApiError(
          success: false,
          statusCode: 499,
          message: 'The operation was cancelled.',
        );
      case DioExceptionType.badResponse:
        return ApiError(
          success: false,
          statusCode: code,
          message: userFriendlyForStatus(code),
        );
      default:
        return ApiError(
          success: false,
          statusCode: code,
          message: userFriendlyForStatus(code),
        );
    }
  }
}
