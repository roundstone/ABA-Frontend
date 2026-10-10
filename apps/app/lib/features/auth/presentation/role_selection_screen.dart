import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'widgets/role_card.dart';

/// Screen allowing the user to choose their portal flow: Customer or Merchant.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Top Brand Emblem
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(isDark ? 50 : 20),
                    shape: BoxShape.circle,
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedStore01,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Welcome to Buy Nigeria',
                style: AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Select your journey to access tailored tools, catalogues, and earning features.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Customer Option Card
              RoleCard(
                badgeLabel: 'CUSTOMER & NETWORK',
                badgeColor: AppColors.info,
                title: 'Shop, Save & Earn',
                description:
                    'Access authentic products at direct factory prices. Refer friends and earn automated 3-tier commission rewards on their purchases.',
                // features: const [
                //   'Direct wholesale & retail pricing',
                //   'Instant cashback & referral network tree',
                //   'Track orders & seamless escrow wallet',
                // ],
                // buttonLabel: 'Continue as Customer',
                // isPrimaryButton: true,
                icon: HugeIcons.strokeRoundedShoppingBag01,
                onTap: () => context.go('/login/customer'),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Merchant Option Card
              RoleCard(
                badgeLabel: 'MERCHANT & MANUFACTURER',
                badgeColor: AppColors.success,
                title: 'Sell, Scale & POS',
                description:
                    'Empower your workshop or store with a digital storefront, mobile POS sales billing, and access to buyers nationwide.',
                // features: const [
                //   'Verified digital storefront & catalog',
                //   'In-store POS with offline support',
                //   'Instant wallet settlement & payouts',
                // ],
                // buttonLabel: 'Continue as Merchant',
                // isPrimaryButton: false,
                icon: HugeIcons.strokeRoundedStore01,
                onTap: () => context.go('/login/merchant'),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
