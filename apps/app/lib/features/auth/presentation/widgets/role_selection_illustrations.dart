import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Rich 3D illustration for Hero section: glossy smiling bag + striped market kiosk.
class HeroMarketIllustration extends StatelessWidget {
  const HeroMarketIllustration({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            top: 4,
            child: Container(
              width: size * 0.88,
              height: size * 0.88,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 8,
            child: _buildGreenShoppingBag(size * 0.60),
          ),
          const Positioned(
            right: 2,
            top: 0,
            child: CustomPaint(
              size: Size(20, 20),
              painter: _SparklesPainter(),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 4,
            child: _buildKioskStall(size * 0.62),
          ),
        ],
      ),
    );
  }

  Widget _buildGreenShoppingBag(double s) {
    return SizedBox(
      width: s,
      height: s * 1.05,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: s * 0.44,
              height: s * 0.32,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          Positioned(
            top: s * 0.22,
            child: Container(
              width: s * 0.88,
              height: s * 0.78,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF284832), AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: CustomPaint(
                  size: Size(s * 0.38, s * 0.20),
                  painter: _WhiteSmilePainter(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKioskStall(double s) {
    return Container(
      width: s,
      height: s * 0.85,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF4EB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2D6C6), width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: -2,
            right: -2,
            child: _buildAwning(),
          ),
          Positioned(
            left: s * 0.14,
            bottom: 0,
            child: Container(
              width: s * 0.28,
              height: s * 0.45,
              decoration: const BoxDecoration(
                color: Color(0xFF475569),
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          ),
          Positioned(
            right: s * 0.14,
            bottom: s * 0.12,
            child: Container(
              width: s * 0.32,
              height: s * 0.30,
              decoration: BoxDecoration(
                color: const Color(0xFFBAE6FD),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFF38BDF8), width: 1),
              ),
            ),
          ),
          Positioned(
            left: -3,
            right: -3,
            bottom: -3,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwning() {
    return Container(
      height: 22,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: List.generate(5, (index) {
          return Expanded(
            child: Container(
              color: index.isEven ? AppColors.primary : Colors.white,
            ),
          );
        }),
      ),
    );
  }
}

class _WhiteSmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.5, size.height * 1.1, size.width, size.height * 0.2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _SparklesPainter extends CustomPainter {
  const _SparklesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(4, 16), const Offset(0, 10), paint);
    canvas.drawLine(const Offset(10, 10), const Offset(12, 2), paint);
    canvas.drawLine(const Offset(15, 15), const Offset(19, 11), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
