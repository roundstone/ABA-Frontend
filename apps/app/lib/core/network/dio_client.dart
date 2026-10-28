import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logging/dio_log_interceptor.dart';
import '../providers/shared_preferences_provider.dart';
import 'api_endpoints.dart';

import '../../features/auth/application/session_expiration_coordinator.dart';
import 'token_refresh_interceptor.dart';

export 'api_endpoints.dart';
export 'api_error.dart';
export 'api_response.dart';
export 'list_query_params.dart';
export 'paginated_list_state.dart';
export 'sort_direction.dart';

final dioProvider = Provider<Dio>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    TokenRefreshInterceptor(
      dio: dio,
      prefs: prefs,
      onSessionExpired: (role) {
        ref
            .read(sessionExpirationCoordinatorProvider)
            .handleSessionExpired(role);
      },
    ),
    DioLogInterceptor(),
  ]);

  return dio;
});
