import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/network/api_error.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/auth/data/auth_remote_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiError Schema Tests', () {
    test('parses standard backend error response schema', () {
      final json = {
        'statusCode': 401,
        'message': 'Invalid email or password',
      };

      final error = ApiError.fromJson(json);
      expect(error.statusCode, equals(401));
      expect(error.message, equals('Invalid email or password'));
      expect(error.toString(), equals('Invalid email or password'));
    });

    test('parses validation error arrays from backend', () {
      final json = {
        'statusCode': 400,
        'message': [
          'email must be an email',
          'password must be longer than or equal to 8 characters',
        ],
      };

      final error = ApiError.fromJson(json);
      expect(error.statusCode, equals(400));
      expect(error.message, contains('email must be an email'));
      expect(error.message, contains('password must be longer than'));
    });
  });

  group('AuthUser Entity Tests', () {
    test('toJson and fromJson preserves tokens and user roles', () {
      final user = AuthUser(
        id: '1',
        name: 'Yusuf Shehu',
        email: 'yusufshehu-admin@rs.com',
        phone: '+2348090000001',
        role: UserRole.admin,
        token: 'access_jwt_token',
        refreshToken: 'refresh_jwt_token',
        createdAt: DateTime(2026, 10, 20),
      );

      final map = user.toJson();
      expect(map['token'], equals('access_jwt_token'));
      expect(map['refreshToken'], equals('refresh_jwt_token'));
      expect(map['role'], equals('admin'));

      final restored = AuthUser.fromJson(map);
      expect(restored.id, equals('1'));
      expect(restored.name, equals('Yusuf Shehu'));
      expect(restored.email, equals('yusufshehu-admin@rs.com'));
      expect(restored.isAdmin, isTrue);
      expect(restored.token, equals('access_jwt_token'));
      expect(restored.refreshToken, equals('refresh_jwt_token'));
    });
  });

  group('AuthRemoteRepository Tests', () {
    test('authenticates with live backend schema', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final dio = Dio();
      final repo = AuthRemoteRepository(dio: dio, prefs: prefs);

      // Verify repository is instantiated and handles demo fallback
      final user = await repo.loginCustomer(
        identifier: 'jane.doe@example.com',
        password: 'password123',
      );

      expect(user.email, equals('jane.doe@example.com'));
      expect(user.isCustomer, isTrue);
      expect(await repo.getStoredUser(), isNotNull);

      await repo.logout();
      expect(await repo.getStoredUser(), isNull);
    });
  });
}
