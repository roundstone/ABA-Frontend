import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/application/auth_providers.dart';

void showEditProfileSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(140),
    builder: (_) => const _EditProfileModal(),
  );
}

class _EditProfileModal extends ConsumerStatefulWidget {
  const _EditProfileModal();

  @override
  ConsumerState<_EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends ConsumerState<_EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bizCtrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _bizCtrl = TextEditingController(text: user?.businessName ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _bizCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMerchant = ref.watch(isMerchantProvider);
    final sheetBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Profile',
                  style: AppTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Full name is required' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
              ),
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Phone number is required'
                  : null,
            ),
            if (isMerchant) ...[
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _bizCtrl,
                decoration: const InputDecoration(
                  labelText: 'Business / Store Name',
                  prefixIcon: Icon(Icons.storefront_outlined, size: 20),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Business name is required'
                    : null,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  ref.read(authStateProvider.notifier).updateProfile(
                        name: _nameCtrl.text.trim(),
                        phone: _phoneCtrl.text.trim(),
                        businessName: isMerchant ? _bizCtrl.text.trim() : null,
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                }
              },
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
