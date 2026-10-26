import 'sort_direction.dart';

/// Formatting and parsing utilities for API query parameters.
abstract final class QueryParamHelpers {
  /// Formats a [DateTime] into a standard date string `YYYY-MM-DD`.
  static String formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Parses a date from a [DateTime] or date/ISO string.
  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) return DateTime.tryParse(value.trim());
    return null;
  }

  /// Builds a sort expression in `field:DIRECTION` format (e.g. "createdAt:DESC").
  static String formatOrderBy(String field, [SortDirection direction = SortDirection.desc]) =>
      '${field.trim()}:${direction.value}';

  /// Parses integer with fallback.
  static int parseInt(dynamic value, int fallback) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  /// Parses nullable integer.
  static int? parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  /// Parses boolean from boolean, string ('true', 'false', '1', '0') or number.
  static bool? parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final s = value.toLowerCase().trim();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    if (value is num) return value == 1;
    return null;
  }

  /// Shallow map equality check.
  static bool mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }
}
