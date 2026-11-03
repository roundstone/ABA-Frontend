import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ShopAdsBanner extends StatefulWidget {
  const ShopAdsBanner({super.key});

  @override
  State<ShopAdsBanner> createState() => _ShopAdsBannerState();
}

class _ShopAdsBannerState extends State<ShopAdsBanner> {
  final PageController _controller = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  final List<String> _banners = const [
    'assets/images/banners/Aba Online_ Shop Local, Shop Aba.png',
    'assets/images/banners/AbaOnline_ Shop Local, Grow Together.png',
    'assets/images/banners/Shop Local, Support Aba.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final nextPage = (_currentPage + 1) % _banners.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _startAutoSlide();
            },
            itemCount: _banners.length,
            itemBuilder: (context, i) {
              return ClipRRect(
                borderRadius: AppSpacing.borderRadiusLG,
                child: Image.asset(_banners[i], fit: BoxFit.cover),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: AppSpacing.animationFast,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? AppColors.primary
                    : AppColors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

