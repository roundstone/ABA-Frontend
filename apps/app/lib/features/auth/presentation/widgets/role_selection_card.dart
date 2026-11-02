import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Horizontal selection card matching the Figma BuyNaija UI design.
class RoleSelectionCard extends StatelessWidget {
  const RoleSelectionCard({
    super.key,
    this.graphic,
    required this.badgeLabel,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final Widget? graphic;
  final String badgeLabel;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: AppColors.primary.withAlpha(20),
        highlightColor: AppColors.primary.withAlpha(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withAlpha(50)
                    : const Color(0x0C000000),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left stylized graphic illustration
              graphic ?? const SizedBox.shrink(),

              const SizedBox(width: 14),

              // Middle details: Badge, Title, Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary.withAlpha(60)
                            : AppColors.primary.withAlpha(18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeLabel,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.secondary
                              : AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.onBackground,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Right circular arrow action button
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.primary.withAlpha(80)
                      : AppColors.primary.withAlpha(22),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: isDark
                        ? AppColors.secondary
                        : AppColors.primary,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal trust badges row ("Secure Payments", "Trusted Marketplace", "Reliable Support").
class TrustBadgesRow extends StatelessWidget {
  const TrustBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBadge(
            icon: Icons.shield_outlined,
            label: 'Secure\nPayments',
            isDark: isDark,
          ),
          Container(width: 1, height: 26, color: dividerColor),
          _buildBadge(
            icon: Icons.handshake_outlined,
            label: 'Trusted\nMarketplace',
            isDark: isDark,
          ),
          Container(width: 1, height: 26, color: dividerColor),
          _buildBadge(
            icon: Icons.headset_mic_outlined,
            label: 'Reliable\nSupport',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final iconColor = isDark
        ? AppColors.secondary
        : AppColors.primary;
    final textColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: iconColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: textColor,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
