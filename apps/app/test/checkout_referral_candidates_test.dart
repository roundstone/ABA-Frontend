import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/checkout/application/checkout_providers.dart';
import 'package:app/features/checkout/data/checkout_remote_repository.dart';
import 'package:app/features/checkout/domain/checkout_entities.dart';
import 'package:app/features/checkout/presentation/widgets/checkout_referral_section.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final sampleBackendPayload = {
    "success": true,
    "statusCode": 200,
    "message": "Request completed successfully",
    "data": [
      {
        "customerId": 638,
        "userId": 945,
        "name": "Customer A",
        "username": "customer.a",
        "referralCode": "CUSTOMER-638-033F5078",
      },
      {
        "customerId": 641,
        "userId": 949,
        "name": "Customer One",
        "username": "customer.one",
        "referralCode": "CUSTOMER-641-1CA3F1F2",
      },
      {
        "customerId": 639,
        "userId": 946,
        "name": "CustomerB B",
        "username": "customerb.b",
        "referralCode": "CUSTOMER-639-210DC633",
      },
    ],
    "timestamp": "2026-11-10T10:38:52.049Z",
  };

  group('ReferralCandidate.fromJson Tests', () {
    test('parses exact backend response payload correctly', () {
      final list = (sampleBackendPayload['data'] as List)
          .map((item) => ReferralCandidate.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      expect(list.length, equals(3));

      expect(list[0].id, equals('638'));
      expect(list[0].customerId, equals(638));
      expect(list[0].userId, equals(945));
      expect(list[0].name, equals('Customer A'));
      expect(list[0].username, equals('customer.a'));
      expect(list[0].moniker, equals('@customer.a'));
      expect(list[0].code, equals('CUSTOMER-638-033F5078'));

      expect(list[1].name, equals('Customer One'));
      expect(list[1].code, equals('CUSTOMER-641-1CA3F1F2'));

      expect(list[2].name, equals('CustomerB B'));
      expect(list[2].code, equals('CUSTOMER-639-210DC633'));
    });
  });

  group('CheckoutRemoteRepository Referral Candidates API Tests', () {
    test('searchReferrals calls /checkout/referral-candidates with query param and caches result', () async {
      final recordedRequests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://test.aba.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            recordedRequests.add(options);
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: sampleBackendPayload,
              ),
            );
          },
        ),
      );

      final repo = CheckoutRemoteRepository(dio);
      final results1 = await repo.searchReferrals('customer');

      expect(recordedRequests.length, equals(1));
      expect(
        recordedRequests.first.path,
        equals(ApiEndpoints.checkout.referralCandidates),
      );
      expect(
        recordedRequests.first.queryParameters,
        equals({'query': 'customer'}),
      );
      expect(results1.length, equals(3));
      expect(results1.first.name, equals('Customer A'));
      expect(results1.first.code, equals('CUSTOMER-638-033F5078'));

      // Second call with same query should hit in-memory cache and not fire second request
      final results2 = await repo.searchReferrals('customer');
      expect(recordedRequests.length, equals(1), reason: 'Expected cache hit');
      expect(results2.length, equals(3));
    });
  });

  group('CheckoutNotifier Referral Debounce & Cache Tests', () {
    test('debounces searchReferrals and serves cached queries instantly', () async {
      int searchCallCount = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://test.aba.com'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('referral-candidates')) {
              searchCallCount++;
              return handler.resolve(Response(
                requestOptions: options,
                statusCode: 200,
                data: sampleBackendPayload,
              ));
            }
            return handler.resolve(Response(
              requestOptions: options,
              statusCode: 200,
              data: {'success': true, 'data': []},
            ));
          },
        ),
      );

      final container = ProviderContainer(
        overrides: [
          checkoutRepositoryProvider.overrideWithValue(CheckoutRemoteRepository(dio)),
        ],
      );
      addTearDown(container.dispose);
      container.listen(checkoutProvider, (_, __) {});

      final notifier = container.read(checkoutProvider.notifier);
      await pumpEventQueue();

      // Rapidly fire multiple search queries
      notifier.searchReferrals('c');
      notifier.searchReferrals('cu');
      notifier.searchReferrals('cust');
      notifier.searchReferrals('customer');

      expect(searchCallCount, equals(0), reason: 'Debounce should delay network call');

      // Wait for debounce timer (300ms) to fire
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await pumpEventQueue();

      expect(searchCallCount, equals(1));
      expect(container.read(checkoutProvider).referralSearchResults.length, equals(3));

      // Trigger same query again -> immediate cache hit without network call
      await notifier.searchReferrals('customer');
      expect(searchCallCount, equals(1), reason: 'Expected cache hit');
    });
  });

  group('CheckoutReferralSection Widget Tests', () {
    testWidgets('renders search field, shows candidates, and allows applying referral', (tester) async {
      String query = '';
      ReferralCandidate? applied;
      bool removed = false;

      final candidates = (sampleBackendPayload['data'] as List)
          .map((item) => ReferralCandidate.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CheckoutReferralSection(
                  appliedReferral: applied,
                  searchQuery: query,
                  searchResults: query.length >= 2 ? candidates : const [],
                  isSearching: false,
                  onQueryChanged: (q) {
                    setState(() {
                      query = q;
                    });
                  },
                  onApplyCandidate: (c) {
                    setState(() {
                      applied = c;
                      query = '';
                    });
                  },
                  onRemove: () {
                    setState(() {
                      applied = null;
                      removed = true;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Verify initial UI
      expect(find.text('Referred by someone?'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter query 'customer'
      await tester.enterText(find.byType(TextField), 'customer');
      await tester.pumpAndSettle();

      // Check results list
      expect(find.text('Customer A'), findsOneWidget);
      expect(find.text('Customer One'), findsOneWidget);
      expect(find.text('CustomerB B'), findsOneWidget);
      expect(find.text('@customer.a • CUSTOMER-638-033F5078'), findsOneWidget);

      // Tap on Customer A
      await tester.tap(find.text('Customer A'));
      await tester.pumpAndSettle();

      // Verify applied banner
      expect(find.text('Referral applied'), findsOneWidget);
      expect(find.text('Supporting Customer A (@customer.a)'), findsOneWidget);
      expect(find.text('CUSTOMER-638-033F5078'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);

      // Tap Remove
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(removed, isTrue);
      expect(find.text('Referral applied'), findsNothing);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
