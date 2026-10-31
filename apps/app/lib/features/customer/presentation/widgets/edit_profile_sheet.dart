import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/application/auth_providers.dart';

void showEditProfileSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(140),
    builder: (_) => const EditProfileModal(),
  );
}

class EditProfileModal extends ConsumerStatefulWidget {
  const EditProfileModal({super.key});

  @override
  ConsumerState<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends ConsumerState<EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bizCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _bizCtrl = TextEditingController(text: user?.businessName ?? '');

    // Fetch fresh profile from GET /api/v1/profile/mobile-app
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  Future<void> _loadProfile() async {
    final fresh = await ref.read(authStateProvider.notifier).fetchProfile();
    if (fresh != null && mounted) {
      if (fresh.name.isNotEmpty) {
        _nameCtrl.text = fresh.name;
      }
      if (fresh.phone.isNotEmpty) {
        _phoneCtrl.text = fresh.phone;
      }
      if (fresh.email.isNotEmpty) {
        _emailCtrl.text = fresh.email;
      }
      if (fresh.businessName != null && fresh.businessName!.isNotEmpty) {
        _bizCtrl.text = fresh.businessName!;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _bizCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final isMerchant = ref.read(isMerchantProvider);

    try {
      await ref.read(authStateProvider.notifier).updateProfile(
            name: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            businessName: isMerchant ? _bizCtrl.text.trim() : null,
          );
      if (!mounted) return;
      Navigator.pop(context);
      AppSnackbar.success(context, 'Profile updated successfully!');
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiError ? e.message : e.toString().replaceAll('Exception: ', '');
      AppSnackbar.error(context, msg);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
            AppTextField(
              label: 'Full Name',
              hintText: 'Enter your full name',
              controller: _nameCtrl,
              prefixIcon: const Icon(Icons.person_outline, size: 20),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Full name is required' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Phone Number',
              hintText: 'e.g. +234 801 234 5678',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined, size: 20),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Phone number is required' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Email Address',
              controller: _emailCtrl,
              readOnly: true,
              enabled: false,
              prefixIcon: const Icon(Icons.email_outlined, size: 20),
            ),
            if (isMerchant) ...[
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Business / Store Name',
                hintText: 'Enter your business name',
                controller: _bizCtrl,
                prefixIcon: const Icon(Icons.storefront_outlined, size: 20),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Business name is required' : null,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: 'Save Changes',
              isLoading: _isSaving,
              onPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
