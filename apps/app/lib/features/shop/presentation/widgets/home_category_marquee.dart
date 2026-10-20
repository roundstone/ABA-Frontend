import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/shop_entities.dart';

/// Horizontal Category Marquee matching Web CategoryMarquee.
class HomeCategoryMarquee extends StatelessWidget {
  const HomeCategoryMarquee({super.key, required this.categories});
  final List<ShopCategory> categories;

  dynamic _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('shoe') || lower.contains('footwear')) {
      return HugeIcons.strokeRoundedShoppingBag01;
    } else if (lower.contains('bag') || lower.contains('leather')) {
      return HugeIcons.strokeRoundedShoppingBag02;
    } else if (lower.contains('cloth') ||
        lower.contains('fashion') ||
        lower.contains('apparel')) {
      return HugeIcons.strokeRoundedStore01;
    } else if (lower.contains('textile') || lower.contains('fabric')) {
      return HugeIcons.strokeRoundedScissors;
    }
    return HugeIcons.strokeRoundedTag01;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 94,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final icon = _iconForCategory(cat.name);

          return GestureDetector(
            onTap: () {
              context.go('/shop?category=${Uri.encodeComponent(cat.name)}');
            },
            child: Container(
              width: 96,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242424) : Colors.white,
                borderRadius: AppSpacing.borderRadiusLG,
                border: Border.all(
                  color: isDark ? Colors.white10 : AppColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 20 : 6),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withAlpha(50)
                          : const Color(0xFFF0F5F1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: icon,
                        color: isDark
                            ? AppColors.secondary
                            : AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.name,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
