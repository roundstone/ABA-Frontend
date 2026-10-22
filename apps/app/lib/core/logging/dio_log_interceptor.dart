import 'package:dio/dio.dart';
import 'app_logger.dart';

/// Dio interceptor that safely logs HTTP traffic using [AppLogger].
/// Automatically sanitizes tokens, passwords, card numbers, and PII from request/response bodies.
class DioLogInterceptor extends Interceptor {
  DioLogInterceptor();

  static const _startTimeExtraKey = 'dio_request_start_time';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startTimeExtraKey] = DateTime.now().millisecondsSinceEpoch;

    AppLogger.logRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers,
      queryParameters: options.queryParameters,
      body: options.data,
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra[_startTimeExtraKey] as int?;
    final durationMs = startTime != null
        ? DateTime.now().millisecondsSinceEpoch - startTime
        : null;

    AppLogger.logResponse(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      statusCode: response.statusCode,
      durationMs: durationMs,
      data: response.data,
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    AppLogger.logHttpError(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      statusCode: response?.statusCode,
      message: err.message ?? err.error?.toString() ?? 'Network error',
      responseData: response?.data,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
