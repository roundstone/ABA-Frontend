import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/application/auth_providers.dart';
import '../../../auth/domain/auth_entities.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';

void showCustomerLogoutDialog(BuildContext context, WidgetRef ref) {
  showAppLogoutDialog(
    context: context,
    ref: ref,
    role: UserRole.customer,
  );
}

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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
          ),
          onPressed: () {
            Navigator.pop(ctx);
            ref.read(authStateProvider.notifier).logout();
            context.go('/role-select');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account has been scheduled for deletion.'),
              ),
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
