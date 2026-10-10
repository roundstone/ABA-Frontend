import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Vertical illustration-style selection card:
/// tinted artwork panel on top (with floating icon chip), title + subtitle below.
///
/// Pass [imageAsset] (e.g. a 3D/isometric PNG) to use real artwork.
/// Without it, a built-in icon "platform" illustration is drawn.
class RoleCard extends StatefulWidget {
  final String title;
  final String description;
  final Color badgeColor; // accent / tint colour
  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  final String? imageAsset;
  final String? badgeLabel;
  final double illustrationHeight;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.badgeColor,
    required this.icon,
    required this.onTap,
    this.imageAsset,
    this.badgeLabel,
    this.illustrationHeight = 176,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = widget.badgeColor;

    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? Colors.white.withAlpha(24) : AppColors.border;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.onSurface;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.grey;

    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.description}',
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1,
        duration: AppSpacing.animationFast,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: AppSpacing.animationNormal,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: AppSpacing.borderRadiusXXL,
            border: Border.all(
              color: _pressed ? accent.withAlpha(140) : border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 60 : 14),
                blurRadius: _pressed ? 10 : 24,
                offset: Offset(0, _pressed ? 3 : 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppSpacing.borderRadiusXXL,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  widget.onTap();
                },
                onHighlightChanged: (v) => setState(() => _pressed = v),
                splashColor: accent.withAlpha(18),
                highlightColor: accent.withAlpha(8),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildIllustration(isDark, accent),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.sm,
                          AppSpacing.md,
                          AppSpacing.sm,
                          AppSpacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: AppTypography.h4.copyWith(
                                      color: titleColor,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    widget.description,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: mutedColor,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            _ArrowButton(
                              pressed: _pressed,
                              accent: accent,
                              isDark: isDark,
                              border: border,
                            ),
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
      ),
    );
  }

  Widget _buildIllustration(bool isDark, Color accent) {
    return Container(
      height: widget.illustrationHeight,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.borderRadiusXL,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withAlpha(isDark ? 44 : 22),
            accent.withAlpha(isDark ? 26 : 10),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Artwork
          Positioned.fill(
            child: Center(
              child: AnimatedSlide(
                duration: AppSpacing.animationNormal,
                curve: Curves.easeOut,
                offset: _pressed ? const Offset(0, -0.04) : Offset.zero,
                child: widget.imageAsset != null
                    ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Image.asset(
                          widget.imageAsset!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : _IconPlatform(
                        icon: widget.icon,
                        accent: accent,
                        isDark: isDark,
                      ),
              ),
            ),
          ),

          // Floating icon chip (top-left)
          Positioned(
            top: AppSpacing.sm + 4,
            left: AppSpacing.sm + 4,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 50 : 14),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: HugeIcon(
                icon: widget.icon,
                color: accent,
                size: AppSpacing.iconSizeSM,
              ),
            ),
          ),

          // Optional badge (top-right)
          if (widget.badgeLabel != null)
            Positioned(
              top: AppSpacing.sm + 4,
              right: AppSpacing.sm + 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: AppSpacing.borderRadiusXL,
                ),
                child: Text(
                  widget.badgeLabel!,
                  style: AppTypography.label.copyWith(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Built-in "isometric platform" artwork used when no image asset is given.
class _IconPlatform extends StatelessWidget {
  final List<List<dynamic>> icon;
  final Color accent;
  final bool isDark;

  const _IconPlatform({
    required this.icon,
    required this.accent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ground shadow
          Positioned(
            bottom: 6,
            child: Container(
              width: 110,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 90 : 36),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Back plate
          Transform.rotate(
            angle: 0.14,
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: accent.withAlpha(isDark ? 60 : 34),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          // Front tile
          Transform.rotate(
            angle: -0.08,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [accent.withAlpha(230), accent.withAlpha(150)]
                      : [Colors.white, accent.withAlpha(46)],
                ),
                border: Border.all(
                  color: Colors.white.withAlpha(isDark ? 30 : 230),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withAlpha(isDark ? 80 : 56),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: HugeIcon(
                icon: icon,
                color: isDark ? Colors.white : accent,
                size: 44,
              ),
            ),
          ),
          // Small accents
          Positioned(
            top: 8,
            right: 10,
            child: _Dot(size: 10, color: accent.withAlpha(120)),
          ),
          Positioned(
            bottom: 26,
            left: 6,
            child: _Dot(size: 7, color: accent.withAlpha(90)),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;
  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _ArrowButton extends StatelessWidget {
  final bool pressed;
  final Color accent;
  final bool isDark;
  final Color border;

  const _ArrowButton({
    required this.pressed,
    required this.accent,
    required this.isDark,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final filledBg = isDark ? AppColors.secondary : AppColors.primary;
    final filledFg = isDark ? AppColors.primary : AppColors.onPrimary;
    final idleFg = isDark ? AppColors.darkTextPrimary : AppColors.onSurface;

    return AnimatedContainer(
      duration: AppSpacing.animationNormal,
      curve: Curves.easeOut,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pressed ? filledBg : Colors.transparent,
        border: Border.all(color: pressed ? filledBg : border),
      ),
      child: AnimatedSlide(
        duration: AppSpacing.animationNormal,
        curve: Curves.easeOut,
        offset: pressed ? const Offset(0.08, 0) : Offset.zero,
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 20,
          color: pressed ? filledFg : idleFg,
        ),
      ),
    );
  }
}