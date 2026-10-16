import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../app_colors.dart';
import '../app_spacing.dart';
import '../app_typography.dart';
import '../theme_provider.dart';

void showThemeModeDialog(BuildContext context, WidgetRef ref) {
  final current = ref.read(themeModeProvider);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ThemeModeSheet(currentMode: current),
  );
}

class _ThemeModeSheet extends ConsumerWidget {
  const _ThemeModeSheet({required this.currentMode});
  final ThemeMode currentMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'Choose Theme Mode',
              style: AppTypography.titleMedium
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ThemeTile(
            title: 'System Default',
            subtitle: 'Automatically follow device OS theme',
            icon: HugeIcons.strokeRoundedSmartPhone01,
            isSelected: currentMode == ThemeMode.system,
            onTap: () {
              ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
              Navigator.pop(context);
            },
          ),
          _ThemeTile(
            title: 'Light Mode',
            subtitle: 'Bright theme with crisp contrast',
            icon: HugeIcons.strokeRoundedSun01,
            isSelected: currentMode == ThemeMode.light,
            onTap: () {
              ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          _ThemeTile(
            title: 'Dark Mode',
            subtitle: 'Sleek dark theme, easy on the eyes',
            icon: HugeIcons.strokeRoundedMoon02,
            isSelected: currentMode == ThemeMode.dark,
            onTap: () {
              ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final List<List<dynamic>> icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(25)
              : (isDark ? Colors.white10 : Colors.black.withAlpha(10)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: HugeIcon(
            icon: icon,
            color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
            size: 20,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTypography.titleSmall.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      subtitle: Text(subtitle, style: AppTypography.caption),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary, size: 22)
          : const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 22),
    );
  }
}
