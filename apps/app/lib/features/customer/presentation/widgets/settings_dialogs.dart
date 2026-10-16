import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/application/auth_providers.dart';

void showCustomerLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Logout Account?'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () {
            Navigator.pop(ctx);
            ref.read(authStateProvider.notifier).logout();
            context.go('/role-select');
          },
          child: const Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
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
