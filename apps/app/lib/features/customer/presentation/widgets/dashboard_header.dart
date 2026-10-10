import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../domain/customer_entities.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.profile});
  final CustomerProfile profile;

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 150,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? const Color(0xFF141E17) : AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF141E17), const Color(0xFF0F1712)]
                  : [AppColors.primary, const Color(0xFF243B2A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withAlpha(40),
                    child: Text(
                      profile.initials,
                      style: AppTypography.h5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome back,',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withAlpha(190),
                          ),
                        ),
                        Text(
                          profile.firstName,
                          style: AppTypography.h4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const NotificationIconButton(color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Dashboard',
        style: AppTypography.h6.copyWith(
          color: cs.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      actionsIconTheme: IconThemeData(color: cs.onPrimary),
      actions: [
        IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLogout01,
            color: Colors.white,
            size: AppSpacing.iconSizeMD,
          ),
          tooltip: 'Logout',
          onPressed: () => _confirmLogout(context),
        ),
      ],
    );
  }
}
