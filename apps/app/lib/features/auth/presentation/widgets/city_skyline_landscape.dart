import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Decorative bottom landscape with city skyline and rolling mint green hills.
class CitySkylineLandscape extends StatelessWidget {
  const CitySkylineLandscape({
    super.key,
    this.height = 95,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: CustomPaint(
          painter: _SkylineLandscapePainter(isDark: isDark),
        ),
      ),
    );
  }
}

class _SkylineLandscapePainter extends CustomPainter {
  const _SkylineLandscapePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final skylineColor = isDark
        ? AppColors.primary.withAlpha(55)
        : AppColors.primary.withAlpha(22);
    final midHillColor = isDark
        ? AppColors.primary.withAlpha(85)
        : AppColors.primary.withAlpha(42);
    final foreHillColor = isDark
        ? AppColors.primary.withAlpha(120)
        : AppColors.primary.withAlpha(68);

    _paintSkylineSilhouettes(canvas, w, h, skylineColor);
    _paintMidHills(canvas, w, h, midHillColor);
    _paintForegroundHills(canvas, w, h, foreHillColor);
  }

  void _paintSkylineSilhouettes(Canvas canvas, double w, double h, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Distant buildings & landmarks (bridge, tower, blocks)
    final path = Path();
    final base = h * 0.72;

    // Left buildings
    path.moveTo(0, base);
    path.lineTo(w * 0.05, base);
    path.lineTo(w * 0.05, base - 20);
    path.lineTo(w * 0.10, base - 20);
    path.lineTo(w * 0.10, base - 28);
    path.lineTo(w * 0.14, base - 28);
    path.lineTo(w * 0.14, base - 16);
    path.lineTo(w * 0.20, base - 16);
    path.lineTo(w * 0.20, base - 35);
    path.lineTo(w * 0.26, base - 35);
    path.lineTo(w * 0.26, base - 22);
    path.lineTo(w * 0.32, base - 22);
    path.lineTo(w * 0.32, base);

    // Mid city blocks
    path.lineTo(w * 0.36, base);
    path.lineTo(w * 0.36, base - 18);
    path.lineTo(w * 0.42, base - 18);
    path.lineTo(w * 0.42, base - 32);
    path.lineTo(w * 0.48, base - 32);
    path.lineTo(w * 0.48, base - 20);
    path.lineTo(w * 0.54, base - 20);
    path.lineTo(w * 0.54, base);

    // Suspension Bridge structure
    final bStart = w * 0.60;
    final bEnd = w * 0.85;
    path.lineTo(bStart, base);
    path.lineTo(bStart, base - 10);
    // Left tower
    path.lineTo(w * 0.66, base - 10);
    path.lineTo(w * 0.66, base - 38);
    path.lineTo(w * 0.68, base - 38);
    path.lineTo(w * 0.68, base - 10);
    // Right tower
    path.lineTo(w * 0.77, base - 10);
    path.lineTo(w * 0.77, base - 38);
    path.lineTo(w * 0.79, base - 38);
    path.lineTo(w * 0.79, base - 10);
    path.lineTo(bEnd, base - 10);
    path.lineTo(bEnd, base);

    // Needle Tower on far right
    path.lineTo(w * 0.88, base);
    path.lineTo(w * 0.89, base - 48);
    path.lineTo(w * 0.90, base - 56);
    path.lineTo(w * 0.91, base - 48);
    path.lineTo(w * 0.92, base);
    path.lineTo(w, base);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawPath(path, paint);

    // Bridge suspension cables
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cablePath = Path()
      ..moveTo(bStart, base - 10)
      ..quadraticBezierTo(w * 0.63, base - 25, w * 0.67, base - 36)
      ..quadraticBezierTo(w * 0.725, base - 14, w * 0.78, base - 36)
      ..quadraticBezierTo(w * 0.82, base - 25, bEnd, base - 10);
    canvas.drawPath(cablePath, linePaint);
  }

  void _paintMidHills(Canvas canvas, double w, double h, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, h * 0.62)
      ..cubicTo(w * 0.28, h * 0.52, w * 0.45, h * 0.76, w * 0.75, h * 0.58)
      ..cubicTo(w * 0.88, h * 0.52, w * 0.95, h * 0.55, w, h * 0.57)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _paintForegroundHills(Canvas canvas, double w, double h, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, h * 0.78)
      ..cubicTo(w * 0.22, h * 0.68, w * 0.40, h * 0.88, w * 0.68, h * 0.74)
      ..cubicTo(w * 0.82, h * 0.66, w * 0.92, h * 0.75, w, h * 0.72)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SkylineLandscapePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

