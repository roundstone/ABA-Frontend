import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/domain/auth_entities.dart';

class SettingsUserCard extends StatelessWidget {
  const SettingsUserCard({
    super.key,
    required this.user,
    required this.isDark,
    required this.onEditProfile,
  });

  final AuthUser? user;
  final bool isDark;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusMD,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withAlpha(30),
                child: Text(
                  (user?.name.isNotEmpty ?? false ? user!.name[0] : 'U')
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Customer Account',
                      style: AppTypography.titleSmall
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user?.email ?? 'customer@aba-erp.com',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.phone ?? '+234 801 234 5678',
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditProfile,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit Profile Information'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
