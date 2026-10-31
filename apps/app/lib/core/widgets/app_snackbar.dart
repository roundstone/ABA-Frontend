import 'package:flutter/material.dart';
import 'app_snackbar_content.dart';

export 'app_snackbar_content.dart' show AppSnackbarType;

/// Standard, animated flash snackbar reusable across the platform.
///
/// Designed as a compact, floating pill that animates in like a flash
/// with smooth scaling, fading, and subtle spring dynamics.
abstract final class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2600),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        padding: EdgeInsets.zero,
        content: FlashSnackbarContent(
          message: message,
          type: type,
          actionLabel: actionLabel,
          onAction: () {
            messenger.hideCurrentSnackBar();
            onAction?.call();
          },
        ),
      ),
    );
  }

  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2600),
  }) =>
      show(
        context,
        message: message,
        type: AppSnackbarType.success,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 3200),
  }) =>
      show(
        context,
        message: message,
        type: AppSnackbarType.error,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  static void info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2600),
  }) =>
      show(
        context,
        message: message,
        type: AppSnackbarType.info,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  static void warning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2800),
  }) =>
      show(
        context,
        message: message,
        type: AppSnackbarType.warning,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  static void hide(BuildContext context) {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  }
}

/// Convenience extension on [BuildContext] for invoking [AppSnackbar].
extension AppSnackbarContextExtension on BuildContext {
  void showSuccessSnackBar(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.success(
        this,
        message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  void showErrorSnackBar(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.error(
        this,
        message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  void showInfoSnackBar(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.info(
        this,
        message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  void showWarningSnackBar(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppSnackbar.warning(
        this,
        message,
        actionLabel: actionLabel,
        onAction: onAction,
      );
}
