import 'package:dio/dio.dart';

class ApiError implements Exception {
  const ApiError({
    required this.statusCode,
    required this.message,
    this.rawDetails,
  });

  final int statusCode;
  final String message;
  final dynamic rawDetails;

  @override
  String toString() => message;

  factory ApiError.fromJson(Map<String, dynamic> json, {int defaultStatusCode = 500}) {
    final code = (json['statusCode'] as num?)?.toInt() ?? defaultStatusCode;
    final rawMsg = json['message'];
    String parsedMessage = 'An unexpected error occurred ($code).';

    if (rawMsg is String && rawMsg.trim().isNotEmpty) {
      parsedMessage = rawMsg.trim();
    } else if (rawMsg is List && rawMsg.isNotEmpty) {
      parsedMessage = rawMsg.map((e) => e.toString()).join('\n');
    }

    return ApiError(
      statusCode: code,
      message: parsedMessage,
      rawDetails: json,
    );
  }

  factory ApiError.fromDio(DioException e) {
    if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
      return ApiError.fromJson(
        e.response!.data as Map<String, dynamic>,
        defaultStatusCode: e.response!.statusCode ?? 500,
      );
    }

    final code = e.response?.statusCode ?? 500;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiError(
          statusCode: 408,
          message: 'Connection timed out. Please check your internet connection.',
        );
      case DioExceptionType.connectionError:
        return const ApiError(
          statusCode: 503,
          message: 'Unable to reach the server. Please verify your internet connection.',
        );
      case DioExceptionType.badResponse:
        return ApiError(
          statusCode: code,
          message: e.message ?? 'Server responded with error status $code.',
        );
      default:
        return ApiError(
          statusCode: code,
          message: e.message ?? 'A network communication error occurred.',
        );
    }
  }
}
