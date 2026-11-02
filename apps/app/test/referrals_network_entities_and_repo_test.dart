import 'package:app/features/customer/data/referrals_network_repository.dart';
import 'package:app/features/customer/domain/referral_network_member.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReferralNetworkMember fromJson Parsing Tests', () {
    test('parses member and referredUser from backend sample response', () {
      final sampleJson = {
        "id": 12,
        "referrer_user_id": 8,
        "referred_user_id": 21,
        "level": 1,
        "user_id": 21,
        "username": "john.doe",
        "referredUser": {
          "id": 21,
          "first_name": "John",
          "middle_name": null,
          "last_name": "Doe",
          "username": "john.doe"
        }
      };

      final member = ReferralNetworkMember.fromJson(sampleJson);

      expect(member.id, equals(12));
      expect(member.referrerUserId, equals(8));
      expect(member.referredUserId, equals(21));
      expect(member.level, equals(1));
      expect(member.username, equals('john.doe'));
      expect(member.displayName, equals('John Doe'));
      expect(member.initials, equals('JD'));
      expect(member.user?.firstName, equals('John'));
      expect(member.user?.lastName, equals('Doe'));
    });

    test('parses member when referredUser is missing or fallback username used', () {
      final json = {
        "id": 15,
        "referrer_user_id": 8,
        "referred_user_id": 35,
        "level": 2,
        "username": "amadi_crafts",
      };

      final member = ReferralNetworkMember.fromJson(json);

      expect(member.id, equals(15));
      expect(member.level, equals(2));
      expect(member.displayName, equals('amadi_crafts'));
      expect(member.initials, equals('A'));
    });
  });

  group('ReferralsNetworkRemoteRepository Dio Tests', () {
    test('getDownline sends correct depth and parses members', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/referrals/mobile-app/me/downline')) {
              expect(options.queryParameters['depth'], equals(2));
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    "success": true,
                    "statusCode": 200,
                    "message": "Request completed successfully",
                    "data": [
                      {
                        "id": 12,
                        "referrer_user_id": 8,
                        "referred_user_id": 21,
                        "level": 1,
                        "user_id": 21,
                        "username": "john.doe",
                        "referredUser": {
                          "id": 21,
                          "first_name": "John",
                          "last_name": "Doe",
                          "username": "john.doe"
                        }
                      }
                    ]
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final repo = ReferralsNetworkRemoteRepository(dio: dio);
      final list = await repo.getDownline(depth: 2);

      expect(list.length, equals(1));
      expect(list.first.displayName, equals('John Doe'));
      expect(list.first.level, equals(1));
    });

    test('getUpline sends correct depth and parses upline mentors', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/referrals/mobile-app/me/upline')) {
              expect(options.queryParameters['depth'], equals(1));
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    "success": true,
                    "statusCode": 200,
                    "message": "Request completed successfully",
                    "data": [
                      {
                        "id": 11,
                        "referrer_user_id": 5,
                        "referred_user_id": 8,
                        "level": 1,
                        "user_id": 5,
                        "username": "mentor.chioma",
                        "referrerUser": {
                          "id": 5,
                          "first_name": "Chioma",
                          "last_name": "Mentor",
                          "username": "mentor.chioma"
                        }
                      }
                    ]
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final repo = ReferralsNetworkRemoteRepository(dio: dio);
      final list = await repo.getUpline(depth: 1);

      expect(list.length, equals(1));
      expect(list.first.displayName, equals('Chioma Mentor'));
      expect(list.first.level, equals(1));
    });
  });
}

