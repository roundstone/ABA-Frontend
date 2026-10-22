import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'log_sanitizer.dart';

/// Global enterprise logger for BUYNAIJA mobile app.
/// Configured for both development and production use with built-in PII/credential sanitization.
class AppLogger {
  AppLogger._();

  static late final Logger _logger;
  static bool _initialized = false;

  /// Initialize the logger. Called during app bootstrap.
  static void initialize({Level? overrideLevel}) {
    if (_initialized) return;

    final Level level = overrideLevel ??
        (kReleaseMode ? Level.warning : (kDebugMode ? Level.debug : Level.info));

    final LogPrinter printer = kReleaseMode
        ? SimplePrinter(printTime: true, colors: false)
        : PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 90,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
            levelColors: {
              Level.trace: const AnsiColor.fg(8), // Dim Grey
              Level.debug: const AnsiColor.fg(6), // Cyan (Requests & Debug)
              Level.info: const AnsiColor.fg(2), // Green (Responses & Info)
              Level.warning: const AnsiColor.fg(3), // Amber/Yellow (Warnings)
              Level.error: const AnsiColor.fg(1), // Bright Red (Errors)
              Level.fatal: const AnsiColor.fg(5), // Magenta (Fatal/Critical)
            },
            levelEmojis: {
              Level.trace: '🔍',
              Level.debug: '🌐',
              Level.info: '✅',
              Level.warning: '⚠️',
              Level.error: '❌',
              Level.fatal: '💥',
            },
          );

    _logger = Logger(
      filter: _AppLogFilter(minLevel: level),
      printer: printer,
      output: ConsoleOutput(),
    );

    _initialized = true;
  }

  static Logger get instance {
    if (!_initialized) {
      initialize();
    }
    return _logger;
  }

  /// Trace level logging (fine-grained diagnostic information)
  static void t(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.t(_prepare(message), error: _sanitizeError(error), stackTrace: stackTrace);
  }

  /// Debug level logging (development details)
  static void d(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.d(_prepare(message), error: _sanitizeError(error), stackTrace: stackTrace);
  }

  /// Info level logging (normal lifecycle events, navigation, confirmations)
  static void i(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.i(_prepare(message), error: _sanitizeError(error), stackTrace: stackTrace);
  }

  /// Warning level logging (recoverable issues, fallback handling, slow requests)
  static void w(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.w(_prepare(message), error: _sanitizeError(error), stackTrace: stackTrace);
  }

  /// Error level logging (exceptions, failed requests, validation rejections)
  static void e(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.e(_prepare(message), error: _sanitizeError(error), stackTrace: stackTrace);
  }

  /// Fatal level logging (critical failures requiring app restart or crash reporting)
  static void f(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.f(_prepare(message), error: _sanitizeError(error), stackTrace: stackTrace);
  }

  /// Sanitized network request log helper
  static void logRequest({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic queryParameters,
    dynamic body,
  }) {
    if (kReleaseMode) return; // Do not emit verbose request payloads in release
    final cleanUrl = LogSanitizer.sanitizeString(url);
    final cleanHeaders = headers != null ? LogSanitizer.sanitizeHeaders(headers) : null;
    final cleanParams = LogSanitizer.sanitize(queryParameters);
    final cleanBody = LogSanitizer.sanitize(body);

    d(
      'HTTP REQUEST [$method] $cleanUrl\n'
      'Headers: $cleanHeaders\n'
      'Query: $cleanParams\n'
      'Body: $cleanBody',
    );
  }

  /// Sanitized network response log helper
  static void logResponse({
    required String method,
    required String url,
    required int? statusCode,
    int? durationMs,
    dynamic data,
  }) {
    if (kReleaseMode) return; // In release, only log errors or warnings
    final cleanUrl = LogSanitizer.sanitizeString(url);
    final cleanData = LogSanitizer.sanitize(data);
    final latency = durationMs != null ? ' (${durationMs}ms)' : '';

    if (statusCode != null && statusCode >= 400) {
      w('HTTP RESPONSE [$method $statusCode$latency] $cleanUrl\nData: $cleanData');
    } else {
      i('HTTP RESPONSE [$method ${statusCode ?? 200}$latency] $cleanUrl\nData: $cleanData');
    }
  }

  /// Sanitized network error log helper
  static void logHttpError({
    required String method,
    required String url,
    required int? statusCode,
    required String message,
    dynamic responseData,
    StackTrace? stackTrace,
  }) {
    final cleanUrl = LogSanitizer.sanitizeString(url);
    final cleanData = LogSanitizer.sanitize(responseData);

    e(
      'HTTP ERROR [$method ${statusCode ?? 'NO_CODE'}] $cleanUrl\n'
      'Message: $message\n'
      'Response: $cleanData',
      stackTrace: stackTrace,
    );
  }

  static dynamic _prepare(dynamic message) {
    if (message is String) {
      return LogSanitizer.sanitizeString(message);
    }
    return LogSanitizer.sanitize(message);
  }

  static Object? _sanitizeError(Object? error) {
    if (error == null) return null;
    if (error is String) {
      return LogSanitizer.sanitizeString(error);
    }
    return LogSanitizer.sanitize(error);
  }
}

/// Custom log filter that respects release/debug modes and minimum log levels.
class _AppLogFilter extends LogFilter {
  _AppLogFilter({required this.minLevel});

  final Level minLevel;

  @override
  bool shouldLog(LogEvent event) {
    // If the event level is greater than or equal to minimum configured level, log it
    return event.level.value >= minLevel.value;
  }
}

/// Riverpod provider for dependency-injected logging.
final loggerProvider = Provider<Logger>((ref) {
  return AppLogger.instance;
});
