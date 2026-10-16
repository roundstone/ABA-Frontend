import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/application/auth_providers.dart';

void showConfirmLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Logout Merchant?'),
      content: const Text(
        'Are you sure you want to sign out of your merchant portal?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () {
            Navigator.pop(ctx);
            Navigator.pop(context);
            ref.read(authStateProvider.notifier).logout();
            context.go('/role-select');
          },
          child: const Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
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
          onPressed: () {
            Navigator.pop(ctx);
            Navigator.pop(context);
            ref.read(authStateProvider.notifier).logout();
            context.go('/role-select');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account deactivation requested successfully.'),
              ),
            );
          },
          child: const Text('Confirm Delete',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
