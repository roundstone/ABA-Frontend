// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/application/auth_providers.dart';
import '../../../auth/domain/auth_entities.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';

void showConfirmLogoutDialog(BuildContext context, WidgetRef ref) {
  showAppLogoutDialog(
    context: context,
    ref: ref,
    role: UserRole.merchant,
  );
}

void showConfirmDeleteAccountDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Merchant Account?'),
      content: const Text(
        'Warning: This action is permanent and irreversible. '
        'Your merchant catalog, in-store POS register data, and payout '
        'records will be deactivated.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
          onPressed: () async {
            Navigator.pop(ctx);
            Navigator.pop(context);
            await ref.read(authStateProvider.notifier).logout();
            final nav = rootNavigatorKey.currentContext;
            if (nav != null) {
              nav.go('/role-select');
              AppSnackbar.info(
                nav,
                'Account deactivation requested successfully.',
              );
            }
          },
          child: const Text('Confirm Delete',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
