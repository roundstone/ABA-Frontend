import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'more_menu_sheet.dart';

/// Shell scaffold that wraps all customer-facing tabs and renders the
/// floating bottom navigation bar.
class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    if (index == 3) {
      // "More" tab – show the overlay sheet instead of navigating
      showMoreMenu(context);
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true, // let body draw behind the nav bar
      bottomNavigationBar: _FloatingNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => _onTap(context, i),
      ),
    );
  }
}

// ─── Floating nav bar ────────────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: HugeIcons.strokeRoundedHome01, label: 'Home'),
    _NavItem(icon: HugeIcons.strokeRoundedStore01, label: 'Shop'),
    _NavItem(icon: HugeIcons.strokeRoundedWallet01, label: 'Wallet'),
    _NavItem(icon: HugeIcons.strokeRoundedMenu01, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.md,
        ),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: AppSpacing.borderRadiusXXL,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 80 : 20),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final isSelected = i == currentIndex && i != 3;
              return _NavButton(
                item: item,
                isSelected: isSelected,
                onTap: () => onTap(i),
                primaryColor: cs.primary,
                isDark: isDark,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.isDark,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final activeColor = primaryColor;
    final inactiveColor =
        isDark ? Colors.white.withAlpha(120) : Colors.black.withAlpha(100);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppSpacing.animationFast,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withAlpha(20) : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusXL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: item.icon,
              size: isSelected ? 26 : 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: AppTypography.label.copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final List<List<dynamic>> icon;
  final String label;
}
