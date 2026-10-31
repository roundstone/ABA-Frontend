import 'dart:async';
import 'package:app/core/network/network_connectivity_provider.dart';
import 'package:app/core/widgets/app_snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeConnectivity implements Connectivity {
  final controller = StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => controller.stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    NetworkConnectivityNotifier.isOffline = false;
  });

  group('NetworkConnectivityNotifier Tests', () {
    testWidgets('alerts only on network status changes during active app usage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: AppSnackbar.scaffoldMessengerKey,
          home: const Scaffold(
            body: Center(child: Text('Content')),
          ),
        ),
      );

      final fakeConnectivity = _FakeConnectivity();
      final notifier = NetworkConnectivityNotifier(
        connectivity: fakeConnectivity,
        startupGracePeriod: Duration.zero,
      );

      // 1. Initial check (online)
      fakeConnectivity.controller.add([ConnectivityResult.wifi]);
      await tester.pump(const Duration(milliseconds: 50));

      // 2. Network drops (offline) while using the app
      fakeConnectivity.controller.add([ConnectivityResult.none]);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text('No internet connection. Please check your network.'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // 3. Network restored while using the app
      fakeConnectivity.controller.add([ConnectivityResult.wifi]);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text('Internet connection restored.'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      notifier.dispose();
      await fakeConnectivity.controller.close();
    });

    testWidgets('suppresses error popup on initial launch / app restart', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: AppSnackbar.scaffoldMessengerKey,
          home: const Scaffold(
            body: Center(child: Text('Content')),
          ),
        ),
      );

      final fakeConnectivity = _FakeConnectivity();
      final notifier = NetworkConnectivityNotifier(
        connectivity: fakeConnectivity,
        startupGracePeriod: const Duration(seconds: 2),
      );

      // App starts and device is already offline
      fakeConnectivity.controller.add([ConnectivityResult.none]);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 300));

      // Absolutely no error snackbar is shown on initial check/restart
      expect(
        find.text('No internet connection. Please check your network.'),
        findsNothing,
      );

      notifier.dispose();
      await fakeConnectivity.controller.close();
    });
  });
}

