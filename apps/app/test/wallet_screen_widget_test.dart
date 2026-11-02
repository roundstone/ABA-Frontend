import 'dart:async';

import 'package:app/features/wallet/application/wallet_providers.dart';
import 'package:app/features/wallet/presentation/wallet_screen.dart';
import 'package:app/features/wallet/presentation/widgets/transaction_detail_sheet.dart';
import 'package:app/features/wallet/presentation/widgets/transaction_tile.dart';
import 'package:app/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:app/features/wallet/presentation/widgets/wallet_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WalletScreen Widget Tests', () {
    testWidgets('only amount section loads while card remains visible when walletInfo is loading', (tester) async {
      final walletCompleter = Completer<WalletInfo>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            walletInfoProvider.overrideWith((ref) => walletCompleter.future),
            walletTransactionsProvider.overrideWith((ref) => Future.value([])),
          ],
          child: const MaterialApp(
            home: WalletScreen(),
          ),
        ),
      );

      // Pump initial frame while provider is loading
      await tester.pump();

      // Verify the card itself remains fully rendered
      expect(find.byType(WalletBalanceCard), findsOneWidget);
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('Fund Wallet'), findsOneWidget);
      expect(find.text('Withdraw'), findsOneWidget);

      // Verify only the amount section is in loading state
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.text('₦ 75,000.00'), findsNothing);

      // Complete the future with wallet data
      walletCompleter.complete(const WalletInfo(
        id: 104,
        balance: 75000.0,
        currency: 'NGN',
        isActive: true,
      ));
      await tester.pumpAndSettle();

      // Card remains visible and amount appears
      expect(find.byType(WalletBalanceCard), findsOneWidget);
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('Loading...'), findsNothing);
      expect(find.text('₦ 75,000.00'), findsOneWidget);
    });

    testWidgets('renders WalletScreen with BalanceCard, FilterBar and transactions', (tester) async {
      const testWallet = WalletInfo(
        id: 104,
        balance: 75000.0,
        currency: 'NGN',
        isActive: true,
      );

      final testTransactions = [
        WalletTransaction(
          id: '101',
          walletId: 12,
          referenceNumber: 'DEMO-WALLET-CUSTOMER-12-1',
          amount: 25000.0,
          type: TransactionType.credit,
          status: TransactionStatus.completed,
          transactionType: WalletTransactionType.deposit,
          date: DateTime.now(),
          description: 'Demo Paystack wallet deposit',
          balanceBefore: 0.0,
          balanceAfter: 25000.0,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            walletInfoProvider.overrideWith((ref) => Future.value(testWallet)),
            walletTransactionsProvider.overrideWith((ref) => Future.value(testTransactions)),
          ],
          child: const MaterialApp(
            home: WalletScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Wallet'), findsOneWidget);
      expect(find.byType(WalletBalanceCard), findsOneWidget);
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.byType(WalletFilterBar), findsOneWidget);
      expect(find.text('Deposits'), findsOneWidget);
      expect(find.text('Payments'), findsOneWidget);
      expect(find.byType(TransactionTile), findsOneWidget);
      expect(find.text('Demo Paystack wallet deposit'), findsOneWidget);
    });

    testWidgets('tapping TransactionTile opens TransactionDetailSheet with copyable reference', (tester) async {
      const testWallet = WalletInfo(
        id: 104,
        balance: 75000.0,
        currency: 'NGN',
      );

      final testTransactions = [
        WalletTransaction(
          id: '101',
          walletId: 12,
          referenceNumber: 'DEMO-WALLET-CUSTOMER-12-1',
          amount: 25000.0,
          type: TransactionType.credit,
          status: TransactionStatus.completed,
          transactionType: WalletTransactionType.deposit,
          date: DateTime.now(),
          description: 'Demo Paystack wallet deposit',
          balanceBefore: 0.0,
          balanceAfter: 25000.0,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            walletInfoProvider.overrideWith((ref) => Future.value(testWallet)),
            walletTransactionsProvider.overrideWith((ref) => Future.value(testTransactions)),
          ],
          child: const MaterialApp(
            home: WalletScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap transaction tile
      await tester.tap(find.byType(TransactionTile));
      await tester.pumpAndSettle();

      // Check detail sheet
      expect(find.byType(TransactionDetailSheet), findsOneWidget);
      expect(find.text('Transaction Details'), findsOneWidget);
      expect(find.text('DEMO-WALLET-CUSTOMER-12-1'), findsOneWidget);
      expect(find.text('Deposit'), findsWidgets);
    });
  });
}
