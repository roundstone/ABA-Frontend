import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'widgets/buynaija_logo.dart';
import 'widgets/city_skyline_landscape.dart';
import 'widgets/role_selection_card.dart';
import 'widgets/role_selection_illustrations.dart';

/// Screen allowing the user to choose their journey: Customer or Merchant.
/// Faithfully designed after the BuyNaija Figma UI specification.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fixed bottom background
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CitySkylineLandscape(height: 250),
          ),

          // Scrollable foreground content
          SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar: BuyNaija Logo & Notification Bell
                    const BuyNaijaLogo(fontSize: 22, iconSize: 26),

                    const SizedBox(height: AppSpacing.lg),

                    // Hero section with headline and 3D illustration
                    _buildHeroSection(isDark),

                    const SizedBox(height: AppSpacing.xxxl),

                    // Customer Selection Card
                    RoleSelectionCard(
                      badgeLabel: 'Customer',
                      title: 'Shop & Save',
                      description:
                          'Access authentic products\nat great prices.',
                      onTap: () => context.go('/login/customer'),
                    ),

                    const SizedBox(height: 14),

                    // Marketer Selection Card
                    RoleSelectionCard(
                      badgeLabel: 'Marketer',
                      title: 'Promote & Earn',
                      description: 'Promote products\nand earn commissions.',
                      onTap: () => context.go('/login/marketer'),
                    ),

                    const SizedBox(height: AppSpacing.xxxl),

                    // Quick links to About and Commission pages
                    _buildFooterLinks(context, isDark),

                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLinks(BuildContext context, bool isDark) {
    final linkColor = isDark ? AppColors.secondary : AppColors.primary;
    final dotColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSubtle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFooterLink(
          'About BuyNaija',
          () => context.push('/about'),
          linkColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '•',
            style: TextStyle(
              color: dotColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildFooterLink(
          'Community',
          () => context.push('/community'),
          linkColor,
        ),
      ],
    );
  }

  Widget _buildFooterLink(String label, VoidCallback onTap, Color color) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: color,
          decoration: TextDecoration.underline,
          decorationColor: color.withAlpha(120),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left text & curve
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Choose your\n',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppColors.onBackground,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: 'path',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.secondary : AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Shop, sell and grow\nwith BuyNaija.',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
              DecorativeCurve(
                width: 44,
                height: 10,
                color: isDark ? AppColors.secondary : AppColors.primary,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Right 3D market illustration
        const HeroMarketIllustration(size: 122),
      ],
    );
  }
}
