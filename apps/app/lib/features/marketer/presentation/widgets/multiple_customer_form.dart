import 'dart:math';
import 'package:app/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../application/marketer_providers.dart';
import 'multiple_customer_card.dart';
import 'onboarding_success_dialog.dart';

class MultipleCustomerForm extends ConsumerStatefulWidget {
  const MultipleCustomerForm({
    super.key,
    required this.referralCode,
    this.onCountChanged,
  });

  final String referralCode;
  final ValueChanged<int>? onCountChanged;

  @override
  ConsumerState<MultipleCustomerForm> createState() =>
      MultipleCustomerFormState();
}

class MultipleCustomerFormState extends ConsumerState<MultipleCustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final List<CustomerRowData> _rows = [];
  int _counter = 0;

  int get customerCount => _rows.length;

  @override
  void initState() {
    super.initState();
    _addRow();
    _addRow();
  }

  void addRow() {
    setState(_addRow);
    widget.onCountChanged?.call(_rows.length);
  }

  void _addRow() {
    final rand = 1000 + Random().nextInt(9000);
    _rows.add(
      CustomerRowData(id: ++_counter, defaultPassword: 'AbaCust@$rand'),
    );
  }

  void _removeRow(int index) {
    if (_rows.length <= 1) return;
    final row = _rows.removeAt(index);
    row.dispose();
    widget.onCountChanged?.call(_rows.length);
    setState(() {});
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final inputs = _rows.map((row) {
      return OnboardCustomerInput(
        fullName: row.nameController.text.trim(),
        email: row.emailController.text.trim(),
        phone: row.phoneController.text.trim(),
        password: row.defaultPassword,
        referralCode: widget.referralCode,
      );
    }).toList();

    final results = await ref
        .read(marketerOnboardingProvider.notifier)
        .registerMultipleCustomers(inputs);

    if (!mounted) return;

    final successes = results.where((r) => r.success).toList();
    if (successes.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => OnboardingSuccessDialog(results: results),
      );
    } else {
      AppSnackbar.error(
        context,
        'Failed to onboard customers. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(marketerOnboardingProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customers to Onboard (${_rows.length})',
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
              ),
              TextButton.icon(
                onPressed: addRow,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Another'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) => MultipleCustomerCard(
              index: index,
              row: _rows[index],
              canDelete: _rows.length > 1,
              onDelete: () => _removeRow(index),
              isDark: isDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: addRow,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Another Customer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusMD,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Register All (${_rows.length}) Customers',
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
