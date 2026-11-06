import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../application/auth_providers.dart';

Future<void> confirmLogout(BuildContext context, WidgetRef ref) async {
  // Capture the notifier before the dialog opens.
  final authNotifier = ref.read(authStateProvider.notifier);

  final confirmed = await AppConfirmDialog.show(
    context,
    title: 'Confirm Logout',
    message: 'Are you sure you want to log out of your account?',
    confirmText: 'Log Out',
    confirmColor: AppColors.error,
    isDestructive: true,
    onConfirm: () {},
  );

  if (!confirmed) return;

  // Navigate using the root navigator.
  final nav = rootNavigatorKey.currentContext ?? context;

  if (nav.mounted) {
    GoRouter.of(nav).go('/role-select');
  }

  // No more ref access after the async gap.
  await authNotifier.logout();
}
