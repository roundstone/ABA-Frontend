import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/network/list_query_params.dart';
import 'package:app/features/account/application/address_notifier.dart';
import 'package:app/features/account/domain/address_entities.dart';
import 'package:app/features/account/domain/address_repository.dart';

void main() {
  group('DeliveryAddress Entity Tests', () {
    test('fromJson correctly parses integer id, customer_id and numeric zip from backend', () {
      final backendResponse = {
        'id': 13,
        'customer_id': 29,
        'name': 'Home',
        'street': '12 Faulks Road',
        'city': 'Aba',
        'state': 'Abia',
        'zip': 450001,
        'createdAt': '2026-10-23T05:56:58.947Z',
        'updatedAt': '2026-10-23T05:56:58.947Z',
      };

      final address = DeliveryAddress.fromJson(backendResponse);

      expect(address.id, equals('13'));
      expect(address.customerId, equals('29'));
      expect(address.name, equals('Home'));
      expect(address.street, equals('12 Faulks Road'));
      expect(address.city, equals('Aba'));
      expect(address.state, equals('Abia'));
      expect(address.zip, equals('450001'));
      expect(address.createdAt, isA<DateTime>());
      expect(address.updatedAt, isA<DateTime>());

      final checkout = address.toCheckoutAddress();
      expect(checkout.id, equals('13'));
      expect(checkout.label, equals('Home'));
      expect(checkout.street, equals('12 Faulks Road'));
    });

    test('fromJson handles string IDs and snake_case timestamps', () {
      final json = {
        'id': 'addr_100',
        'customer_id': 'cust_200',
        'name': 'Office',
        'street': 'Commercial Avenue',
        'city': 'Aba',
        'state': 'Abia',
        'zip': '450002',
        'phone': '+2348011223344',
        'is_default': true,
        'created_at': '2026-10-23T01:00:00.000Z',
        'updated_at': '2026-10-23T01:00:00.000Z',
      };

      final address = DeliveryAddress.fromJson(json);

      expect(address.id, equals('addr_100'));
      expect(address.customerId, equals('cust_200'));
      expect(address.phone, equals('+2348011223344'));
      expect(address.isDefault, isTrue);

      final copy = address.copyWith(isDefault: false);
      expect(copy.isDefault, isFalse);
      expect(copy.name, equals('Office'));
    });
  });

  group('AddressNotifier with ListQueryParams Tests', () {
    test('loadAddresses uses default ListQueryParams and populates state', () async {
      final mockRepo = _MockAddressRepository();
      final now = DateTime(2026, 10, 24);
      mockRepo.items = [
        DeliveryAddress(
          id: '1',
          customerId: '29',
          name: 'Home',
          street: '1 Market Rd',
          city: 'Aba',
          state: 'Abia',
          zip: '450001',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final notifier = AddressNotifier(repository: mockRepo);
      await notifier.loadAddresses();

      expect(notifier.state.length, equals(1));
      expect(notifier.state.first.id, equals('1'));
      expect(mockRepo.lastParams?.orderBy, equals('createdAt:DESC'));
    });

    test('searchAddresses updates queryParams with search term', () async {
      final mockRepo = _MockAddressRepository();
      final notifier = AddressNotifier(repository: mockRepo);

      await notifier.searchAddresses('Faulks');
      expect(notifier.queryParams.search, equals('Faulks'));
      expect(mockRepo.lastParams?.search, equals('Faulks'));
    });

    test('sortAddresses updates queryParams order and direction', () async {
      final mockRepo = _MockAddressRepository();
      final notifier = AddressNotifier(repository: mockRepo);

      await notifier.sortAddresses('createdAt', SortDirection.asc);
      expect(notifier.queryParams.orderBy, equals('createdAt:ASC'));
      expect(notifier.queryParams.sortDirection, equals(SortDirection.asc));
      expect(mockRepo.lastParams?.orderBy, equals('createdAt:ASC'));
    });

    test('filterByActive updates queryParams isActive', () async {
      final mockRepo = _MockAddressRepository();
      final notifier = AddressNotifier(repository: mockRepo);

      await notifier.filterByActive(true);
      expect(notifier.queryParams.isActive, isTrue);
      expect(mockRepo.lastParams?.isActive, isTrue);
    });

    test('setDefault updates isDefault in state', () async {
      final mockRepo = _MockAddressRepository();
      final now = DateTime(2026, 10, 24);
      mockRepo.items = [
        DeliveryAddress(
          id: '1',
          customerId: '29',
          name: 'Home',
          street: '1 Rd',
          city: 'Aba',
          state: 'Abia',
          zip: '1',
          createdAt: now,
          updatedAt: now,
        ),
        DeliveryAddress(
          id: '2',
          customerId: '29',
          name: 'Work',
          street: '2 Rd',
          city: 'Aba',
          state: 'Abia',
          zip: '2',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final notifier = AddressNotifier(repository: mockRepo);
      await notifier.loadAddresses();

      notifier.setDefault('2');
      expect(notifier.state.firstWhere((a) => a.id == '1').isDefault, isFalse);
      expect(notifier.state.firstWhere((a) => a.id == '2').isDefault, isTrue);
    });

    test('loadMore fetches page 2 and appends items to state', () async {
      final mockRepo = _MockAddressRepository();
      final now = DateTime(2026, 10, 24);
      final page1Items = List.generate(
        10,
        (i) => DeliveryAddress(
          id: 'p1_$i',
          customerId: '29',
          name: 'Addr $i',
          street: 'Street $i',
          city: 'Aba',
          state: 'Abia',
          zip: '45000$i',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final page2Items = [
        DeliveryAddress(
          id: 'p2_0',
          customerId: '29',
          name: 'Page 2 Addr',
          street: 'New Street',
          city: 'Aba',
          state: 'Abia',
          zip: '450099',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      mockRepo.items = page1Items;
      final notifier = AddressNotifier(repository: mockRepo);
      await notifier.loadAddresses(params: const ListQueryParams(limit: 10));

      expect(notifier.state.length, equals(10));
      expect(notifier.hasMore, isTrue);

      // Now set repository items to page 2 items
      mockRepo.items = page2Items;
      await notifier.loadMore();

      expect(notifier.state.length, equals(11));
      expect(notifier.state.last.id, equals('p2_0'));
      expect(notifier.queryParams.page, equals(2));
      expect(notifier.hasMore, isFalse); // Fewer than limit (10)
    });
  });
}

class _MockAddressRepository implements AddressRepository {
  ListQueryParams? lastParams;
  List<DeliveryAddress> items = [];

  @override
  Future<List<DeliveryAddress>> getAddresses({ListQueryParams? params}) async {
    lastParams = params;
    return items;
  }

  @override
  Future<DeliveryAddress> createAddress(DeliveryAddress address) async {
    items.add(address);
    return address;
  }

  @override
  Future<void> deleteAddress(String id) async {
    items.removeWhere((a) => a.id == id);
  }

  @override
  Future<DeliveryAddress> updateAddress(String id, DeliveryAddress address) async {
    return address;
  }
}
