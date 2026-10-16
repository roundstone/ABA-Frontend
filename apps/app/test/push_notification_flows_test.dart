import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/notifications/notification_constants.dart';
import 'package:app/core/notifications/notification_payload.dart';
import 'package:app/core/notifications/notification_navigation_handler.dart';
import 'package:app/core/providers/notifications_provider.dart';
import 'package:app/core/theme/app_colors.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Push Notification Flow & Route Resolution Tests', () {
    test('Customer Order Placed maps to /account/orders/:id', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Order Placed',
        'body': 'Your order has been placed.',
        'type': NotificationConstants.typeOrderPlaced,
        'data': {'order_id': 'ORD-999'},
      });

      expect(payload.route, '/account/orders/ORD-999');
      expect(payload.type, NotificationConstants.typeOrderPlaced);
    });

    test('Customer Order Shipped maps to /account/orders/:id', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Order Shipped',
        'body': 'Your order is on the way.',
        'type': NotificationConstants.typeOrderShipped,
        'data': {'order_id': 'ORD-888'},
      });

      expect(payload.route, '/account/orders/ORD-888');
    });

    test('Customer Order Delivered maps to /account/orders/:id', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Order Delivered',
        'body': 'Package arrived.',
        'type': NotificationConstants.typeOrderDelivered,
        'data': {'order_id': 'ORD-777'},
      });

      expect(payload.route, '/account/orders/ORD-777');
    });

    test('Merchant New Order maps to /merchant/orders/:id', () {
      final payload = NotificationPayload.fromMap({
        'title': 'New Order Received',
        'body': 'Customer purchased items.',
        'type': NotificationConstants.typeMerchantNewOrder,
        'data': {'order_id': 'ORD-M100'},
      });

      expect(payload.route, '/merchant/orders/ORD-M100');
    });

    test('Merchant Low Stock maps to /merchant/products', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Low Stock Alert',
        'body': 'Only 2 items left in stock.',
        'type': NotificationConstants.typeMerchantLowStock,
        'data': {'product_id': 'PROD-1'},
      });

      expect(payload.route, '/merchant/products');
    });

    test('Wallet Credit and Commission Earned map to /wallet', () {
      final walletPayload = NotificationPayload.fromMap({
        'title': 'Wallet Credited',
        'body': 'Funds added.',
        'type': NotificationConstants.typeWalletCredit,
        'data': {'amount': '₦50,000'},
      });

      final commissionPayload = NotificationPayload.fromMap({
        'title': 'Commission Earned',
        'body': 'Referral commission credited.',
        'type': NotificationConstants.typeCommissionEarned,
        'data': {'amount': '₦2,500'},
      });

      expect(walletPayload.route, '/wallet');
      expect(commissionPayload.route, '/wallet');
    });

    test('Referral Joined maps to /referrals', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Downline Registered',
        'body': 'New member joined.',
        'type': NotificationConstants.typeReferralJoined,
        'data': {'referee': 'John Doe'},
      });

      expect(payload.route, '/referrals');
    });

    test('Referral Reward milestone maps to /rewards', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Milestone Unlocked',
        'body': 'Silver tier achieved.',
        'type': NotificationConstants.typeReferralReward,
        'data': {},
      });

      expect(payload.route, '/rewards');
    });

    test('Promotion with Product ID maps to /product/:id', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Flash Sale',
        'body': 'Discount available.',
        'type': NotificationConstants.typePromotion,
        'data': {'product_id': 'shoe-oxford-01'},
      });

      expect(payload.route, '/product/shoe-oxford-01');
    });

    test('Promotion without Product ID maps to /shop', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Aba Mega Weekend',
        'body': 'Explore storewide discounts.',
        'type': NotificationConstants.typePromotion,
        'data': {},
      });

      expect(payload.route, '/shop');
    });

    test('Cart Reminder maps to /cart', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Cart Waiting',
        'body': 'Complete your checkout.',
        'type': NotificationConstants.typeCartReminder,
        'data': {'item_count': 3},
      });

      expect(payload.route, '/cart');
    });

    test('Custom explicit route override takes precedence', () {
      final payload = NotificationPayload.fromMap({
        'title': 'Special Announcement',
        'body': 'Check out settings.',
        'type': NotificationConstants.typeSystemAlert,
        'data': {'route': '/settings'},
      });

      expect(payload.route, '/settings');
    });

    test('Fallback default route is /notifications', () {
      final payload = NotificationPayload.fromMap({
        'title': 'General Notice',
        'body': 'System maintenance scheduled.',
        'type': NotificationConstants.typeSystemAlert,
        'data': {},
      });

      expect(payload.route, '/notifications');
    });
  });

  group('NotificationNavigationHandler Tests', () {
    test('Queues pending route when router is not yet attached', () {
      final handler = NotificationNavigationHandler.instance;
      handler.clearPendingRoute();

      handler.navigateToRoute('/wallet');
      expect(handler.pendingRoute, '/wallet');

      handler.clearPendingRoute();
      expect(handler.pendingRoute, isNull);
    });
  });

  group('In-App Notification Center Integration', () {
    test('NotificationsNotifier can add and mark notifications as read', () {
      final notifier = NotificationsNotifier();
      expect(notifier.state.length, 3);

      final initialUnread = notifier.state.where((n) => !n.isRead).length;

      notifier.addNotification(
        const AppNotification(
          id: 'test-push-1',
          title: 'Incoming Push',
          body: 'Order #ORD-123 shipped',
          time: 'Just now',
          isRead: false,
          icon: [],
          color: AppColors.primary,
          route: '/account/orders/ORD-123',
        ),
      );

      expect(notifier.state.length, 4);
      expect(notifier.state.first.id, 'test-push-1');
      expect(notifier.state.first.route, '/account/orders/ORD-123');
      expect(notifier.state.where((n) => !n.isRead).length, initialUnread + 1);

      notifier.markAsRead('test-push-1');
      expect(notifier.state.first.isRead, isTrue);
    });
  });
}
