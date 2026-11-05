import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_widgets.dart';

class ReferralLeaderboardSection extends StatelessWidget {
  const ReferralLeaderboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.borderRadiusLG,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedTrophy,
            color: AppColors.warning,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Top Promoters',
            style: AppTypography.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'See who is leading the charge. Top 5 promoters receive bonus commissions.',
            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: AppSpacing.borderRadiusLG,
            ),
            child: const Column(
              children: [
                ReferralLeaderboardTile(
                  rank: 1,
                  name: 'Chinedu Okafor',
                  earnings: 15400000,
                ),
                Divider(height: 1, color: Colors.white24),
                ReferralLeaderboardTile(
                  rank: 2,
                  name: 'Aisha Bello',
                  earnings: 8900000,
                ),
                Divider(height: 1, color: Colors.white24),
                ReferralLeaderboardTile(
                  rank: 3,
                  name: 'Samuel O.',
                  earnings: 7600000,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Theme(
            data: Theme.of(context).copyWith(
              brightness: Brightness.dark,
              colorScheme: Theme.of(
                context,
              ).colorScheme.copyWith(onSurface: Colors.white),
            ),
            child: AppButton.outlined(
              label: 'View Full Rankings',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ReferralLeaderboardTile extends StatelessWidget {
  const ReferralLeaderboardTile({
    super.key,
    required this.rank,
    required this.name,
    required this.earnings,
  });

  final int rank;
  final String name;
  final int earnings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Text(
              name.isNotEmpty ? name[0] : 'U',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            formatNaira(earnings / 100),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

