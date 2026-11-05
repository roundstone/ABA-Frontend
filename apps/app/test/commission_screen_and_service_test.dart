import 'package:app/features/customer/application/commission_providers.dart';
import 'package:app/features/customer/data/commission_service.dart';
import 'package:app/features/customer/presentation/commission_ledger_screen.dart';
import 'package:app/features/customer/presentation/widgets/commission_overview_cards.dart';
import 'package:app/features/customer/presentation/widgets/commission_record_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Commission Models fromJson Tests', () {
    test('parses CommissionOverview correctly from user API sample payload', () {
      final json = {
        "generatedPeriod": 1500, "pendingApproval": 1000, "approvedUnpaid": 1000,
        "paidPeriod": 500, "reversedPeriod": 0, "outstandingLiability": 1000
      };

      final overview = CommissionOverview.fromJson(json);

      expect(overview.generatedPeriod, equals(1500.0));
      expect(overview.pendingApproval, equals(1000.0));
      expect(overview.approvedUnpaid, equals(1000.0));
      expect(overview.paidPeriod, equals(500.0));
      expect(overview.reversedPeriod, equals(0.0));
      expect(overview.outstandingLiability, equals(1000.0));
    });

    test('parses CommissionRecord list from user API sample payload', () {
      final item1Json = {
        "id": 42, "user_id": 18, "commission_rule_id": 7, "source_type": "order",
        "source_id": 1254, "commission_level": 1, "calculation_base": "10000.00",
        "applied_rate": "10.0000", "applied_fixed_amount": null, "amount": "1000.00",
        "currency": "NGN", "status": 2, "eligible_at": "2026-11-07T08:30:00.000Z",
        "released_at": null,
        "commissionRule": {"id": 7, "title": "Merchant Referral Plan", "merchantId": 3},
        "sourceOrderNumber": "ORD-1793953140000-AB12CD34",
        "sourceCustomerName": "Chinedu Okafor",
        "createdAt": "2026-11-05T08:30:00.000Z", "updatedAt": "2026-11-05T08:30:00.000Z"
      };

      final item2Json = {
        "id": 41, "user_id": 18, "commission_rule_id": 7, "source_type": "order",
        "source_id": 1254, "commission_level": 2, "calculation_base": "10000.00",
        "applied_rate": "5.0000", "applied_fixed_amount": null, "amount": "500.00",
        "currency": "NGN", "status": 3, "eligible_at": "2026-11-04T08:30:00.000Z",
        "released_at": "2026-11-05T07:10:00.000Z",
        "commissionRule": {"id": 7, "title": "Merchant Referral Plan", "merchantId": 3},
        "sourceOrderNumber": "ORD-1793953140000-AB12CD34",
        "sourceCustomerName": "Chinedu Okafor",
        "createdAt": "2026-11-03T08:30:00.000Z", "updatedAt": "2026-11-05T07:10:00.000Z"
      };

      final record1 = CommissionRecord.fromJson(item1Json);
      final record2 = CommissionRecord.fromJson(item2Json);

      expect(record1.id, equals(42));
      expect(record1.userId, equals(18));
      expect(record1.commissionLevel, equals(1));
      expect(record1.calculationBase, equals(10000.0));
      expect(record1.appliedRate, equals(10.0));
      expect(record1.amount, equals(1000.0));
      expect(record1.status, equals(2));
      expect(record1.statusName, equals('Approved'));
      expect(record1.commissionRule?.title, equals('Merchant Referral Plan'));
      expect(record1.sourceOrderNumber, equals('ORD-1793953140000-AB12CD34'));
      expect(record1.sourceCustomerName, equals('Chinedu Okafor'));

      expect(record2.id, equals(41));
      expect(record2.commissionLevel, equals(2));
      expect(record2.amount, equals(500.0));
      expect(record2.status, equals(3));
      expect(record2.statusName, equals('Paid'));
      expect(record2.releasedAt, isNotNull);
    });
  });

  group('CommissionService Dio Tests', () {
    test('getOverview and getCommissions make expected API calls and parse responses', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('/commissions/mobile-app/overview')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    "success": true,
                    "statusCode": 200,
                    "message": "Request completed successfully",
                    "data": {
                      "generatedPeriod": 1500,
                      "pendingApproval": 1000,
                      "approvedUnpaid": 1000,
                      "paidPeriod": 500,
                      "reversedPeriod": 0,
                      "outstandingLiability": 1000
                    }
                  },
                ),
              );
            }
            if (options.path.contains('/commissions/mobile-app')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    "success": true,
                    "statusCode": 200,
                    "message": "Request completed successfully",
                    "data": {
                      "data": [
                        {
                          "id": 42,
                          "user_id": 18,
                          "commission_level": 1,
                          "calculation_base": "10000.00",
                          "applied_rate": "10.0000",
                          "amount": "1000.00",
                          "status": 2,
                          "sourceOrderNumber": "ORD-1793953140000-AB12CD34",
                          "sourceCustomerName": "Chinedu Okafor",
                        }
                      ],
                      "meta": {
                        "totalItems": 1,
                        "itemCount": 1,
                        "itemsPerPage": 10,
                        "totalPages": 1,
                        "currentPage": 1
                      }
                    }
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final service = CommissionService(dio: dio);
      final overview = await service.getOverview();
      expect(overview.generatedPeriod, equals(1500.0));
      expect(overview.paidPeriod, equals(500.0));

      final paginated = await service.getCommissions();
      expect(paginated.items.length, equals(1));
      expect(paginated.items.first.id, equals(42));
      expect(paginated.items.first.amount, equals(1000.0));
      expect(paginated.items.first.sourceCustomerName, equals('Chinedu Okafor'));
    });
  });

  group('CommissionLedgerScreen Widget Tests', () {
    testWidgets('renders Overview cards, Filter chips, and Commission records', (tester) async {
      const mockOverview = CommissionOverview(
        generatedPeriod: 1500.0,
        pendingApproval: 1000.0,
        approvedUnpaid: 1000.0,
        paidPeriod: 500.0,
        reversedPeriod: 0.0,
        outstandingLiability: 1000.0,
      );

      final mockRecords = [
        CommissionRecord(
          id: 42,
          userId: 18,
          commissionLevel: 1,
          calculationBase: 10000.00,
          appliedRate: 10.0,
          amount: 1000.00,
          status: 2,
          sourceOrderNumber: 'ORD-1793953140000-AB12CD34',
          sourceCustomerName: 'Chinedu Okafor',
          commissionRule: const CommissionRuleInfo(id: 7, title: 'Merchant Referral Plan'),
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            commissionOverviewProvider.overrideWith((ref) => Future.value(mockOverview)),
            commissionsListProvider.overrideWith((ref) => Future.value(PaginatedCommissions(
              items: mockRecords,
              totalItems: 1,
              totalPages: 1,
              currentPage: 1,
              hasNext: false,
            ))),
          ],
          child: const MaterialApp(
            home: CommissionLedgerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Commissions'), findsOneWidget);
      expect(find.byType(CommissionOverviewCards), findsOneWidget);
      expect(find.text('Total Generated'), findsOneWidget);
      expect(find.text('Pending Approval'), findsWidgets);
      expect(find.text('Approved Unpaid'), findsOneWidget);

      // Scroll to view records list
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.byType(CommissionRecordCard), findsOneWidget);
      expect(find.text('Approved'), findsWidgets);
      expect(find.text('ORD-1793953140000-AB12CD34'), findsOneWidget);
      expect(find.text('Customer: Chinedu Okafor'), findsOneWidget);
      expect(find.text('Tier 1'), findsOneWidget);
    });
  });
}
