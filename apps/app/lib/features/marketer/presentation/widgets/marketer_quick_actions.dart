import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MarketerQuickActions extends StatelessWidget {
  const MarketerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Marketer Actions',
          style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context: context,
                isDark: isDark,
                icon: HugeIcons.strokeRoundedUserAdd01,
                label: 'Add Customer(s)',
                subtitle: 'Onboard with code',
                isPrimary: true,
                onTap: () => context.push('/marketer/add-customer'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildActionTile(
                context: context,
                isDark: isDark,
                icon: HugeIcons.strokeRoundedNetwork,
                label: 'My Referrals',
                subtitle: 'Code & downline',
                isPrimary: false,
                onTap: () => context.push('/referrals/profile'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                context: context,
                isDark: isDark,
                icon: HugeIcons.strokeRoundedStore01,
                label: 'My Merchant',
                subtitle: 'Partner profile',
                isPrimary: false,
                onTap: () => context.push('/marketer/merchant'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildActionTile(
                context: context,
                isDark: isDark,
                icon: HugeIcons.strokeRoundedInvoice01,
                label: 'Commissions',
                subtitle: 'Ledger & rewards',
                isPrimary: false,
                onTap: () => context.push('/referrals/ledger'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required bool isDark,
    required dynamic icon,
    required String label,
    required String subtitle,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    final bgColor = isPrimary
        ? (isDark ? AppColors.primary : AppColors.primary)
        : (isDark ? AppColors.darkSurface : AppColors.surface);
    final textColor = isPrimary
        ? Colors.white
        : (isDark ? Colors.white : AppColors.onBackground);
    final subtextColor = isPrimary
        ? Colors.white70
        : (isDark ? AppColors.darkTextSecondary : AppColors.grey);
    final iconColor = isPrimary ? Colors.white : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusLG,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppSpacing.borderRadiusLG,
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : (isDark ? AppColors.darkBorder : AppColors.border),
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? Colors.white.withAlpha(35)
                      : (isDark
                          ? AppColors.primary.withAlpha(50)
                          : AppColors.primary.withAlpha(20)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: HugeIcon(icon: icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: subtextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

