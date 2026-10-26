import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/network/list_query_params.dart';

void main() {
  group('ListQueryParams Tests', () {
    test('default values are page: 1, limit: 10, orderBy: createdAt:DESC', () {
      const params = ListQueryParams();
      expect(params.page, equals(1));
      expect(params.limit, equals(10));
      expect(params.search, isNull);
      expect(params.startDate, isNull);
      expect(params.endDate, isNull);
      expect(params.orderBy, equals('createdAt:DESC'));
      expect(params.isActive, isNull);
      expect(params.categoryId, isNull);
      expect(params.includeVariants, isNull);
      expect(params.customParams, isEmpty);

      final map = params.toMap();
      expect(map, equals({'page': 1, 'limit': 10, 'orderBy': 'createdAt:DESC'}));
    });

    test('serializes free-text search term correctly', () {
      const params = ListQueryParams(search: 'Adeyemi');
      final map = params.toMap();
      expect(map['search'], equals('Adeyemi'));
      expect(map['page'], equals(1));
      expect(map['limit'], equals(10));
      expect(map['orderBy'], equals('createdAt:DESC'));
    });

    test('formats startDate and endDate to YYYY-MM-DD string', () {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 1, 31);
      final params = ListQueryParams(startDate: start, endDate: end);

      expect(params.startDateString, equals('2026-01-01'));
      expect(params.endDateString, equals('2026-01-31'));

      final map = params.toMap();
      expect(map['startDate'], equals('2026-01-01'));
      expect(map['endDate'], equals('2026-01-31'));
    });

    test('handles orderBy expressions and parses sortField and sortDirection', () {
      const descParams = ListQueryParams(orderBy: 'createdAt:DESC');
      expect(descParams.sortField, equals('createdAt'));
      expect(descParams.sortDirection, equals(SortDirection.desc));
      expect(descParams.toMap()['orderBy'], equals('createdAt:DESC'));

      const ascParams = ListQueryParams(orderBy: 'amount:ASC');
      expect(ascParams.sortField, equals('amount'));
      expect(ascParams.sortDirection, equals(SortDirection.asc));

      final orderedFactory = ListQueryParams.ordered(
        field: 'createdAt',
        direction: SortDirection.desc,
      );
      expect(orderedFactory.orderBy, equals('createdAt:DESC'));
    });

    test('serializes isActive, categoryId, and includeVariants query parameters', () {
      const params = ListQueryParams(
        isActive: true,
        categoryId: 3,
        includeVariants: true,
      );

      final map = params.toMap();
      expect(map['isActive'], isTrue);
      expect(map['categoryId'], equals(3));
      expect(map['includeVariants'], isTrue);

      final queryStr = params.toQueryString();
      expect(queryStr, contains('isActive=true'));
      expect(queryStr, contains('categoryId=3'));
      expect(queryStr, contains('includeVariants=true'));
    });

    test('serializes complete sample dataset matching backend specification', () {
      final params = ListQueryParams(
        page: 1,
        limit: 10,
        search: 'Adeyemi',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
        orderBy: 'createdAt:DESC',
        isActive: true,
        categoryId: 3,
        includeVariants: true,
      );

      final map = params.toMap();
      expect(
        map,
        equals({
          'page': 1,
          'limit': 10,
          'search': 'Adeyemi',
          'startDate': '2026-01-01',
          'endDate': '2026-01-31',
          'orderBy': 'createdAt:DESC',
          'isActive': true,
          'categoryId': 3,
          'includeVariants': true,
        }),
      );

      final queryString = params.toQueryString();
      expect(queryString, contains('page=1'));
      expect(queryString, contains('limit=10'));
      expect(queryString, contains('search=Adeyemi'));
      expect(queryString, contains('startDate=2026-01-01'));
      expect(queryString, contains('endDate=2026-01-31'));
      expect(queryString, contains('orderBy=createdAt%3ADESC'));
      expect(queryString, contains('isActive=true'));
      expect(queryString, contains('categoryId=3'));
      expect(queryString, contains('includeVariants=true'));
    });

    test('supports custom query parameters and endpoint-specific filters', () {
      final params = const ListQueryParams()
          .withParam('status', 'PAID')
          .withParam('merchantId', 'mer-501');

      expect(params['status'], equals('PAID'));
      expect(params['merchantId'], equals('mer-501'));

      final map = params.toMap();
      expect(map['status'], equals('PAID'));
      expect(map['merchantId'], equals('mer-501'));

      final cleared = params.withParam('status', null);
      expect(cleared['status'], isNull);
    });

    test('fromJson deserializes standard keys and captures custom filters', () {
      final json = {
        'page': '2',
        'limit': 20,
        'search': 'Chisom',
        'startDate': '2026-02-01',
        'endDate': '2026-02-28',
        'orderBy': 'name:ASC',
        'isActive': 'true',
        'categoryId': '3',
        'includeVariants': '1',
        'role': 'merchant',
      };

      final params = ListQueryParams.fromJson(json);
      expect(params.page, equals(2));
      expect(params.limit, equals(20));
      expect(params.search, equals('Chisom'));
      expect(params.startDateString, equals('2026-02-01'));
      expect(params.endDateString, equals('2026-02-28'));
      expect(params.orderBy, equals('name:ASC'));
      expect(params.sortField, equals('name'));
      expect(params.sortDirection, equals(SortDirection.asc));
      expect(params.isActive, isTrue);
      expect(params.categoryId, equals(3));
      expect(params.includeVariants, isTrue);
      expect(params['role'], equals('merchant'));
    });

    test('fromUri parses URI query parameters', () {
      final uri = Uri.parse(
        'https://aba-erp-backend.onrender.com/api/v1/products?page=3&limit=15&search=Adeyemi&categoryId=3&isActive=true&includeVariants=true&orderBy=createdAt:DESC',
      );
      final params = ListQueryParams.fromUri(uri);
      expect(params.page, equals(3));
      expect(params.limit, equals(15));
      expect(params.search, equals('Adeyemi'));
      expect(params.categoryId, equals(3));
      expect(params.isActive, isTrue);
      expect(params.includeVariants, isTrue);
      expect(params.orderBy, equals('createdAt:DESC'));
    });

    test('fluent helpers withActive, withCategory, and withVariants work correctly', () {
      const initial = ListQueryParams(page: 3);
      final active = initial.withActive(true);
      expect(active.isActive, isTrue);
      expect(active.page, equals(1)); // resets to page 1

      final category = initial.withCategory(5);
      expect(category.categoryId, equals(5));
      expect(category.page, equals(1)); // resets to page 1

      final variants = initial.withVariants(true);
      expect(variants.includeVariants, isTrue);
      expect(variants.page, equals(3)); // preserves page
    });

    test('pagination helpers work correctly', () {
      const initial = ListQueryParams(page: 1, limit: 10);
      final next = initial.nextPage();
      expect(next.page, equals(2));
      expect(next.limit, equals(10));

      final prev = next.previousPage();
      expect(prev.page, equals(1));

      final reset = next.resetPage();
      expect(reset.page, equals(1));

      final withSearch = next.withSearch('Shoes');
      expect(withSearch.search, equals('Shoes'));
      expect(withSearch.page, equals(1)); // resets to page 1

      final withSort = initial.withSort('price', SortDirection.asc);
      expect(withSort.orderBy, equals('price:ASC'));
    });

    test('value equality and hashCode are consistent', () {
      final a = ListQueryParams(
        page: 1,
        limit: 10,
        search: 'Adeyemi',
        startDate: DateTime(2026, 1, 1),
        orderBy: 'createdAt:DESC',
        isActive: true,
        categoryId: 3,
        includeVariants: true,
      );
      final b = ListQueryParams(
        page: 1,
        limit: 10,
        search: 'Adeyemi',
        startDate: DateTime(2026, 1, 1),
        orderBy: 'createdAt:DESC',
        isActive: true,
        categoryId: 3,
        includeVariants: true,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
