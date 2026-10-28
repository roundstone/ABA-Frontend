import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/theme_provider.dart';
import 'package:app/features/auth/application/auth_providers.dart';
import 'package:app/features/auth/domain/auth_entities.dart';
import 'package:app/features/customer/presentation/settings_screen.dart';

void main() {
  group('SettingsScreen and EditProfile Tests', () {
    testWidgets('renders user profile, preferences, and actions',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Edit Profile Information'), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Delete Account Permanently'), 100);
      expect(find.text('Logout Account'), findsOneWidget);
      expect(find.text('Delete Account Permanently'), findsOneWidget);
    });

    testWidgets('tapping Edit Profile opens edit modal and updates profile',
        (tester) async {
      final container = ProviderContainer();
      // Seed a user in auth state
      container.read(authStateProvider.notifier).state = AuthState(
        user: AuthUser(
          id: 'user-1',
          name: 'Original Name',
          email: 'orig@aba.com',
          phone: '+234800000000',
          role: UserRole.customer,
          token: 'token-123',
          createdAt: DateTime.now(),
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Original Name'), findsOneWidget);

      final editBtn = find.text('Edit Profile Information');
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      final nameField = find.widgetWithText(TextFormField, 'Full Name');
      expect(nameField, findsOneWidget);

      await tester.enterText(nameField, 'Jane Updated Doe');
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(container.read(currentUserProvider)?.name,
          equals('Jane Updated Doe'));
      expect(find.text('Jane Updated Doe'), findsOneWidget);
    });

    testWidgets('tapping Delete Account shows permanent deletion alert',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final deleteBtn = find.text('Delete Account Permanently');
      await tester.scrollUntilVisible(deleteBtn, 300);
      await tester.pumpAndSettle();
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      expect(find.text('Delete Account?'), findsOneWidget);
      expect(
        find.textContaining('This action cannot be undone'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('renders Theme Mode tile and opens ThemeModeDialog to switch theme',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final themeTile = find.text('Theme Mode');
      expect(themeTile, findsOneWidget);

      await tester.tap(themeTile);
      await tester.pumpAndSettle();

      expect(find.text('Choose Theme Mode'), findsOneWidget);
      expect(find.text('System Default'), findsWidgets);
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);

      await tester.tap(find.text('Dark Mode'));
      await tester.pumpAndSettle();

      // Modal closed and theme subtitle updated to Dark Mode
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    test('ThemeModeNotifier persists theme selection to SharedPreferences',
        () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final prefs = await SharedPreferences.getInstance();
      final notifier = ThemeModeNotifier(prefs);

      expect(notifier.state, equals(ThemeMode.dark));

      await notifier.setThemeMode(ThemeMode.light);
      expect(notifier.state, equals(ThemeMode.light));
      expect(prefs.getString('app_theme_mode'), equals('light'));

      await notifier.setThemeMode(ThemeMode.system);
      expect(notifier.state, equals(ThemeMode.system));
      expect(prefs.getString('app_theme_mode'), equals('system'));
    });
  });
}
