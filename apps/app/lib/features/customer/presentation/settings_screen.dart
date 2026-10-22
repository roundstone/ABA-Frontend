import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/widgets/theme_mode_dialog.dart';
import '../../../core/notifications/notification_debug_sheet.dart';
import '../../../core/notifications/notification_topics_service.dart';
import '../../auth/application/auth_providers.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/settings_dialogs.dart';
import 'widgets/settings_user_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = true;
  bool _biometrics = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final themeMode = ref.watch(themeModeProvider);
    final user = auth.user;
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
          onPressed: () {
            final fallback = ref.read(authStateProvider).isMerchant ? '/merchant' : '/home';
            context.popOrGo(fallback);
          },
        ),
        title: const Text('Settings'),
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final fallback = ref.read(authStateProvider).isMerchant ? '/merchant' : '/home';
          context.popOrGo(fallback);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            SettingsUserCard(
              user: user,
              isDark: isDark,
              onEditProfile: () => showEditProfileSheet(context),
            ),
            const SizedBox(height: AppSpacing.lg),

            const _SectionTitle(title: 'App Preferences'),
            ListTile(
              leading: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.dark_mode_outlined
                    : (themeMode == ThemeMode.light
                          ? Icons.light_mode_outlined
                          : Icons.brightness_auto_outlined),
                size: 20,
              ),
              title: const Text('Theme Mode'),
              subtitle: Text(
                themeMode == ThemeMode.dark
                    ? 'Dark Mode'
                    : (themeMode == ThemeMode.light
                          ? 'Light Mode'
                          : 'System Default'),
              ),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => showThemeModeDialog(context, ref),
            ),
            SwitchListTile.adaptive(
              title: const Text('Push Notifications'),
              subtitle: const Text('Order tracking and promo alerts'),
              value: _pushNotifications,
              onChanged: (v) {
                setState(() => _pushNotifications = v);
                final isMerchant = ref.read(authStateProvider).isMerchant;
                NotificationTopicsService.instance.syncUserTopics(
                  isMerchant: isMerchant,
                  promotionsEnabled: v,
                  ordersEnabled: v,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined, size: 20),
              title: const Text('Push Diagnostics & Live Test'),
              subtitle: const Text('View device FCM token & simulate flows'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => NotificationDebugSheet.show(context),
            ),
            SwitchListTile.adaptive(
              title: const Text('Email Updates'),
              subtitle: const Text('Receipts and monthly summary'),
              value: _emailUpdates,
              onChanged: (v) => setState(() => _emailUpdates = v),
            ),
            const ListTile(
              leading: Icon(Icons.currency_exchange, size: 20),
              title: Text('Currency'),
              trailing: Text(
                'NGN (₦)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            const _SectionTitle(title: 'Security'),
            SwitchListTile.adaptive(
              title: const Text('Biometric Login'),
              subtitle: const Text('Use FaceID / Fingerprint to open app'),
              value: _biometrics,
              onChanged: (v) => setState(() => _biometrics = v),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline, size: 20),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {
                final user = ref.read(currentUserProvider);
                final emailParam = user?.email.isNotEmpty == true
                    ? Uri.encodeComponent(user!.email)
                    : '';
                context.push('/forgot-password?role=customer&email=$emailParam');
              },
            ),
            const SizedBox(height: AppSpacing.md),

            const _SectionTitle(title: 'About & Support'),
            ListTile(
              leading: const Icon(Icons.help_outline, size: 20),
              title: const Text('Help & Customer Support'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined, size: 20),
              title: const Text('Terms of Service & Privacy'),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {},
            ),
            const ListTile(
              leading: Icon(Icons.info_outline, size: 20),
              title: Text('App Version'),
              trailing: Text(
                'v1.0.0 (Build 2026)',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            const _SectionTitle(title: 'Account Actions'),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedLogout01,
                color: AppColors.error,
                size: 18,
              ),
              label: const Text('Logout Account'),
              onPressed: () => showCustomerLogoutDialog(context, ref),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              icon: const Icon(Icons.delete_forever_outlined, size: 18),
              label: const Text('Delete Account Permanently'),
              onPressed: () => showCustomerDeleteAccountDialog(context, ref),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.xs,
        top: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.caption.copyWith(
          letterSpacing: 1.1,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
