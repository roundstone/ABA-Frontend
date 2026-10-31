import 'package:app/features/account/application/address_notifier.dart';
import 'package:app/features/account/application/address_providers.dart';
import 'package:app/features/account/domain/address_entities.dart';
import 'package:app/features/account/presentation/widgets/add_address_sheet.dart';
import 'package:app/features/checkout/presentation/widgets/step_delivery_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testDeliveryAddress = DeliveryAddress(
    id: 'addr_1',
    customerId: 'cust_1',
    name: 'Home',
    street: '123 Market Street',
    city: 'Aba',
    state: 'Abia',
    zip: '450001',
    phone: '+234 801 234 5678',
    isDefault: true,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  testWidgets('StepDeliveryAddress pulls and renders delivery addresses from addressesProvider', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          addressesProvider.overrideWith(
            (ref) => AddressNotifierMock([testDeliveryAddress]),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: StepDeliveryAddress(
              savedAddresses: const [],
              selectedAddress: testDeliveryAddress.toCheckoutAddress(),
              isNewAddressMode: false,
              onSelectAddress: (_) {},
              onCustomAddressChanged: (_) {},
              onToggleNewAddress: (_) {},
              onBack: () {},
              onContinue: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Delivery Address'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('123 Market Street'), findsOneWidget);
    expect(find.text('Add a new address'), findsOneWidget);
  });

  testWidgets('Tapping Add a new address opens shared AddAddressSheet modal', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          addressesProvider.overrideWith(
            (ref) => AddressNotifierMock([testDeliveryAddress]),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: StepDeliveryAddress(
              savedAddresses: const [],
              selectedAddress: testDeliveryAddress.toCheckoutAddress(),
              isNewAddressMode: false,
              onSelectAddress: (_) {},
              onCustomAddressChanged: (_) {},
              onToggleNewAddress: (_) {},
              onBack: () {},
              onContinue: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap 'Add a new address'
    await tester.tap(find.text('Add a new address'));
    await tester.pumpAndSettle();

    // Verify AddAddressSheet modal is shown
    expect(find.byType(AddAddressSheet), findsOneWidget);
    expect(find.text('Add Delivery Address'), findsOneWidget);
  });
}

class AddressNotifierMock extends StateNotifier<List<DeliveryAddress>>
    implements AddressNotifier {
  AddressNotifierMock(super.initial);

  @override
  bool get hasMore => false;

  @override
  bool get isLoadingMore => false;

  @override
  Future<void> loadAddresses({dynamic params}) async {}

  @override
  Future<DeliveryAddress> createAddress(DeliveryAddress address) async {
    final created = address.copyWith(id: 'new_${DateTime.now().millisecondsSinceEpoch}');
    state = [...state, created];
    return created;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
