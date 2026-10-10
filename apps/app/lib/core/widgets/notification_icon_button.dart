import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../providers/notifications_provider.dart';
import '../theme/app_colors.dart';

class NotificationIconButton extends ConsumerWidget {
  const NotificationIconButton({
    super.key,
    this.color,
    this.badgeColor,
    this.iconSize = 22,
    this.onPressed,
    this.showBadgeCount = true,
  });

  final Color? color;
  final Color? badgeColor;
  final double iconSize;
  final VoidCallback? onPressed;
  final bool showBadgeCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = color ?? (isDark ? AppColors.secondary : AppColors.primary);
    final indicatorColor = badgeColor ?? AppColors.warning;

    return IconButton(
      tooltip: 'Notifications',
      onPressed: onPressed ?? () => context.push('/notifications'),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01,
            color: iconColor,
            size: iconSize,
          ),
          if (unreadCount > 0)
            Positioned(
              right: -4,
              top: -3,
              child: Container(
                padding: showBadgeCount && unreadCount > 0
                    ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
                    : const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    width: 1.5,
                  ),
                ),
                child: showBadgeCount
                    ? Center(
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
