import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// Semantic types for platform snackbars.
enum AppSnackbarType {
  success,
  error,
  info,
  warning,
}

/// Compact, animated floating pill content for [AppSnackbar].
class FlashSnackbarContent extends StatefulWidget {
  const FlashSnackbarContent({
    super.key,
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final AppSnackbarType type;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  State<FlashSnackbarContent> createState() => _FlashSnackbarContentState();
}

class _FlashSnackbarContentState extends State<FlashSnackbarContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..forward();

  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
  );

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutQuad,
  );

  late final Animation<Offset> _slideAnimation = Tween<Offset>(
    begin: const Offset(0, 0.25),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accentColor {
    switch (widget.type) {
      case AppSnackbarType.success:
        return const Color(0xFF10B981);
      case AppSnackbarType.error:
        return const Color(0xFFEF4444);
      case AppSnackbarType.warning:
        return const Color(0xFFF59E0B);
      case AppSnackbarType.info:
        return const Color(0xFF38BDF8);
    }
  }

  List<List<dynamic>> get _iconData {
    switch (widget.type) {
      case AppSnackbarType.success:
        return HugeIcons.strokeRoundedCheckmarkCircle02;
      case AppSnackbarType.error:
        return HugeIcons.strokeRoundedAlertCircle;
      case AppSnackbarType.warning:
        return HugeIcons.strokeRoundedAlert02;
      case AppSnackbarType.info:
        return HugeIcons.strokeRoundedInformationCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;

    return Center(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E242B),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white.withAlpha(28),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(65),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: accent.withAlpha(35),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: accent.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: HugeIcon(
                      icon: _iconData,
                      size: 16,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.actionLabel != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onAction,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withAlpha(35),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.actionLabel!,
                          style: TextStyle(
                            color: accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

