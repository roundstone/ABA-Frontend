/// Constants for Push & Local Notifications across BuyNaija / ABA ERP.
class NotificationConstants {
  NotificationConstants._();

  // Notification Channel Configuration (Android)
  static const String channelId = 'aba_high_importance_channel';
  static const String channelName = 'BuyNaija Orders & Alerts';
  static const String channelDescription =
      'Real-time updates for orders, payments, referrals, and account alerts.';

  // FCM Topics
  static const String topicAll = 'all_users';
  static const String topicCustomers = 'customers';
  static const String topicMerchants = 'merchants';
  static const String topicPromotions = 'promotions';

  // Customer Order Flow Types
  static const String typeOrderPlaced = 'order_placed';
  static const String typeOrderConfirmed = 'order_confirmed';
  static const String typeOrderShipped = 'order_shipped';
  static const String typeOrderDelivered = 'order_delivered';
  static const String typeOrderCancelled = 'order_cancelled';

  // Merchant Flow Types
  static const String typeMerchantNewOrder = 'merchant_new_order';
  static const String typeMerchantOrderCancelled = 'merchant_order_cancelled';
  static const String typeMerchantLowStock = 'merchant_low_stock';

  // Financial & Payout Flow Types
  static const String typeWalletCredit = 'wallet_credit';
  static const String typeWalletDebit = 'wallet_debit';
  static const String typeCommissionEarned = 'commission_earned';

  // Referral & Network Growth Types
  static const String typeReferralJoined = 'referral_joined';
  static const String typeReferralReward = 'referral_reward';

  // Marketing & System Flow Types
  static const String typePromotion = 'promotion';
  static const String typeCartReminder = 'cart_reminder';
  static const String typeSystemAlert = 'system_alert';

  // SharedPreferences Keys
  static const String keyCachedFcmToken = 'aba_cached_fcm_token';
  static const String keyPushEnabled = 'settings_push_enabled';
  static const String keyOrderUpdatesEnabled = 'settings_order_updates_enabled';
  static const String keyPromosEnabled = 'settings_promos_enabled';
}
