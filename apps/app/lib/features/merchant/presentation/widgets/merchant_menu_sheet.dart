import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/application/auth_providers.dart';
import 'merchant_account_dialogs.dart';
import 'merchant_menu_tile.dart';

void showMerchantMenuSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(140),
    builder: (_) => const _MerchantMenuModal(),
  );
}

class _MerchantMenuModal extends ConsumerWidget {
  const _MerchantMenuModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final businessName = user?.businessName ?? 'Enyimba Leather Works';
    final ownerName = user?.name ?? 'Merchant Owner';
    final referralCode = user?.referralCode ?? 'ABA-MERCH-8821';
    final sheetBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Business Profile Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF8B5CF6).withAlpha(30),
                  child: Text(
                    businessName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              businessName,
                              style: AppTypography.titleSmall
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              color: Color(0xFF10B981), size: 16),
                        ],
                      ),
                      Text(ownerName, style: AppTypography.caption),
                    ],
                  ),
                ),
                // Referral Code Copy Chip
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Referral code "$referralCode" copied!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899)
                          .withAlpha(isDark ? 30 : 15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFEC4899).withAlpha(60),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedCopy01,
                          color: Color(0xFFEC4899),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          referralCode,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEC4899),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),

          // Menu Options List
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              children: [
                const MerchantSectionTitle(title: 'Growth & Financials'),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedNetwork,
                  color: const Color(0xFFEC4899),
                  title: 'Referral Network',
                  subtitle: 'MLM downline tree & team sales',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/referrals/profile');
                  },
                ),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedCoins01,
                  color: const Color(0xFFF59E0B),
                  title: 'Earnings & Commissions',
                  subtitle: 'Commission payouts & milestone bonuses',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/referrals');
                  },
                ),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedWallet01,
                  color: const Color(0xFF10B981),
                  title: 'Business Wallet',
                  subtitle: 'Available payouts & settlement history',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/wallet');
                  },
                ),

                const MerchantSectionTitle(title: 'Settings & Tools'),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedSettings01,
                  color: const Color(0xFF64748B),
                  title: 'Account & Store Settings',
                  subtitle: 'Store profile, password & preferences',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedNotification01,
                  color: const Color(0xFF6366F1),
                  title: 'Notification Preferences',
                  subtitle: 'Orders, payments & commission alerts',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/notifications');
                  },
                ),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedStore01,
                  color: const Color(0xFF3B82F6),
                  title: 'Customer Storefront',
                  subtitle: 'Browse marketplace products as customer',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/home');
                  },
                ),

                const MerchantSectionTitle(title: 'Account Actions'),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedLogout01,
                  color: AppColors.error,
                  title: 'Logout',
                  subtitle: 'Sign out of merchant portal',
                  onTap: () => showConfirmLogoutDialog(context, ref),
                ),
                MerchantMenuTile(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: Colors.redAccent,
                  title: 'Delete Account',
                  subtitle: 'Deactivate merchant store & account',
                  onTap: () => showConfirmDeleteAccountDialog(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
