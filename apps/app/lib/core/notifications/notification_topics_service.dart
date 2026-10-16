import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_constants.dart';

/// Manages FCM Topic subscriptions based on user roles and notification preferences.
class NotificationTopicsService {
  NotificationTopicsService._();
  static final NotificationTopicsService instance =
      NotificationTopicsService._();

  /// Subscribes to a given FCM topic.
  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      debugPrint('[NotificationTopics] Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('[NotificationTopics] Failed to subscribe to $topic: $e');
    }
  }

  /// Unsubscribes from a given FCM topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      debugPrint('[NotificationTopics] Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('[NotificationTopics] Failed to unsubscribe from $topic: $e');
    }
  }

  /// Synchronizes topics based on active user role and notification preferences.
  Future<void> syncUserTopics({
    required bool isMerchant,
    required bool promotionsEnabled,
    required bool ordersEnabled,
  }) async {
    // 1. All users topic
    await subscribeToTopic(NotificationConstants.topicAll);

    // 2. Role based topics
    if (isMerchant) {
      await subscribeToTopic(NotificationConstants.topicMerchants);
      await unsubscribeFromTopic(NotificationConstants.topicCustomers);
    } else {
      await subscribeToTopic(NotificationConstants.topicCustomers);
      await unsubscribeFromTopic(NotificationConstants.topicMerchants);
    }

    // 3. Marketing & Promotional topic
    if (promotionsEnabled) {
      await subscribeToTopic(NotificationConstants.topicPromotions);
    } else {
      await unsubscribeFromTopic(NotificationConstants.topicPromotions);
    }
  }
}
