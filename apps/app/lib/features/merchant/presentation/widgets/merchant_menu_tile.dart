import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MerchantSectionTitle extends StatelessWidget {
  const MerchantSectionTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.caption.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class MerchantMenuTile extends StatelessWidget {
  const MerchantMenuTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final List<List<dynamic>> icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withAlpha(isDark ? 40 : 20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: HugeIcon(icon: icon, color: color, size: 18),
        ),
      ),
      title: Text(
        title,
        style: AppTypography.titleSmall.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.caption.copyWith(fontSize: 11),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
