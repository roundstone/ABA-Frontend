import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/application/auth_providers.dart';
import 'more_menu_items.dart';

/// Shows the "More" overlay menu anchored above the nav bar.
void showMoreMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(120),
    builder: (_) => const _MoreMenuSheet(),
  );
}

class _MoreMenuSheet extends ConsumerWidget {
  const _MoreMenuSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F8F9);
    final isMerchant = ref.watch(isMerchantProvider);

    final items = buildMoreMenuItems(
      context: context,
      isMerchant: isMerchant,
      ref: ref,
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // tap outside closes
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // absorb taps inside sheet
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                // sit just above the floating nav bar (64 bar + 16 padding + safeArea ~34)
                114,
              ),
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius: AppSpacing.borderRadiusXXL,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 100 : 25),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withAlpha(40)
                              : Colors.black.withAlpha(20),
                          borderRadius: AppSpacing.avatarRadius,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.sm,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: AppSpacing.sm,
                              crossAxisSpacing: AppSpacing.sm,
                              childAspectRatio: 0.9,
                            ),
                        itemBuilder: (context, i) =>
                            _MoreMenuTile(item: items[i]),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Grid tile ───────────────────────────────────────────────────────────

class _MoreMenuTile extends StatelessWidget {
  const _MoreMenuTile({required this.item});
  final MoreMenuItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        if (item.route != null) {
          context.push(item.route!);
        } else if (item.onTap != null) {
          item.onTap!(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: tileBg,
          borderRadius: AppSpacing.borderRadiusLG,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.color.withAlpha(isDark ? 40 : 20),
                borderRadius: AppSpacing.borderRadiusMD,
              ),
              child: Center(
                child: HugeIcon(
                  icon: item.icon,
                  color: item.color,
                  size: AppSpacing.iconSizeMD,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs + 2),
            Text(
              item.label,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white.withAlpha(220)
                    : AppColors.onBackground,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

