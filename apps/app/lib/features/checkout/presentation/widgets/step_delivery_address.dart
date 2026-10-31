import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../account/application/address_providers.dart';
import '../../../account/domain/address_entities.dart';
import '../../../account/presentation/widgets/add_address_sheet.dart';
import '../../domain/checkout_entities.dart';
import 'saved_address_tile.dart';

class StepDeliveryAddress extends ConsumerStatefulWidget {
  const StepDeliveryAddress({
    super.key,
    required this.savedAddresses,
    required this.selectedAddress,
    required this.isNewAddressMode,
    required this.onSelectAddress,
    required this.onCustomAddressChanged,
    required this.onToggleNewAddress,
    required this.onBack,
    required this.onContinue,
  });

  final List<CheckoutAddress> savedAddresses;
  final CheckoutAddress? selectedAddress;
  final bool isNewAddressMode;
  final ValueChanged<CheckoutAddress> onSelectAddress;
  final ValueChanged<CheckoutAddress> onCustomAddressChanged;
  final ValueChanged<bool> onToggleNewAddress;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  ConsumerState<StepDeliveryAddress> createState() =>
      _StepDeliveryAddressState();
}

class _StepDeliveryAddressState extends ConsumerState<StepDeliveryAddress> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initAddresses());
  }

  Future<void> _initAddresses() async {
    final current = ref.read(addressesProvider);
    if (current.isEmpty) {
      setState(() => _isLoading = true);
      try {
        await ref.read(addressesProvider.notifier).loadAddresses();
      } catch (_) {}
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showAddAddressDialog() async {
    final created = await showModalBottomSheet<DeliveryAddress>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddAddressSheet(),
    );
    if (created != null && mounted) {
      widget.onSelectAddress(created.toCheckoutAddress());
    }
  }

  void _submit(List<CheckoutAddress> addresses) {
    if (widget.selectedAddress != null) {
      widget.onContinue();
    } else if (addresses.isNotEmpty) {
      final defaultAddr = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
      widget.onSelectAddress(defaultAddr);
      widget.onContinue();
    } else {
      AppSnackbar.error(context, 'Please add a delivery address to continue.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deliveryAddresses = ref.watch(addressesProvider);

    final List<CheckoutAddress> addressList = deliveryAddresses.isNotEmpty
        ? deliveryAddresses.map((a) => a.toCheckoutAddress()).toList()
        : widget.savedAddresses;

    if (widget.selectedAddress == null && addressList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.selectedAddress == null && mounted && addressList.isNotEmpty) {
          final defaultAddr = addressList.firstWhere(
            (a) => a.isDefault,
            orElse: () => addressList.first,
          );
          widget.onSelectAddress(defaultAddr);
        }
      });
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedLocation01,
                color: isDark ? AppColors.secondary : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Delivery Address',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_isLoading && addressList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (addressList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252525) : AppColors.surface2,
                borderRadius: AppSpacing.borderRadiusMD,
              ),
              child: Column(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedLocation01,
                    color: isDark
                        ? AppColors.grey
                        : AppColors.onBackground.withAlpha(120),
                    size: 32,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No delivery addresses saved yet',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Add a delivery address to proceed with checkout.',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton.outlined(
                    label: 'Add Address',
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedAdd01,
                      size: 18,
                      color: isDark ? AppColors.secondary : AppColors.primary,
                    ),
                    onPressed: _showAddAddressDialog,
                  ),
                ],
              ),
            )
          else ...[
            ...addressList.map((addr) {
              final isSelected = widget.selectedAddress?.id == addr.id;
              return SavedAddressTile(
                address: addr,
                isSelected: isSelected,
                onTap: () => widget.onSelectAddress(addr),
              );
            }),
            const SizedBox(height: AppSpacing.xs),
            TextButton.icon(
              onPressed: _showAddAddressDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add a new address'),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  label: 'Back',
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton.primary(
                  label: 'Continue',
                  onPressed: () => _submit(addressList),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
