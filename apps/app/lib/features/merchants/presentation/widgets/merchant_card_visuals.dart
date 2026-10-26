import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

import '../../../../core/widgets/app_network_image.dart';

class MerchantBannerImage extends StatelessWidget {
  const MerchantBannerImage({super.key, this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AppNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      fallbackType: AppImageFallbackType.banner,
      placeholder: (_) => const MerchantBannerFallback(),
      errorWidget: (_, __, ___) => const MerchantBannerFallback(),
    );
  }
}

class MerchantBannerFallback extends StatelessWidget {
  const MerchantBannerFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF172A1D), Color(0xFF2B4734)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class MerchantLogoAvatar extends StatelessWidget {
  const MerchantLogoAvatar({super.key, this.logoUrl, required this.name});
  final String? logoUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242424) : Colors.white,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: isDark ? const Color(0xFF333333) : Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AppNetworkImage(
        imageUrl: logoUrl,
        fit: BoxFit.cover,
        fallbackType: AppImageFallbackType.merchant,
        placeholder: (_) => MerchantLogoFallback(name: name),
        errorWidget: (_, __, ___) => MerchantLogoFallback(name: name),
      ),
    );
  }
}

class MerchantLogoFallback extends StatelessWidget {
  const MerchantLogoFallback({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'M',
        style: AppTypography.h5.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
