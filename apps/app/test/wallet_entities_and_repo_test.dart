import 'package:app/features/wallet/data/wallet_remote_repository.dart';
import 'package:app/features/wallet/domain/wallet_entities.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Wallet Entities fromJson Parsing Tests', () {
    test('parses WalletInfo from backend sample response', () {
      final sampleJson = {
        "id": 104,
        "walletable_type": "customer",
        "walletable_id": 4,
        "user_id": 10,
        "balance": "0.00",
        "currency": 1,
        "is_active": true,
        "createdAt": "2026-11-02T07:05:55.851Z",
        "updatedAt": "2026-11-02T07:05:55.851Z"
      };

      final info = WalletInfo.fromJson(sampleJson);

      expect(info.id, equals(104));
      expect(info.balance, equals(0.0));
      expect(info.currency, equals('NGN'));
      expect(info.walletableType, equals('customer'));
      expect(info.walletableId, equals(4));
      expect(info.userId, equals(10));
      expect(info.isActive, isTrue);
      expect(info.createdAt, isNotNull);
    });

    test('parses WalletTransaction list from backend sample response', () {
      final sampleTx1 = {
        "id": 101,
        "wallet_id": 12,
        "reference_number": "DEMO-WALLET-CUSTOMER-12-1",
        "transaction_type": 1,
        "amount": "25000.00",
        "currency": 1,
        "status": 2,
        "balance_before": "0.00",
        "balance_after": "25000.00",
        "source_type": "wallet_transaction_seed",
        "source_id": 12,
        "description": "Demo Paystack wallet deposit",
        "metadata": {
          "seeded": true,
          "signedAmount": "25000.00"
        },
        "createdAt": "2026-11-02T09:00:00.000Z",
      };

      final sampleTx2 = {
        "id": 102,
        "wallet_id": 12,
        "reference_number": "DEMO-WALLET-CUSTOMER-12-2",
        "transaction_type": 2,
        "amount": "5000.00",
        "currency": 1,
        "status": 2,
        "balance_before": "25000.00",
        "balance_after": "20000.00",
        "source_type": "wallet_transaction_seed",
        "source_id": 12,
        "description": "Demo wallet-funded order payment",
        "metadata": {
          "seeded": true,
          "signedAmount": "-5000.00"
        },
        "createdAt": "2026-11-02T09:01:00.000Z",
      };

      final tx1 = WalletTransaction.fromJson(sampleTx1);
      expect(tx1.id, equals('101'));
      expect(tx1.walletId, equals(12));
      expect(tx1.referenceNumber, equals('DEMO-WALLET-CUSTOMER-12-1'));
      expect(tx1.transactionType, equals(WalletTransactionType.deposit));
      expect(tx1.type, equals(TransactionType.credit));
      expect(tx1.amount, equals(25000.0));
      expect(tx1.status, equals(TransactionStatus.completed));
      expect(tx1.balanceBefore, equals(0.0));
      expect(tx1.balanceAfter, equals(25000.0));
      expect(tx1.description, equals('Demo Paystack wallet deposit'));

      final tx2 = WalletTransaction.fromJson(sampleTx2);
      expect(tx2.id, equals('102'));
      expect(tx2.transactionType, equals(WalletTransactionType.orderPayment));
      expect(tx2.type, equals(TransactionType.debit));
      expect(tx2.amount, equals(5000.0));
      expect(tx2.balanceBefore, equals(25000.0));
      expect(tx2.balanceAfter, equals(20000.0));
    });
  });

  group('WalletRemoteRepository Dio Tests', () {
    test('getWalletInfo successfully parses active wallet from array response', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/wallets/mobile-app/me')) {
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
                        "id": 104,
                        "walletable_type": "customer",
                        "walletable_id": 4,
                        "user_id": 10,
                        "balance": "15000.00",
                        "currency": 1,
                        "is_active": true,
                        "createdAt": "2026-11-02T07:05:55.851Z",
                        "updatedAt": "2026-11-02T07:05:55.851Z"
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

      final repo = WalletRemoteRepository(dio: dio);
      final wallet = await repo.getWalletInfo();

      expect(wallet.id, equals(104));
      expect(wallet.balance, equals(15000.0));
      expect(wallet.currency, equals('NGN'));
      expect(wallet.isActive, isTrue);
    });

    test('getPaginatedTransactions serializes queries and parses pagination meta', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/wallets/mobile-app/me/transactions')) {
              expect(options.queryParameters['transactionType'], equals(1));
              expect(options.queryParameters['page'], equals(1));
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
                          "id": 101,
                          "wallet_id": 12,
                          "reference_number": "DEMO-WALLET-CUSTOMER-12-1",
                          "transaction_type": 1,
                          "amount": "25000.00",
                          "currency": 1,
                          "status": 2,
                          "description": "Demo Paystack wallet deposit",
                          "createdAt": "2026-11-02T09:00:00.000Z",
                        }
                      ],
                      "meta": {
                        "totalItems": 1,
                        "itemCount": 1,
                        "itemsPerPage": 10,
                        "totalPages": 1,
                        "currentPage": 1,
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

      final repo = WalletRemoteRepository(dio: dio);
      final res = await repo.getPaginatedTransactions(transactionType: 1);

      expect(res.transactions.length, equals(1));
      expect(res.transactions.first.amount, equals(25000.0));
      expect(res.transactions.first.referenceNumber, equals('DEMO-WALLET-CUSTOMER-12-1'));
      expect(res.totalItems, equals(1));
      expect(res.hasNext, isFalse);
    });

    test('getShoppingCredits parses backend response from /api/v1/shopping-credits/me', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('/shopping-credits/me')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    "success": true,
                    "statusCode": 200,
                    "message": "Request completed successfully",
                    "data": {
                      "id": 2,
                      "user_id": 10,
                      "balance": "12500.00",
                      "createdAt": "2026-11-05T00:21:46.765Z",
                      "updatedAt": "2026-11-05T00:21:46.765Z",
                      "is_activated": true
                    },
                    "timestamp": "2026-11-05T00:21:46.780Z"
                  },
                ),
              );
            }
            return handler.next(options);
          },
        ),
      );

      final repo = WalletRemoteRepository(dio: dio);
      final credits = await repo.getShoppingCredits();

      expect(credits.id, equals(2));
      expect(credits.userId, equals(10));
      expect(credits.balance, equals(12500.00));
      expect(credits.isActivated, isTrue);
    });
  });
}

