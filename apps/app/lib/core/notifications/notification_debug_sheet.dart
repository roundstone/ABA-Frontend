import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'notification_sim_buttons.dart';
import 'push_notification_providers.dart';
import 'push_notification_service.dart';

/// Modal bottom sheet allowing inspection of FCM device token, permission state,
/// and live simulation of all application notification flows.
class NotificationDebugSheet extends ConsumerWidget {
  const NotificationDebugSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationDebugSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(fcmTokenProvider) ??
        PushNotificationService.instance.fcmToken;
    final isGranted = ref.watch(notificationPermissionProvider) ||
        PushNotificationService.instance.isPermissionGranted;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification01,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Push Notification Diagnostics',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Firebase Cloud Messaging Status',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // FCM Token section
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FCM Device Registration Token',
                      style: AppTypography.label.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isGranted
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isGranted ? 'Permission Granted' : 'Pending',
                        style: AppTypography.caption.copyWith(
                          color: isGranted
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SelectableText(
                  token ??
                      'Token generating... (Simulated/Fallback token active)',
                  style: AppTypography.caption.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.textSubtle,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                    icon: const Icon(Icons.copy, size: 14),
                    label: const Text('Copy Token', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      final tokenToCopy = token ?? 'aba-mock-fcm-device-token';
                      Clipboard.setData(ClipboardData(text: tokenToCopy));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('FCM Device Token copied to clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Flow simulation title
          Text(
            'Simulate Application Flow Pushes',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tap any case below to test foreground banner, tray notification, and deep linking.',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSubtle,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          NotificationSimButtons(
            onSimulated: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
