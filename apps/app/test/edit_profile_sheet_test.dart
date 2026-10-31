import 'package:app/features/auth/application/auth_notifier.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/auth/domain/auth_repository.dart';
import 'package:app/features/customer/presentation/widgets/edit_profile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  AuthUser? currentUser;
  bool updateProfileCalled = false;
  String? updatedFirstName;
  String? updatedLastName;
  String? updatedPhone;
  bool shouldThrowOnUpdate = false;

  @override
  AuthUser? getStoredUserSync() => currentUser;

  @override
  Future<AuthUser?> getStoredUser() async => currentUser;

  @override
  Future<AuthUser> getProfile() async {
    return currentUser ??
        AuthUser(
          id: '10',
          name: 'David Enabs',
          email: 'c-davidenabs@gmail.com',
          phone: '+2348140000003',
          role: UserRole.customer,
          token: 'token-xyz',
          createdAt: DateTime.now(),
        );
  }

  @override
  Future<AuthUser> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? businessName,
  }) async {
    updateProfileCalled = true;
    updatedFirstName = firstName;
    updatedLastName = lastName;
    updatedPhone = phone;

    if (shouldThrowOnUpdate) {
      throw Exception('Update failed on server');
    }

    final newName = [firstName, lastName]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    currentUser = (currentUser ??
            AuthUser(
              id: '10',
              name: 'David Enabs',
              email: 'c-davidenabs@gmail.com',
              phone: '+2348140000003',
              role: UserRole.customer,
              token: 'token-xyz',
              createdAt: DateTime.now(),
            ))
        .copyWith(
      name: newName.isNotEmpty ? newName : null,
      phone: phone ?? currentUser?.phone,
    );
    return currentUser!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('EditProfileModal Tests', () {
    testWidgets('renders fields and populates from fetchProfile', (tester) async {
      final fakeRepo = _FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeRepo),
            authStateProvider.overrideWith(
              (ref) => AuthNotifier(repository: fakeRepo),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: EditProfileModal(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('David Enabs'), findsOneWidget);
      expect(find.text('+2348140000003'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('submits updated profile when fields are changed', (tester) async {
      final fakeRepo = _FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeRepo),
            authStateProvider.overrideWith(
              (ref) => AuthNotifier(repository: fakeRepo),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: EditProfileModal(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Change name and phone
      final nameField = find.widgetWithText(TextFormField, 'David Enabs');
      await tester.enterText(nameField, 'David John Enabs');

      final phoneField = find.widgetWithText(TextFormField, '+2348140000003');
      await tester.enterText(phoneField, '+2348140000099');

      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(fakeRepo.updateProfileCalled, isTrue);
      expect(fakeRepo.updatedFirstName, equals('David'));
      expect(fakeRepo.updatedLastName, equals('John Enabs'));
      expect(fakeRepo.updatedPhone, equals('+2348140000099'));
    });
  });
}
