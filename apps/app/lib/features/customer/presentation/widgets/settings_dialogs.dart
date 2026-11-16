// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/application/auth_providers.dart';

void showCustomerDeleteAccountDialog(BuildContext context, WidgetRef ref) {
  showDialog<void>(
    context: context,
    builder: (ctx) {
      var isDeleting = false;
      return StatefulBuilder(
        builder: (dialogCtx, setState) => AlertDialog(
          title: const Text('Delete Account?'),
          content: const Text(
            'Warning: This action cannot be undone. All order history, '
            'wallet credits, and referral downline records will be removed permanently.',
          ),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
              ),
              onPressed: isDeleting
                  ? null
                  : () async {
                      setState(() => isDeleting = true);
                      final ok = await ref
                          .read(authStateProvider.notifier)
                          .deleteProfile();
                      if (ctx.mounted) Navigator.of(ctx).pop();

                      final nav = rootNavigatorKey.currentContext ?? context;
                      if (!nav.mounted) return;
                      if (ok) {
                        nav.go('/login');
                        AppSnackbar.success(nav, 'Your account has been deleted.');
                      } else {
                        final msg = ref.read(authStateProvider).errorMessage;
                        AppSnackbar.error(
                          nav,
                          msg ?? 'Could not delete account. Please try again.',
                        );
                      }
                    },
              child: isDeleting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Delete'),
            ),
          ],
        ),
      );
    },
  );
}
