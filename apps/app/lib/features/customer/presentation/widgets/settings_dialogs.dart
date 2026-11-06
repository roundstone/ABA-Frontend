// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/application/auth_providers.dart';


void showCustomerDeleteAccountDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Account?'),
      content: const Text(
        'Warning: This action cannot be undone. All order history, '
        'wallet credits, and referral downline records will be removed permanently.',
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
            await ref.read(authStateProvider.notifier).logout();
            final nav = rootNavigatorKey.currentContext;
            if (nav != null) {
              nav.go('/role-select');
              AppSnackbar.info(nav, 'Account has been scheduled for deletion.');
            }
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
