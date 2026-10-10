import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A selectable portal card used on the role selection screen.
///
/// - Whole card is tappable (with ripple, press-scale and haptic feedback)
/// - Accent colour (badgeColor) drives the icon tile, badge, check marks
///   and the pressed border, so each role has its own identity
/// - Fully dark-mode aware
class RoleCard extends StatefulWidget {
  final String badgeLabel;
  final Color badgeColor;
  final String title;
  final String description;
  final List<String> features;
  final String buttonLabel;
  final bool isPrimaryButton;
  final List<List<dynamic>> icon;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.badgeLabel,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.features,
    required this.buttonLabel,
    required this.icon,
    required this.onTap,
    this.isPrimaryButton = true,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _pressed = false;

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = widget.badgeColor;

    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final idleBorder = isDark ? Colors.white.withAlpha(24) : AppColors.border;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.onSurface;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.grey;

    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.buttonLabel}',
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1.0,
        duration: AppSpacing.animationFast,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: AppSpacing.animationNormal,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: AppSpacing.borderRadiusXL,
            border: Border.all(
              color: _pressed ? accent : idleBorder,
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 60 : 12),
                blurRadius: _pressed ? 8 : 20,
                offset: Offset(0, _pressed ? 2 : 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusXL,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                onHighlightChanged: (v) => setState(() => _pressed = v),
                splashColor: accent.withAlpha(20),
                highlightColor: accent.withAlpha(10),
                child: Stack(
                  children: [
                    // Soft accent glow in the top-right corner
                    Positioned(
                      top: -40,
                      right: -40,
                      child: IgnorePointer(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                accent.withAlpha(isDark ? 46 : 28),
                                accent.withAlpha(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: AppSpacing.cardPaddingLarge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(isDark),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            widget.title,
                            style: AppTypography.h4.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            widget.description,
                            style: AppTypography.bodyMedium.copyWith(
                              color: mutedColor,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Divider(height: 1, color: idleBorder),
                          const SizedBox(height: AppSpacing.md),
                          ...widget.features.map(
                            (f) => _FeatureRow(
                              text: f,
                              accent: accent,
                              textColor: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildButton(isDark, idleBorder),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final accent = widget.badgeColor;

    return Row(
      children: [
        // Icon tile
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accent.withAlpha(isDark ? 50 : 24),
            borderRadius: AppSpacing.borderRadiusMD,
          ),
          alignment: Alignment.center,
          child: HugeIcon(
            icon: widget.icon,
            color: accent,
            size: AppSpacing.iconSizeMD,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Badge pill
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: accent.withAlpha(isDark ? 40 : 20),
              borderRadius: AppSpacing.borderRadiusXL,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    widget.badgeLabel,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Directional affordance
        AnimatedSlide(
          duration: AppSpacing.animationNormal,
          curve: Curves.easeOut,
          offset: _pressed ? const Offset(0.25, 0) : Offset.zero,
          child: Icon(
            Icons.arrow_forward_rounded,
            size: AppSpacing.iconSizeSM,
            color: _pressed
                ? accent
                : (isDark ? AppColors.darkTextSecondary : AppColors.textSubtle),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(bool isDark, Color idleBorder) {
    final isPrimary = widget.isPrimaryButton;

    // Primary: filled with brand colour (inverted in dark mode for contrast)
    final bg = isPrimary
        ? (isDark ? AppColors.secondary : AppColors.primary)
        : Colors.transparent;
    final fg = isPrimary
        ? (isDark ? AppColors.primary : AppColors.onPrimary)
        : (isDark ? AppColors.darkTextPrimary : AppColors.primary);

    return Container(
      height: AppSpacing.buttonHeightLG,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.buttonRadius,
        border: isPrimary
            ? null
            : Border.all(
                color: isDark ? Colors.white.withAlpha(60) : AppColors.primary,
                width: 1.2,
              ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.buttonLabel,
            style: AppTypography.buttonMedium.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.arrow_forward_rounded, size: 18, color: fg),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final Color accent;
  final Color textColor;

  const _FeatureRow({
    required this.text,
    required this.accent,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: accent.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, size: 14, color: accent),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: textColor,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
