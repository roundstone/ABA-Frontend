import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme/app_colors.dart';
import 'notification_constants.dart';
import 'notification_simulator.dart';

/// Button wrap widget displaying 1-tap triggers for simulating every push scenario.
class NotificationSimButtons extends StatelessWidget {
  const NotificationSimButtons({super.key, required this.onSimulated});

  final VoidCallback onSimulated;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSimBtn(
          context,
          label: 'Order Delivered',
          icon: HugeIcons.strokeRoundedPackage,
          onTap: () => NotificationSimulator.simulateCustomerOrder(
            type: NotificationConstants.typeOrderDelivered,
          ),
        ),
        _buildSimBtn(
          context,
          label: 'Merchant New Order',
          icon: HugeIcons.strokeRoundedStore01,
          onTap: () => NotificationSimulator.simulateMerchantOrder(),
        ),
        _buildSimBtn(
          context,
          label: 'Low Stock Alert',
          icon: HugeIcons.strokeRoundedAlertCircle,
          onTap: () => NotificationSimulator.simulateMerchantLowStock(),
        ),
        _buildSimBtn(
          context,
          label: 'Wallet Credit',
          icon: HugeIcons.strokeRoundedWallet01,
          onTap: () => NotificationSimulator.simulateWalletCredit(),
        ),
        _buildSimBtn(
          context,
          label: 'Referral Joined',
          icon: HugeIcons.strokeRoundedUserAdd01,
          onTap: () => NotificationSimulator.simulateReferralMilestone(),
        ),
        _buildSimBtn(
          context,
          label: 'Milestone Reward',
          icon: HugeIcons.strokeRoundedAward01,
          onTap: () => NotificationSimulator.simulateRewardMilestone(),
        ),
        _buildSimBtn(
          context,
          label: 'Flash Sale',
          icon: HugeIcons.strokeRoundedDiscount01,
          onTap: () => NotificationSimulator.simulatePromotion(),
        ),
        _buildSimBtn(
          context,
          label: 'Cart Reminder',
          icon: HugeIcons.strokeRoundedShoppingCart01,
          onTap: () => NotificationSimulator.simulateCartReminder(),
        ),
      ],
    );
  }

  Widget _buildSimBtn(
    BuildContext context, {
    required String label,
    required List<List<dynamic>> icon,
    required Future<void> Function() onTap,
  }) {
    return ActionChip(
      avatar: HugeIcon(icon: icon, color: AppColors.primary, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () async {
        onSimulated();
        await onTap();
      },
    );
  }
}
