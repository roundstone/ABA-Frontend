import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Interactive Hero Banner Carousel matching Web Storefront (HeroBanner.tsx).
/// Slides through the 3 authentic local banners with page indicator & tap actions.
class HomeHeroBanner extends StatefulWidget {
  const HomeHeroBanner({super.key, this.imageUrl});
  final String? imageUrl;

  @override
  State<HomeHeroBanner> createState() => _HomeHeroBannerState();
}

class _HomeHeroBannerState extends State<HomeHeroBanner> {
  late final PageController _controller;
  int _currentPage = 0;
  Timer? _timer;

  static const List<_BannerItem> _banners = [
    _BannerItem(assetPath: 'assets/images/banners/Buy Naija Banner - 1.png'),
    _BannerItem(assetPath: 'assets/images/banners/Buy Naija Banner - 2.png'),
    _BannerItem(assetPath: 'assets/images/banners/Buy Naija Banner - 3.png'),
    _BannerItem(assetPath: 'assets/images/banners/Buy Naija Banner - 4.png'),
    _BannerItem(assetPath: 'assets/images/banners/Buy Naija Banner - 5.png'),
    _BannerItem(assetPath: 'assets/images/banners/Buy Naija Banner - 6.png'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
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
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Replaced Fixed SizedBox Height with AspectRatio matching 2057/764
        AspectRatio(
          aspectRatio: 2057 / 764,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: GestureDetector(
                  onTap: () => context.go('/shop'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: AppSpacing.borderRadiusXL,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Banner background image
                        Image.asset(
                          banner.assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => AppNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.cover,
                            fallbackType: AppImageFallbackType.banner,
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.grey.withAlpha(80),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerItem {
  const _BannerItem({
    required this.assetPath,
  });

  final String assetPath;
}
