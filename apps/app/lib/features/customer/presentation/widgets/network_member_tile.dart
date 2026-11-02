import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/referral_network_member.dart';

class NetworkMemberTile extends StatelessWidget {
  const NetworkMemberTile({super.key, required this.member});
  final ReferralNetworkMember member;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _levelColor(member.level).withAlpha(30),
            child: Text(
              member.initials,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _levelColor(member.level),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName,
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
                ),
                if (member.username != null && member.username!.isNotEmpty)
                  Text(
                    '@${member.username}',
                    style: AppTypography.caption.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _levelColor(member.level).withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _levelColor(member.level).withAlpha(80)),
            ),
            child: Text(
              'Level ${member.level}',
              style: TextStyle(
                color: _levelColor(member.level),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _levelColor(int level) {
    switch (level) {
      case 1:
        return AppColors.primary;
      case 2:
        return const Color(0xFFC28B38);
      case 3:
      default:
        return Colors.indigo;
    }
  }
}

