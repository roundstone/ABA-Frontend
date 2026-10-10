import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/checkout_entities.dart';

class StepCustomerInfo extends StatefulWidget {
  const StepCustomerInfo({
    super.key,
    required this.initialInfo,
    required this.onContinue,
  });

  final CheckoutCustomerInfo initialInfo;
  final ValueChanged<CheckoutCustomerInfo> onContinue;

  @override
  State<StepCustomerInfo> createState() => _StepCustomerInfoState();
}

class _StepCustomerInfoState extends State<StepCustomerInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstCtrl;
  late final TextEditingController _lastCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _firstCtrl = TextEditingController(text: widget.initialInfo.firstName);
    _lastCtrl = TextEditingController(text: widget.initialInfo.lastName);
    _emailCtrl = TextEditingController(text: widget.initialInfo.email);
    _phoneCtrl = TextEditingController(text: widget.initialInfo.phone);
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onContinue(
        CheckoutCustomerInfo(
          firstName: _firstCtrl.text.trim(),
          lastName: _lastCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
        ),
      );
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: isDark ? AppColors.secondary : AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Contact Information',
                  style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'First Name',
                    controller: _firstCtrl,
                    hintText: 'Jane',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    label: 'Last Name',
                    controller: _lastCtrl,
                    hintText: 'Doe',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Email Address',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              hintText: 'jane.doe@example.com',
              prefixIcon: const Icon(Icons.email_outlined, size: 18),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Phone Number',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              hintText: '+234 801 234 5678',
              prefixIcon: const Icon(Icons.phone_outlined, size: 18),
              validator: (v) => (v == null || v.trim().length < 8)
                  ? 'Enter a valid phone number'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: 'Continue to Address',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
