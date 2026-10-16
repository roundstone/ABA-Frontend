import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../checkout/domain/checkout_entities.dart';
import 'widgets/address_card.dart';

final savedAddressesProvider =
    StateNotifierProvider<SavedAddressesNotifier, List<CheckoutAddress>>((ref) {
      return SavedAddressesNotifier();
    });

class SavedAddressesNotifier extends StateNotifier<List<CheckoutAddress>> {
  SavedAddressesNotifier()
    : super([
        const CheckoutAddress(
          id: 'addr_1',
          label: 'Home',
          fullName: 'Jane Doe',
          street: '123 Market Street, Victoria Island',
          city: 'Lagos',
          state: 'Lagos',
          zipCode: '101241',
          phone: '+234 801 234 5678',
          isDefault: true,
        ),
        const CheckoutAddress(
          id: 'addr_2',
          label: 'Office / Store',
          fullName: 'Jane Doe',
          street: '45 Faulks Road, Ariaria Market',
          city: 'Aba',
          state: 'Abia',
          zipCode: '450211',
          phone: '+234 801 234 5678',
          isDefault: false,
        ),
      ]);

  void addAddress(CheckoutAddress address) {
    if (address.isDefault) {
      state = state.map((a) => a.copyWith(isDefault: false)).toList();
    }
    state = [...state, address];
  }

  void removeAddress(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  void setDefault(String id) {
    state = state.map((a) => a.copyWith(isDefault: a.id == id)).toList();
  }
}

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(savedAddressesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () => context.popOrGo('/home'),
        ),
        title: const Text('Saved Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Address',
            onPressed: () => _showAddDialog(context, ref),
          ),
        ],
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.popOrGo('/home');
        },
        child: addresses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No saved addresses yet',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => _showAddDialog(context, ref),
                      child: const Text('Add New Address'),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: addresses.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final addr = addresses[index];
                  return AddressCard(
                    address: addr,
                    isDark: isDark,
                    onSetDefault: () => ref
                        .read(savedAddressesProvider.notifier)
                        .setDefault(addr.id),
                    onDelete: () => ref
                        .read(savedAddressesProvider.notifier)
                        .removeAddress(addr.id),
                  );
                },
              ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final labelCtrl = TextEditingController(text: 'Home');
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Aba');
    final stateCtrl = TextEditingController(text: 'Abia');
    final phoneCtrl = TextEditingController(text: '+234 ');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Delivery Address', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: labelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Label (e.g. Home, Office)',
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: streetCtrl,
                decoration: const InputDecoration(labelText: 'Street Address'),
                validator: (v) => v == null || v.isEmpty
                    ? 'Street address is required'
                    : null,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      controller: stateCtrl,
                      decoration: const InputDecoration(labelText: 'State'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Contact Phone'),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    ref
                        .read(savedAddressesProvider.notifier)
                        .addAddress(
                          CheckoutAddress(
                            id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
                            label: labelCtrl.text.trim(),
                            fullName: 'Jane Doe',
                            street: streetCtrl.text.trim(),
                            city: cityCtrl.text.trim(),
                            state: stateCtrl.text.trim(),
                            zipCode: '450001',
                            phone: phoneCtrl.text.trim(),
                            isDefault: false,
                          ),
                        );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
