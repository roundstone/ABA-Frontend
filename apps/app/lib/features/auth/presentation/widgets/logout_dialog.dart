import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/auth_providers.dart';
import '../../domain/auth_entities.dart';

/// Shows a shared confirmation dialog to logout the currently logged in user.
Future<void> showAppLogoutDialog({
  required BuildContext context,
  required WidgetRef ref,
  UserRole? role,
  String? title,
  String? message,
  String redirectTo = '/role-select',
}) async {
  final isMerchant = role == UserRole.merchant ||
      ref.read(currentUserProvider)?.isMerchant == true;

  final resolvedTitle = title ??
      (isMerchant ? 'Logout Merchant Portal?' : 'Logout Customer Account?');

  final resolvedMessage = message ??
      (isMerchant
          ? 'Are you sure you want to sign out of your merchant portal? You will need to sign in again to access orders and inventory.'
          : 'Are you sure you want to sign out? You will need to sign in again to access your orders and wallet.');

  await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;

      return AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLG,
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedLogout01,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                resolvedTitle,
                style: AppTypography.h4.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          resolvedMessage,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: const RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusMD,
              ),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop(true);
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go(redirectTo);
              }
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
    },
  );
}
