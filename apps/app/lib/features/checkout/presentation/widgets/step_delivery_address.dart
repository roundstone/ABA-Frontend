import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/checkout_entities.dart';
import 'saved_address_tile.dart';

class StepDeliveryAddress extends StatefulWidget {
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
  State<StepDeliveryAddress> createState() => _StepDeliveryAddressState();
}

class _StepDeliveryAddressState extends State<StepDeliveryAddress> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _zipCtrl;

  @override
  void initState() {
    super.initState();
    final initial = widget.selectedAddress;
    _streetCtrl = TextEditingController(text: initial?.street ?? '');
    _cityCtrl = TextEditingController(text: initial?.city ?? 'Lagos');
    _stateCtrl = TextEditingController(text: initial?.state ?? 'Lagos');
    _zipCtrl = TextEditingController(text: initial?.zipCode ?? '101241');
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isNewAddressMode) {
      if (_formKey.currentState?.validate() ?? false) {
        widget.onCustomAddressChanged(
          CheckoutAddress(
            id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
            label: 'Custom Address',
            fullName: widget.selectedAddress?.fullName ?? 'Jane Doe',
            street: _streetCtrl.text.trim(),
            city: _cityCtrl.text.trim(),
            state: _stateCtrl.text.trim(),
            zipCode: _zipCtrl.text.trim(),
            phone: widget.selectedAddress?.phone ?? '+234 801 234 5678',
          ),
        );
        widget.onContinue();
      }
    } else {
      if (widget.selectedAddress != null) {
        widget.onContinue();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          if (!widget.isNewAddressMode) ...[
            ...widget.savedAddresses.map((addr) {
              final isSelected = widget.selectedAddress?.id == addr.id;
              return SavedAddressTile(
                address: addr,
                isSelected: isSelected,
                onTap: () => widget.onSelectAddress(addr),
              );
            }),
            TextButton.icon(
              onPressed: () => widget.onToggleNewAddress(true),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add a new address'),
            ),
          ] else ...[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Street Address',
                    controller: _streetCtrl,
                    hintText: '123 Market Street, Victoria Island',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'City',
                          controller: _cityCtrl,
                          hintText: 'Lagos',
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          label: 'State',
                          controller: _stateCtrl,
                          hintText: 'Lagos',
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: 'Postal / Zip Code',
                    controller: _zipCtrl,
                    hintText: '101241',
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => widget.onToggleNewAddress(false),
                      child: const Text('Use saved address instead'),
                    ),
                  ),
                ],
              ),
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
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
