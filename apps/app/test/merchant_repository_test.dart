import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/merchants/domain/merchant_entities.dart';
import 'package:app/features/merchants/data/merchant_mock_data.dart';
import 'package:app/features/merchants/data/merchant_mock_repository.dart';
import 'package:app/features/merchants/application/merchant_filter_notifier.dart';
import 'package:app/features/merchants/presentation/widgets/merchant_card.dart';

void main() {
  group('MerchantMockRepository Tests', () {
    late MerchantMockRepository repository;

    setUp(() {
      repository = MerchantMockRepository();
    });

    test('getMerchants returns default list with facets', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(),
      );

      expect(result.merchants.isNotEmpty, isTrue);
      expect(result.totalCount, equals(result.merchants.length));
      expect(result.availableStates.contains('Abia'), isTrue);
      expect(result.availableCategories.contains('Fashion & Leather'), isTrue);
    });

    test('getMerchants filters by search query correctly', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(query: 'Leather'),
      );

      expect(result.merchants.isNotEmpty, isTrue);
      for (final m in result.merchants) {
        final matches = m.name.toLowerCase().contains('leather') ||
            m.description.toLowerCase().contains('leather') ||
            m.category.toLowerCase().contains('leather');
        expect(matches, isTrue);
      }
    });

    test('getMerchants filters by category correctly', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(category: 'Shoes & Footwear'),
      );

      expect(result.merchants.isNotEmpty, isTrue);
      for (final m in result.merchants) {
        expect(m.category, equals('Shoes & Footwear'));
      }
    });

    test('getMerchants filters by state correctly', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(state: 'Abia'),
      );

      expect(result.merchants.isNotEmpty, isTrue);
      for (final m in result.merchants) {
        expect(m.state, equals('Abia'));
      }
    });

    test('getMerchants filters by min rating', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(minRating: 4.8),
      );

      expect(result.merchants.isNotEmpty, isTrue);
      for (final m in result.merchants) {
        expect(m.rating, greaterThanOrEqualTo(4.8));
      }
    });

    test('getMerchants filters by verifiedOnly', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(verifiedOnly: true),
      );

      expect(result.merchants.isNotEmpty, isTrue);
      for (final m in result.merchants) {
        expect(m.isVerified, isTrue);
      }
    });

    test('getMerchants sorts by rating', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(sort: MerchantSort.rating),
      );

      for (int i = 0; i < result.merchants.length - 1; i++) {
        expect(
          result.merchants[i].rating >= result.merchants[i + 1].rating,
          isTrue,
        );
      }
    });

    test('getMerchants sorts by orders', () async {
      final result = await repository.getMerchants(
        const MerchantFilterParams(sort: MerchantSort.orders),
      );

      for (int i = 0; i < result.merchants.length - 1; i++) {
        expect(
          result.merchants[i].ordersCount >= result.merchants[i + 1].ordersCount,
          isTrue,
        );
      }
    });

    test('getMerchantById returns correct merchant or null', () async {
      final merchant = await repository.getMerchantById('mer-1');
      expect(merchant, isNotNull);
      expect(merchant!.name, equals('Enyimba Leather Works'));

      final nonExistent = await repository.getMerchantById('m999');
      expect(nonExistent, isNull);
    });
  });

  group('MerchantFilterNotifier Tests', () {
    late MerchantFilterNotifier notifier;

    setUp(() {
      notifier = MerchantFilterNotifier();
    });

    test('initial state has no active filters', () {
      expect(notifier.state.hasActiveFilters, isFalse);
      expect(notifier.state.query, isEmpty);
      expect(notifier.state.sort, equals(MerchantSort.recommended));
    });

    test('setQuery updates search query', () {
      notifier.setQuery('Ariaria');
      expect(notifier.state.query, equals('Ariaria'));
      expect(notifier.state.hasActiveFilters, isTrue);
    });

    test('setCategory updates category', () {
      notifier.setCategory('Textiles & Fabrics');
      expect(notifier.state.category, equals('Textiles & Fabrics'));
      expect(notifier.state.hasActiveFilters, isTrue);
    });

    test('setSort updates sort', () {
      notifier.setSort(MerchantSort.newest);
      expect(notifier.state.sort, equals(MerchantSort.newest));
    });

    test('clearFilters resets all filtering criteria', () {
      notifier.setQuery('Textiles');
      notifier.setCategory('Textiles & Fabrics');
      notifier.setSort(MerchantSort.orders);

      notifier.clearFilters();

      expect(notifier.state.query, isEmpty);
      expect(notifier.state.category, isEmpty);
      expect(notifier.state.sort, equals(MerchantSort.recommended));
      expect(notifier.state.hasActiveFilters, isFalse);
    });
  });

  group('MerchantCard Widget Tests', () {
    testWidgets('MerchantCard renders merchant details without assertion errors',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MerchantCard(merchant: kMockMerchants.first),
            ),
          ),
        ),
      );
      expect(find.text(kMockMerchants.first.name), findsOneWidget);
      expect(find.text('Visit Store'), findsOneWidget);
    });
  });
}
