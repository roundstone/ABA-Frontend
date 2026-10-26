import 'dart:core';

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
  final String message; // can be a String or a List<String>
  final String? timestamp;
  final dynamic rawDetails;

  @override
  String toString() => message;

  factory ApiError.fromJson(
    Map<String, dynamic> json, {
    int defaultStatusCode = 500,
  }) {
    final code = (json['statusCode'] as num?)?.toInt() ?? defaultStatusCode;
    final rawMsg = json['message'];
    final success = json['success'] as bool? ?? false;
    final timestamp = json['timestamp'] as String?;

    String parsedMessage = 'An unexpected error occurred ($code).';

    if (rawMsg is String && rawMsg.trim().isNotEmpty) {
      parsedMessage = rawMsg.trim();
    } else if (rawMsg is List && rawMsg.isNotEmpty) {
      parsedMessage = rawMsg.map((e) => e.toString()).join('\n');
    }

    return ApiError(
      statusCode: code,
      message: parsedMessage,
      success: success,
      timestamp: timestamp,
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
              'Unable to reach the server. Please verify your internet connection.',
        );
      case DioExceptionType.badResponse:
        return ApiError(
          success: false,
          statusCode: code,
          message: e.message ?? 'Server responded with error status $code.',
        );
      default:
        return ApiError(
          success: false,
          statusCode: code,
          message: e.message ?? 'A network communication error occurred.',
        );
    }
  }
}
