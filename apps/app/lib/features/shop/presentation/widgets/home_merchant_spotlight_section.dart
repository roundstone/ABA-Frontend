import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../merchants/application/merchant_providers.dart';

/// Highlighted Merchant Spotlight Showcase Card (Web Doc 06 / SpotlightSection).
class HomeMerchantSpotlightSection extends ConsumerWidget {
  const HomeMerchantSpotlightSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final merchantsAsync = ref.watch(merchantsDirectoryProvider);

    return merchantsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (result) {
        if (result.merchants.isEmpty) return const SizedBox.shrink();
        final spotlight = result.merchants.firstWhere(
          (m) => m.isFeatured,
          orElse: () => result.merchants.first,
        );

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: AppSpacing.borderRadiusXL,
            border: Border.all(
              color: isDark ? Colors.white10 : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 40 : 10),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner header with badge
              SizedBox(
                height: 120,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      spotlight.bannerImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(160),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC28B38),
                          borderRadius: AppSpacing.borderRadiusSM,
                        ),
                        child: Text(
                          'SPOTLIGHT SELLER',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content body
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(spotlight.logoUrl),
                      onBackgroundImageError: (_, __) {},
                      child: Text(
                        spotlight.name.substring(0, 1),
                        style: AppTypography.h5.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  spotlight.name,
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (spotlight.isVerified) ...[
                                const SizedBox(width: 4),
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedShieldCheck,
                                  color: AppColors.success,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${spotlight.category} • ${spotlight.city}, ${spotlight.state}',
                            style: AppTypography.caption.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFF59E0B),
                                size: 16,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${spotlight.rating} (${spotlight.reviewCount} reviews)',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: () {
                        context.go(
                          '/shop?merchant=${Uri.encodeComponent(spotlight.name)}',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(72, 36),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.avatarRadius,
                        ),
                      ),
                      child: const Text('Visit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
