import 'package:app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Logo for BuyNaija featuring the iconic smiling shopping bag.
class BuyNaijaLogo extends StatelessWidget {
  const BuyNaijaLogo({super.key, this.fontSize = 22, this.iconSize = 28});

  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(iconSize, iconSize),
          painter: const _ShoppingBagIconPainter(color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          'BuyNaija',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}

class _ShoppingBagIconPainter extends CustomPainter {
  const _ShoppingBagIconPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Bag body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.28, w * 0.76, h * 0.64),
        const Radius.circular(6),
      ),
      strokePaint,
    );

    // Arched handle
    final handlePath = Path()
      ..moveTo(w * 0.32, h * 0.28)
      ..cubicTo(w * 0.32, h * 0.08, w * 0.68, h * 0.08, w * 0.68, h * 0.28);
    canvas.drawPath(handlePath, strokePaint);

    // Smile
    final smilePath = Path()
      ..moveTo(w * 0.36, h * 0.60)
      ..quadraticBezierTo(w * 0.50, h * 0.75, w * 0.64, h * 0.60);
    canvas.drawPath(smilePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _ShoppingBagIconPainter old) =>
      old.color != color;
}

/// Curved underline accent flourish under hero text.
class DecorativeCurve extends StatelessWidget {
  const DecorativeCurve({
    super.key,
    this.width = 44,
    this.height = 10,
    this.color,
  });

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _CurvePainter(color: effectiveColor)),
    );
  }
}

class _CurvePainter extends CustomPainter {
  const _CurvePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.5, 0, size.width, size.height * 0.6);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvePainter old) => old.color != color;
}
