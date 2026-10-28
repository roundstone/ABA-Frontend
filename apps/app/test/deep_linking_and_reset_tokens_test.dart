import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/router/deep_link_service.dart';
import 'package:app/core/router/widgets/deep_link_simulator_sheet.dart';
import 'package:app/features/auth/data/auth_mock_repository.dart';
import 'package:app/features/auth/data/auth_remote_repository.dart';
import 'package:app/features/auth/presentation/reset_password_screen.dart';

void main() {
  group('Deep Linking Service & URL Parsing Tests', () {
    final service = DeepLinkService.instance;

    test('Parses https://app.abaerp.com/reset-password with all tokens', () {
      const tokens = ['0001', '0002', '0003', '0004'];
      for (final t in tokens) {
        final url = 'https://app.abaerp.com/reset-password?token=$t';
        final result = service.parseDeepLink(url);

        expect(result.path, '/reset-password');
        expect(result.queryParams['token'], t);
        expect(result.fullRoute, '/reset-password?token=$t');
      }
    });

    test('Parses custom schemes (abaerp:// and buynaija://)', () {
      final res1 = service.parseDeepLink('abaerp://reset-password?token=0001');
      expect(res1.path, '/reset-password');
      expect(res1.queryParams['token'], '0001');

      final res2 = service.parseDeepLink('buynaija://reset-password?token=0002');
      expect(res2.path, '/reset-password');
      expect(res2.queryParams['token'], '0002');
    });

    test('Parses alternative domains and relative paths safely', () {
      final res1 = service.parseDeepLink('https://abaerp.com/reset-password?token=0003');
      expect(res1.path, '/reset-password');
      expect(res1.queryParams['token'], '0003');

      final res2 = service.parseDeepLink('/reset-password?token=0004');
      expect(res2.path, '/reset-password');
      expect(res2.queryParams['token'], '0004');
    });
  });

  group('Reset Password Tokens Repository Tests', () {
    test('AuthMockRepository accepts configured tokens (0001, 0002, 0003, 0004)', () async {
      final repo = AuthMockRepository();
      const tokens = ['0001', '0002', '0003', '0004'];

      for (final token in tokens) {
        await expectLater(
          repo.resetPassword(
            token: token,
            password: 'NewPassword123',
            confirmPassword: 'NewPassword123',
            email: 'user@example.com',
          ),
          completes,
        );
      }
    });

    test('AuthMockRepository rejects invalid/empty tokens and mismatch passwords', () async {
      final repo = AuthMockRepository();

      await expectLater(
        repo.resetPassword(
          token: '',
          password: 'NewPassword123',
          confirmPassword: 'NewPassword123',
        ),
        throwsException,
      );

      await expectLater(
        repo.resetPassword(
          token: 'invalid',
          password: 'NewPassword123',
          confirmPassword: 'NewPassword123',
        ),
        throwsException,
      );

      await expectLater(
        repo.resetPassword(
          token: '0001',
          password: 'NewPassword123',
          confirmPassword: 'DifferentPassword123',
        ),
        throwsException,
      );
    });

    test('AuthRemoteRepository sends token in request body to reset-password endpoint', () async {
      final dio = Dio();
      RequestOptions? captured;

      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        captured = opt;
        return handler.resolve(Response(
          requestOptions: opt,
          statusCode: 200,
          data: {'success': true, 'message': 'Password has been reset'},
        ));
      }));

      final remoteRepo = AuthRemoteRepository(dio: dio);
      await remoteRepo.resetPassword(
        token: '0001',
        password: 'Password123',
        confirmPassword: 'Password123',
        email: 'user@test.com',
      );

      expect(captured?.path, ApiEndpoints.auth.resetPassword);
      expect(captured?.data['token'], '0001');
      expect(captured?.data['password'], 'Password123');
      expect(captured?.data['confirm_password'], 'Password123');
      expect(captured?.data['email'], 'user@test.com');
    });
  });

  group('ResetPasswordScreen Deep Link Token Widget Tests', () {
    testWidgets('Pre-populates reset code field when token is passed via deep link', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ResetPasswordScreen(
              initialToken: '0001',
              initialEmail: 'test@abaerp.com',
            ),
          ),
        ),
      );

      expect(find.text('0001'), findsOneWidget);
      expect(find.text('test@abaerp.com'), findsOneWidget);
    });

    testWidgets('DeepLinkSimulatorSheet allows quick token selection (0001-0004)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DeepLinkSimulatorSheet(),
          ),
        ),
      );

      expect(find.text('Deep Link Simulator'), findsOneWidget);
      expect(find.text('Token 0001'), findsOneWidget);
      expect(find.text('Token 0002'), findsOneWidget);
      expect(find.text('Token 0003'), findsOneWidget);
      expect(find.text('Token 0004'), findsOneWidget);

      await tester.tap(find.text('Token 0003'));
      await tester.pump();

      expect(find.text('https://app.abaerp.com/reset-password?token=0003'), findsOneWidget);
    });
  });
}
