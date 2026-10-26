import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/address_providers.dart';
import '../../domain/address_entities.dart';

class AddAddressSheet extends ConsumerStatefulWidget {
  const AddAddressSheet({super.key});

  @override
  ConsumerState<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends ConsumerState<AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _labelCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _phoneCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: 'Home');
    _streetCtrl = TextEditingController();
    _cityCtrl = TextEditingController(text: 'Aba');
    _stateCtrl = TextEditingController(text: 'Abia');
    _phoneCtrl = TextEditingController(text: '+234 ');
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final address = DeliveryAddress(
        id: '',
        customerId: '',
        name: _labelCtrl.text.trim().isEmpty ? 'Home' : _labelCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        state: _stateCtrl.text.trim(),
        zip: '450001',
        phone: _phoneCtrl.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(addressesProvider.notifier).createAddress(address);

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address saved successfully.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Failed to save address: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save address: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLG),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Add Delivery Address',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Address Label',
                hintText: 'e.g. Home, Office',
                controller: _labelCtrl,
                prefixIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedTag01,
                  color: AppColors.grey,
                  size: 16,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Street Address',
                hintText: 'Enter your street address',
                controller: _streetCtrl,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Street address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'City',
                      hintText: 'Enter city',
                      controller: _cityCtrl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'City is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      label: 'State',
                      hintText: 'Enter state',
                      controller: _stateCtrl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'State is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Contact Phone',
                hintText: 'Enter contact phone number',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCall,
                  color: AppColors.grey,
                  size: 16,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: _isSaving ? 'Saving...' : 'Save Address',
                isLoading: _isSaving,
                onPressed: _isSaving ? null : _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
