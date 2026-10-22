import 'dart:convert';

/// Utility class to sanitize sensitive information before logging to console or telemetry.
class LogSanitizer {
  LogSanitizer._();

  static final Set<String> _sensitiveKeyPatterns = {
    'password',
    'confirmpassword',
    'confirm_password',
    'newpassword',
    'new_password',
    'oldpassword',
    'old_password',
    'token',
    'accesstoken',
    'access_token',
    'refreshtoken',
    'refresh_token',
    'authorization',
    'auth',
    'secret',
    'secretkey',
    'secret_key',
    'apikey',
    'api_key',
    'pin',
    'transactionpin',
    'transaction_pin',
    'cvv',
    'cvc',
    'cardnumber',
    'card_number',
    'pan',
    'bvn',
    'nin',
    'ssn',
    'cookie',
    'session',
    'sessionid',
  };

  /// Sanitizes arbitrary data (Map, List, String, or other objects).
  static dynamic sanitize(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      final sanitizedMap = <String, dynamic>{};
      data.forEach((key, value) {
        final keyStr = key.toString();
        final normalizedKey = keyStr.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

        if (_isSensitiveKey(normalizedKey)) {
          sanitizedMap[keyStr] = _maskValue(keyStr, value);
        } else {
          sanitizedMap[keyStr] = sanitize(value);
        }
      });
      return sanitizedMap;
    }

    if (data is Iterable) {
      return data.map((item) => sanitize(item)).toList();
    }

    if (data is String) {
      return sanitizeString(data);
    }

    return data;
  }

  /// Sanitizes a string that may contain json, URLs, or Authorization tokens.
  static String sanitizeString(String text) {
    if (text.isEmpty) return text;

    // Check if string is a JSON string
    final trimmed = text.trim();
    if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
      try {
        final decoded = jsonDecode(trimmed);
        final sanitized = sanitize(decoded);
        return jsonEncode(sanitized);
      } catch (_) {
        // Not valid JSON, continue with regex sanitization
      }
    }

    var result = text;

    // Sanitize Bearer tokens: Bearer <token>
    result = result.replaceAllMapped(
      RegExp(r'(Bearer\s+)[A-Za-z0-9\-_.]+', caseSensitive: false),
      (match) => '${match.group(1)}[REDACTED_TOKEN]',
    );

    // Sanitize query parameters like ?token=... or &password=...
    result = result.replaceAllMapped(
      RegExp(
        r'([?&](?:token|access_token|refresh_token|password|pin|secret|api_key)=)[^&\s]+',
        caseSensitive: false,
      ),
      (match) => '${match.group(1)}[REDACTED]',
    );

    return result;
  }

  /// Sanitizes HTTP headers.
  static Map<String, dynamic> sanitizeHeaders(Map<String, dynamic> headers) {
    final clean = <String, dynamic>{};
    headers.forEach((key, value) {
      final k = key.toLowerCase();
      if (k == 'authorization' || k == 'cookie' || k == 'x-api-key') {
        clean[key] = '[REDACTED]';
      } else {
        clean[key] = sanitize(value);
      }
    });
    return clean;
  }

  static bool _isSensitiveKey(String normalizedKey) {
    for (final pattern in _sensitiveKeyPatterns) {
      if (normalizedKey == pattern || normalizedKey.contains(pattern)) {
        return true;
      }
    }
    return false;
  }

  static dynamic _maskValue(String key, dynamic value) {
    if (value == null) return null;
    final strVal = value.toString();
    if (strVal.isEmpty) return '';

    final lowerKey = key.toLowerCase();

    // Partial masking for account or card numbers if they are 10+ digits
    if ((lowerKey.contains('card') || lowerKey.contains('account') || lowerKey.contains('bvn') || lowerKey.contains('nin')) &&
        strVal.length >= 8) {
      final last4 = strVal.substring(strVal.length - 4);
      return '****$last4';
    }

    return '[REDACTED]';
  }
}
