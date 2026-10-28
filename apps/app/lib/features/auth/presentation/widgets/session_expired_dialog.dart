import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/auth_entities.dart';

/// Displays a modal dialog alerting the user that their session has expired
/// and prompting them to log in again.
Future<void> showSessionExpiredDialog({
  required BuildContext context,
  required UserRole role,
  required Future<void> Function() onConfirmLogin,
}) async {
  final isMerchant = role == UserRole.merchant;
  final roleLabel = isMerchant ? 'Merchant' : 'Customer';

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
      final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
      final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            Navigator.of(dialogCtx).pop();
            onConfirmLogin();
          }
        },
        child: AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLG,
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: warningColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedAlertCircle,
                  color: warningColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Expired',
                      style: AppTypography.h4.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white12 : AppColors.formBg),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$roleLabel Account',
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Text(
            isMerchant
                ? 'Your session has expired. Please log in again to access your merchant portal, manage orders, and view inventory.'
                : 'Your session has expired. Please log in again to continue shopping and access your orders.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMD,
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                  onConfirmLogin();
                },
                child: Text(
                  isMerchant ? 'Log In as Merchant' : 'Log In',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
