import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme/app_colors.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final List<List<dynamic>> icon;
  final Color color;

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? time,
    bool? isRead,
    List<List<dynamic>>? icon,
    Color? color,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier()
      : super([
          const AppNotification(
            id: 'notif-1',
            title: 'Order Delivered',
            body: 'Your order #ORD-2026-E4F2A has been successfully delivered.',
            time: '2 hours ago',
            isRead: false,
            icon: HugeIcons.strokeRoundedPackage,
            color: AppColors.success,
          ),
          const AppNotification(
            id: 'notif-2',
            title: 'Points Earned',
            body: 'You earned +50 points for leaving a product review.',
            time: '1 day ago',
            isRead: false,
            icon: HugeIcons.strokeRoundedAward01,
            color: Color(0xFFF59E0B),
          ),
          const AppNotification(
            id: 'notif-3',
            title: 'Wallet Funded',
            body:
                '₦ 25,000.00 has been credited to your wallet via Bank Transfer.',
            time: '3 days ago',
            isRead: true,
            icon: HugeIcons.strokeRoundedWallet01,
            color: AppColors.primary,
          ),
        ]);

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }

  void clearAll() {
    state = const [];
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(notificationsProvider);
  return notifs.where((n) => !n.isRead).length;
});
