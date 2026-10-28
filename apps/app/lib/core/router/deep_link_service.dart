import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../logging/app_logger.dart';

/// Parsed representation of an incoming or simulated deep link.
class DeepLinkResult {
  const DeepLinkResult({
    required this.rawUrl,
    required this.path,
    this.queryParams = const {},
  });

  final String rawUrl;
  final String path;
  final Map<String, String> queryParams;

  String get fullRoute {
    if (queryParams.isEmpty) return path;
    final query = Uri(queryParameters: queryParams).query;
    return '$path?$query';
  }
}

/// Central service for parsing, normalising, and simulating deep links.
class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  static const List<String> supportedHosts = [
    'app.abaerp.com',
    'abaerp.com',
    'www.abaerp.com',
  ];

  static const List<String> supportedSchemes = [
    'https',
    'http',
    'abaerp',
    'buynaija',
  ];

  static const List<String> sampleResetTokens = [
    '0001',
    '0002',
    '0003',
    '0004',
  ];

  /// Preset URLs for manual and automated simulation.
  static List<String> get presetTestUrls => [
        'https://app.abaerp.com/reset-password?token=0001',
        'https://app.abaerp.com/reset-password?token=0002',
        'https://app.abaerp.com/reset-password?token=0003',
        'https://app.abaerp.com/reset-password?token=0004',
        'abaerp://reset-password?token=0001',
        'https://app.abaerp.com/shop',
        'https://app.abaerp.com/merchants',
      ];

  /// Parses a given URL string into an in-app route and query parameters.
  DeepLinkResult parseDeepLink(String urlString) {
    final trimmed = urlString.trim();
    if (trimmed.isEmpty) {
      return const DeepLinkResult(rawUrl: '', path: '/home');
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return DeepLinkResult(rawUrl: trimmed, path: '/home');
    }

    String path = uri.path;

    // Handle custom schemes like abaerp://reset-password?token=0001
    // where URI parser treats 'reset-password' as host instead of path.
    if ((uri.scheme == 'abaerp' || uri.scheme == 'buynaija') && path.isEmpty) {
      if (uri.host.isNotEmpty && !supportedHosts.contains(uri.host)) {
        path = '/${uri.host}';
      }
    }

    if (!path.startsWith('/')) {
      path = '/$path';
    }

    return DeepLinkResult(
      rawUrl: trimmed,
      path: path,
      queryParams: uri.queryParameters,
    );
  }

  /// Programmatically opens a deep link inside the app using GoRouter.
  bool handleDeepLink(BuildContext context, String urlString) {
    try {
      final result = parseDeepLink(urlString);
      AppLogger.i('DeepLinkService: Routing to ${result.fullRoute}');
      GoRouter.of(context).go(result.fullRoute);
      return true;
    } catch (e) {
      AppLogger.e('DeepLinkService: Failed to handle link "$urlString"', error: e);
      return false;
    }
  }
}
