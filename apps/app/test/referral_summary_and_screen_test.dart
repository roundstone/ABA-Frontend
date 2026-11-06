import 'package:app/features/customer/presentation/referrals_screen.dart';
import 'package:app/features/customer/presentation/widgets/referral_invite_card.dart';
import 'package:app/features/customer/presentation/widgets/referral_kpi_cards.dart';
import 'package:app/features/customer/presentation/widgets/referral_network_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReferralSummary Models fromJson Tests', () {
    test('parses ReferralData correctly from user API sample payload', () {
      final sampleJson = {
        "success": true,
        "statusCode": 200,
        "message": "Request completed successfully",
        "data": {
          "referralCode": "CUSTOMER-638-033F5078",
          "metrics": {
            "totalNetwork": 1,
            "activeBuyers": 1,
            "totalEarned": 10000,
          },
          "stats": [
            {
              "referredUserId": "946",
              "referredUserName": "CustomerB B",
              "username": "customerb.b",
              "level": 1,
              "joinedDate": "2026-11-05T08:32:52.586Z",
              "status": "Active",
              "earnings": 10000,
            }
          ],
        },
        "timestamp": "2026-11-05T09:34:11.248Z",
      };

      final referralData =
          ReferralData.fromJson(sampleJson["data"] as Map<String, dynamic>);

      expect(referralData.referralCode, equals("CUSTOMER-638-033F5078"));
      expect(referralData.metrics.totalNetwork, equals(1));
      expect(referralData.metrics.activeBuyers, equals(1));
      expect(referralData.metrics.totalEarned, equals(10000));

      expect(referralData.stats.length, equals(1));
      final stat = referralData.stats.first;
      expect(stat.referredUserId, equals("946"));
      expect(stat.referredUserName, equals("CustomerB B"));
      expect(stat.username, equals("customerb.b"));
      expect(stat.level, equals(1));
      expect(stat.status, equals("Active"));
      expect(stat.earnings, equals(10000));
      expect(stat.joinedDate.year, equals(2026));
    });
  });

  group('ReferralSummaryService Dio Tests', () {
    test('fetchSummary calls /api/v1/referrals/me/summary and parses data',
        () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.aba.ng'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('/api/v1/referrals/me/summary')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    "success": true,
                    "statusCode": 200,
                    "message": "Request completed successfully",
                    "data": {
                      "referralCode": "CUSTOMER-638-033F5078",
                      "metrics": {
                        "totalNetwork": 1,
                        "activeBuyers": 1,
                        "totalEarned": 10000,
                      },
                      "stats": [
                        {
                          "referredUserId": "946",
                          "referredUserName": "CustomerB B",
                          "username": "customerb.b",
                          "level": 1,
                          "joinedDate": "2026-11-05T08:32:52.586Z",
                          "status": "Active",
                          "earnings": 10000,
                        }
                      ],
                    },
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final service = ReferralSummaryService(dio: dio);
      final result = await service.fetchSummary();

      expect(result.referralCode, equals('CUSTOMER-638-033F5078'));
      expect(result.metrics.totalNetwork, equals(1));
      expect(result.stats.first.referredUserName, equals('CustomerB B'));
    });
  });

  group('Referral Widgets Tests', () {
    testWidgets('ReferralKpiCardsRow renders metrics correctly',
        (tester) async {
      const metrics = ReferralMetrics(
        totalNetwork: 5,
        activeBuyers: 3,
        totalEarned: 1000000,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReferralKpiCardsRow(metrics: metrics),
          ),
        ),
      );

      expect(find.text('Total Network'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Active Buyers'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Total Earned'), findsOneWidget);
    });

    testWidgets('ReferralInviteCard renders code and copy button',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReferralInviteCard(
              referralCode: 'CUSTOMER-638-033F5078',
              referralLink:
                  'https://abaonline.vercel.app/community/CUSTOMER-638-033F5078',
              hasCode: true,
            ),
          ),
        ),
      );

      expect(find.text('Invite & Earn'), findsOneWidget);
      expect(find.text('CUSTOMER-638-033F5078'), findsOneWidget);
    });

    testWidgets('ReferralNetworkList renders list of referred members',
        (tester) async {
      final stats = [
        ReferralStat(
          referredUserId: '946',
          referredUserName: 'CustomerB B',
          username: 'customerb.b',
          level: 1,
          joinedDate: DateTime(2026, 11, 5),
          status: 'Active',
          earnings: 10000,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReferralNetworkList(stats: stats),
          ),
        ),
      );

      expect(find.text('CustomerB B'), findsOneWidget);
      expect(find.textContaining('Active'), findsOneWidget);
      expect(find.textContaining('Level 1'), findsOneWidget);
    });

    testWidgets('ReferralsScreen renders with data from provider',
        (tester) async {
      final testData = ReferralData(
        referralCode: 'CUSTOMER-638-033F5078',
        metrics: const ReferralMetrics(
          totalNetwork: 1,
          activeBuyers: 1,
          totalEarned: 10000,
        ),
        stats: [
          ReferralStat(
            referredUserId: '946',
            referredUserName: 'CustomerB B',
            username: 'customerb.b',
            level: 1,
            joinedDate: DateTime(2026, 11, 5),
            status: 'Active',
            earnings: 10000,
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referralDataProvider.overrideWith((ref) => Future.value(testData)),
          ],
          child: const MaterialApp(
            home: ReferralsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Referral Network'), findsOneWidget);
      expect(find.text('Marketer'), findsOneWidget);
      expect(find.text('Ledger'), findsOneWidget);
      expect(find.text('CustomerB B'), findsOneWidget);
      expect(find.text('CUSTOMER-638-033F5078'), findsWidgets);
    });
  });
}

