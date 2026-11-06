import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_brand.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/application/auth_providers.dart';
import '../data/content_mock_data.dart';
import 'about_pillar_card.dart';

/// About Screen matching Web Storefront /about page.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const page = ContentMockData.aboutPage;
    final introSection = page.sections.firstWhere((s) => s.name == 'Hero/Intro');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About ${AppBrand.shortName}',
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
            // Intro Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2820) : const Color(0xFFF1F6F2),
                borderRadius: AppSpacing.borderRadiusXL,
                border: Border.all(
                  color: isDark ? const Color(0xFF2C3E30) : const Color(0xFFDCE8DF),
                ),
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
                      color: AppColors.primary,
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                    child: Text(
                      'BUY LOCAL • GROW LOCAL',
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
                    introSection.title,
                    style: AppTypography.h3.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    introSection.content,
                    style: AppTypography.bodyMedium.copyWith(
                      height: 1.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Three Core Pillars Heading
            Text(
              'How It Works',
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacing.md),

            // Pillar 1: Shop
            AboutPillarCard(
              icon: HugeIcons.strokeRoundedShoppingBag01,
              title: 'Shop',
              subtitle: 'FOR CUSTOMERS',
              description:
                  'Discover authentic products crafted by Nigerian artisans and merchants. Verified quality, direct pricing, and safe door-to-door delivery.',
              buttonLabel: 'Start Shopping',
              onTap: () {
                final isAuth = ref.read(authStateProvider).isAuthenticated;
                if (!isAuth) {
                  context.push('/login');
                } else {
                  context.go('/shop');
                }
              },
              accentColor: const Color(0xFF15803D),
            ),
            const SizedBox(height: AppSpacing.md),

            // Pillar 2: Sell
            AboutPillarCard(
              icon: HugeIcons.strokeRoundedStore01,
              title: 'Sell',
              subtitle: 'FOR MERCHANTS',
              description:
                  'Get your products in front of buyers nationwide. Manage catalog, digital orders, and in-store transactions with our built-in POS.',
              buttonLabel: 'Become a Merchant',
              onTap: () async {
                const merchantUrl =
                    'https://buy-naija-git-nov-featureweb-ap-a7f155-yusufs-projects-ed3add33.vercel.app/merchants/onboarding';
                final uri = Uri.parse(merchantUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  await launchUrl(uri);
                }
              },
              accentColor: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),

            // Pillar 3: Earn
            AboutPillarCard(
              icon: HugeIcons.strokeRoundedAward01,
              title: 'Earn',
              subtitle: 'FOR COMMUNITY PARTNERS',
              description:
                  'Refer friends, businesses, and members to the platform. Build a thriving team and earn continuous commissions with full payout visibility.',
              buttonLabel: 'Explore Community',
              onTap: () => context.push('/community'),
              accentColor: const Color(0xFFC28B38),
            ),
          ],
        ),
      ),
    );
  }
}
