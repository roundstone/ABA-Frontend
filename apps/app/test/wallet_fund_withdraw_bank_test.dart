import 'package:app/core/config/app_config.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/wallet/data/wallet_remote_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Wallet Funding, Withdrawals, Payouts, and Bank Accounts API', () {
    setUp(() {
      AppConfig.isMockMode = false;
    });

    test('initializeFundWallet sends POST to /wallets/mobile-app/fund/paystack/initialize', () async {
      final dio = Dio();
      Map<String, dynamic>? capturedPayload;
      String? capturedPath;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedPath = options.path;
            capturedPayload = Map<String, dynamic>.from(options.data as Map);
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'success': true,
                  'statusCode': 201,
                  'message': 'Request completed successfully',
                  'data': {
                    'reference': 'WLT-b222ef75433143d79b93a7dc95735325',
                    'email': 'c-davidenabs@gmail.com',
                    'amount': 500000,
                    'publicKey': 'pk_test_a3c52ce327f5f3e830c62d7d2209ca361833dbb9',
                  },
                },
              ),
            );
          },
        ),
      );

      final repo = WalletRemoteRepository(dio: dio);
      final res = await repo.initializeFundWallet(5000.00);

      expect(capturedPath, equals('/api/v1/wallets/mobile-app/fund/paystack/initialize'));
      expect(capturedPayload?['amount'], equals('5000.00'));
      expect(res.reference, equals('WLT-b222ef75433143d79b93a7dc95735325'));
      expect(res.email, equals('c-davidenabs@gmail.com'));
      expect(res.amountInKobo, equals(500000));
      expect(res.amountNaira, equals(5000.0));
      expect(res.publicKey, equals('pk_test_a3c52ce327f5f3e830c62d7d2209ca361833dbb9'));
    });

    test('verifyFundWallet sends POST to /wallets/mobile-app/fund/paystack/{ref}/verify', () async {
      final dio = Dio();
      String? capturedPath;
      String? capturedMethod;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedPath = options.path;
            capturedMethod = options.method;
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'data': {'status': 'success'},
                },
              ),
            );
          },
        ),
      );

      final repo = WalletRemoteRepository(dio: dio);
      final verified = await repo.verifyFundWallet('WLT-b222ef75433143d79b93a7dc95735325');

      expect(verified, isTrue);
      expect(capturedMethod, equals('POST'));
      expect(
        capturedPath,
        equals('/api/v1/wallets/mobile-app/fund/paystack/WLT-b222ef75433143d79b93a7dc95735325/verify'),
      );
    });

    test('createWithdrawal sends POST to /payouts/mobile-app/withdrawals with amount and bankAccountId', () async {
      final dio = Dio();
      Map<String, dynamic>? capturedPayload;
      String? capturedPath;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedPath = options.path;
            capturedPayload = Map<String, dynamic>.from(options.data as Map);
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'success': true,
                  'statusCode': 201,
                  'data': {
                    'id': 42,
                    'amount': 5000.00,
                    'status': 'pending',
                    'bank_account_id': 1,
                    'createdAt': '2026-11-05T00:35:00.000Z',
                  },
                },
              ),
            );
          },
        ),
      );

      final repo = WalletRemoteRepository(dio: dio);
      final payout = await repo.createWithdrawal(amount: 5000.00, bankAccountId: 1);

      expect(capturedPath, equals('/api/v1/payouts/mobile-app/withdrawals'));
      expect(capturedPayload?['amount'], equals(5000.00));
      expect(capturedPayload?['bankAccountId'], equals(1));
      expect(payout.id, equals('42'));
      expect(payout.amount, equals(5000.0));
      expect(payout.bankAccountId, equals(1));
    });

    test('getMyPayouts and getPayoutById call correct endpoints', () async {
      final dio = Dio();
      final calledPaths = <String>[];

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            calledPaths.add(options.path);
            if (options.path.endsWith('/payouts/mobile-app/me')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'data': [
                      {
                        'id': 10,
                        'amount': '12500.00',
                        'status': 'completed',
                        'createdAt': '2026-11-05T00:35:00.000Z',
                      }
                    ],
                  },
                ),
              );
            }
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'statusCode': 200,
                  'data': {
                    'id': 10,
                    'amount': '12500.00',
                    'status': 'completed',
                    'reference': 'PYT-10',
                    'createdAt': '2026-11-05T00:35:00.000Z',
                  },
                },
              ),
            );
          },
        ),
      );

      final repo = WalletRemoteRepository(dio: dio);
      final list = await repo.getMyPayouts();
      final single = await repo.getPayoutById('10');

      expect(calledPaths, contains('/api/v1/payouts/mobile-app/me'));
      expect(calledPaths, contains('/api/v1/payouts/mobile-app/10'));
      expect(list.length, 1);
      expect(single.reference, 'PYT-10');
    });

    test('getAvailableBanks, addBankAccount, getUserBankAccounts, updateBankAccount, deleteBankAccount', () async {
      final dio = Dio();
      final requests = <String>[];

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add('${options.method} ${options.path}');
            if (options.path == ApiEndpoints.userBankAccounts.banks) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'data': [
                      {'name': '5TT MFB', 'code': '51455', 'active': true},
                      {'name': '78 Finance Company Ltd', 'code': '40195', 'active': true},
                    ],
                  },
                ),
              );
            }
            if (options.method == 'POST' &&
                options.path == ApiEndpoints.userBankAccounts.base) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'success': true,
                    'statusCode': 201,
                    'data': {
                      'id': 1,
                      'user_id': 10,
                      'bank_name': 'OPay Digital Services Limited (OPay)',
                      'bank_code': '999992',
                      'account_number': '8166551496',
                      'account_name': 'DAVID OSAGIE ENABULELE',
                      'is_verified': true,
                      'is_primary': true,
                      'createdAt': '2026-11-05T00:33:08.409Z',
                      'updatedAt': '2026-11-05T00:33:08.409Z',
                    },
                  },
                ),
              );
            }
            if (options.method == 'GET' &&
                options.path == ApiEndpoints.userBankAccounts.base) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'data': [
                      {
                        'id': 1,
                        'user_id': 10,
                        'bank_name': 'OPay Digital Services Limited (OPay)',
                        'bank_code': '999992',
                        'account_number': '8166551496',
                        'account_name': 'DAVID OSAGIE ENABULELE',
                        'is_verified': true,
                        'is_primary': true,
                      }
                    ],
                  },
                ),
              );
            }
            if (options.method == 'PATCH') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'statusCode': 200,
                    'data': {
                      'id': 1,
                      'user_id': 10,
                      'bank_name': 'OPay Digital Services Limited (OPay)',
                      'bank_code': '999992',
                      'account_number': '8166551496',
                      'account_name': 'DAVID OSAGIE ENABULELE',
                      'is_verified': true,
                      'is_primary': false,
                    },
                  },
                ),
              );
            }
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'success': true},
              ),
            );
          },
        ),
      );

      final repo = WalletRemoteRepository(dio: dio);
      final banks = await repo.getAvailableBanks();
      expect(banks.length, 2);
      expect(banks.first.name, '5TT MFB');
      expect(banks.first.code, '51455');

      final created = await repo.addBankAccount(
        bankName: 'OPay Digital Services Limited (OPay)',
        bankCode: '999992',
        accountNumber: '8166551496',
        isPrimary: true,
      );
      expect(created.id, 1);
      expect(created.accountName, 'DAVID OSAGIE ENABULELE');
      expect(created.isPrimary, isTrue);

      final accounts = await repo.getUserBankAccounts();
      expect(accounts.length, 1);

      final updated = await repo.updateBankAccount(1, isPrimary: false);
      expect(updated.isPrimary, isFalse);

      await repo.deleteBankAccount(1);

      expect(requests, contains('GET /api/v1/user-bank-accounts/mobile-app/banks'));
      expect(requests, contains('POST /api/v1/user-bank-accounts/mobile-app'));
      expect(requests, contains('GET /api/v1/user-bank-accounts/mobile-app'));
      expect(requests, contains('PATCH /api/v1/user-bank-accounts/mobile-app/1'));
      expect(requests, contains('DELETE /api/v1/user-bank-accounts/mobile-app/1'));
    });

    test('getUserBankAccounts gracefully handles backend 400 ParseIntPipe collision and preserves added accounts', () async {
      final dio = Dio();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'POST' &&
                options.path == ApiEndpoints.userBankAccounts.base) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'success': true,
                    'statusCode': 201,
                    'data': {
                      'id': 99,
                      'user_id': 10,
                      'bank_name': 'Access Bank',
                      'bank_code': '044',
                      'account_number': '0123456789',
                      'account_name': 'DAVID OSAGIE ENABULELE',
                      'is_verified': true,
                      'is_primary': true,
                    },
                  },
                ),
              );
            }
            // Simulate NestJS @Get(':id') ParseIntPipe route collision on GET
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {
                    'message': 'Validation failed (numeric string is expected)',
                    'error': 'Bad Request',
                    'statusCode': 400,
                  },
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      final repo = WalletRemoteRepository(dio: dio);

      // Before adding an account, a 400 numeric string collision returns [] instead of throwing
      final initialAccounts = await repo.getUserBankAccounts();
      expect(initialAccounts, isEmpty);

      // After adding an account via POST, getUserBankAccounts returns the cached account even if GET still collides
      await repo.addBankAccount(
        bankName: 'Access Bank',
        bankCode: '044',
        accountNumber: '0123456789',
        isPrimary: true,
      );

      final accountsAfterAdd = await repo.getUserBankAccounts();
      expect(accountsAfterAdd.length, 1);
      expect(accountsAfterAdd.first.id, 99);
      expect(accountsAfterAdd.first.bankName, 'Access Bank');
    });
  });
}
