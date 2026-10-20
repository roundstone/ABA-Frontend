import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/config/app_brand.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/content_mock_data.dart';
import 'community_screen_widgets.dart';

/// Community Screen matching Web Storefront /community page.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static const Color copper = Color(0xFFC28B38);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppBrand.shortName} Community',
          style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
        ),
        leading: context.canPopSafely
            ? IconButton(
                tooltip: 'Back',
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: isDark ? Colors.white : AppColors.onBackground,
                  size: 20,
                ),
                onPressed: () => context.popOrGo('/home'),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxl * 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C1E10), Color(0xFF1E1408)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppSpacing.borderRadiusXL,
                border: Border.all(color: copper.withAlpha(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: copper,
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                    child: Text(
                      'COMMUNITY PARTNER PROGRAM',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Empowering Local Commerce Through Community',
                    style: AppTypography.h3.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Join thousands of partners driving real economic growth across Nigeria. Learn how the program works and start earning today.',
                    style: AppTypography.bodyMedium.copyWith(
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Section: How It Works
            Text(
              'How It Works',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'A structured framework designed to reward leadership, business development, and community impact.',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            const CommunityInfoTile(
              icon: HugeIcons.strokeRoundedHierarchy,
              title: 'Hierarchy & Progression',
              content:
                  'Advance through 5 tiers as your network expands. Unlock higher commission percentages and strategic quarterly performance bonuses.',
            ),
            const SizedBox(height: AppSpacing.md),

            const CommunityInfoTile(
              icon: HugeIcons.strokeRoundedCoins01,
              title: 'Earnings & Commissions',
              content:
                  'Earn on personal direct referrals and team downline volume. Real-time balance calculations with weekly automated bank payouts.',
            ),
            const SizedBox(height: AppSpacing.md),

            const CommunityInfoTile(
              icon: HugeIcons.strokeRoundedShoppingBag01,
              title: 'Purchasing Advantages',
              content:
                  'Access exclusive bulk discounts, wholesale merchant rates, and priority delivery routing across all local markets.',
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Section: FAQs
            Text(
              'Frequently Asked Questions',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.md),

            ...ContentMockData.communityFaqs.map(
              (faq) => CommunityFaqCard(faq: faq),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Call to Action Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0F5A2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppSpacing.borderRadiusXL,
              ),
              child: Column(
                children: [
                  Text(
                    'Ready to Start Earning?',
                    style: AppTypography.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Sign up, generate your unique link, and begin building your business network today.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => context.push('/referrals'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 44),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.avatarRadius,
                        ),
                      ),
                      child: const Text(
                        'Join the Community',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
