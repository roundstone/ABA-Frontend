import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';

// ─── Domain & Providers ───────────────────────────────────────────────────

class ReferralMetrics {
  final int totalNetwork;
  final int activeBuyers;
  final int totalEarned; // in minor units
  const ReferralMetrics({
    required this.totalNetwork,
    required this.activeBuyers,
    required this.totalEarned,
  });
}

class ReferralStat {
  final String referredUserName;
  final DateTime joinedDate;
  final String status;
  final int earnings; // in minor units
  const ReferralStat({
    required this.referredUserName,
    required this.joinedDate,
    required this.status,
    required this.earnings,
  });
}

class ReferralData {
  final ReferralMetrics metrics;
  final List<ReferralStat> stats;
  const ReferralData({required this.metrics, required this.stats});
}

final referralDataProvider = FutureProvider.autoDispose<ReferralData>((
  ref,
) async {
  // Mock API delay
  await Future.delayed(const Duration(milliseconds: 800));
  return ReferralData(
    metrics: const ReferralMetrics(
      totalNetwork: 142,
      activeBuyers: 85,
      totalEarned: 15400000,
    ),
    stats: [
      ReferralStat(
        referredUserName: 'Chima Obi',
        joinedDate: DateTime.now().subtract(const Duration(days: 12)),
        status: 'Active',
        earnings: 450000,
      ),
      ReferralStat(
        referredUserName: 'Aisha Bello',
        joinedDate: DateTime.now().subtract(const Duration(days: 4)),
        status: 'Pending Purchase',
        earnings: 0,
      ),
    ],
  );
});

// ─── Screen ───────────────────────────────────────────────────────────────

class ReferralsScreen extends ConsumerStatefulWidget {
  const ReferralsScreen({super.key});

  @override
  ConsumerState<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends ConsumerState<ReferralsScreen> {
  final String referralCode = "ABA-JANE-123";
  final String referralLink = "https://aba-erp.com/register?ref=ABA-JANE-123";

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(referralDataProvider);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Network'),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedShare01,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: asyncData.when(
        loading: () => const LoadingState(message: 'Loading referrals...'),
        error: (err, _) => ErrorState(
          message: 'Could not load referrals.\n${err.toString()}',
          onRetry: () => ref.invalidate(referralDataProvider),
        ),
        data: (data) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Actions
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () =>
                                  context.push('/referrals/profile'),
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedNetwork,
                                color: isDark ? Colors.white : Colors.black,
                                size: 18,
                              ),
                              label: Text(
                                'Marketer',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {},
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedShare01,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: const Text('Share Link'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // KPI Cards
                      _KpiCardsRow(metrics: data.metrics),
                      const SizedBox(height: AppSpacing.xl),

                      // Invite & Earn Card
                      _InviteCard(
                        referralCode: referralCode,
                        referralLink: referralLink,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Your Network
                      Text(
                        'Your Network',
                        style: AppTypography.h6.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _NetworkList(stats: data.stats),
                      const SizedBox(height: AppSpacing.xl),

                      // Top Promoters Leaderboard
                      const _LeaderboardSection(),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _KpiCardsRow extends StatelessWidget {
  const _KpiCardsRow({required this.metrics});
  final ReferralMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _KpiCard(
            title: 'Total Network',
            value: metrics.totalNetwork.toString(),
            subtitle: '+3 this month',
            icon: HugeIcons.strokeRoundedUserMultiple,
            iconColor: AppColors.primary,
            iconBg: AppColors.primary.withAlpha(25),
          ),
          const SizedBox(width: AppSpacing.md),
          _KpiCard(
            title: 'Active Buyers',
            value: metrics.activeBuyers.toString(),
            subtitle: '75% conversion',
            icon: HugeIcons.strokeRoundedTarget01,
            iconColor: AppColors.success,
            iconBg: AppColors.success.withAlpha(25),
          ),
          const SizedBox(width: AppSpacing.md),
          _KpiCard(
            title: 'Total Earned',
            value: formatNaira(metrics.totalEarned / 100),
            subtitle: 'Lifetime',
            icon: HugeIcons.strokeRoundedDollarCircle,
            iconColor: AppColors.warning,
            iconBg: AppColors.warning.withAlpha(25),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
  final String title;
  final String value;
  final String subtitle;
  final dynamic icon;
  final Color iconColor;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 150,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(icon: icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.label.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTypography.caption.copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard({required this.referralCode, required this.referralLink});
  final String referralCode;
  final String referralLink;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedShare01,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Invite & Earn',
            style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Share your referral link with friends. When they sign up and make a purchase, you earn a percentage as commission!',
            style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: AppSpacing.borderRadiusSM,
              border: Border.all(
                color: isDark ? Colors.white12 : AppColors.border,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'YOUR REFERRAL CODE',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  referralCode,
                  style: AppTypography.h6.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: isDark ? Colors.white12 : AppColors.border,
                    ),
                  ),
                  child: Text(
                    referralLink,
                    style: AppTypography.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCopy01,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetworkList extends StatelessWidget {
  const _NetworkList({required this.stats});
  final List<ReferralStat> stats;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final stat = stats[i];
          final isActive = stat.status == 'Active';
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(25),
              child: Text(
                stat.referredUserName[0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              stat.referredUserName,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              isActive ? 'Active' : 'Pending Purchase',
              style: AppTypography.caption.copyWith(
                color: isActive ? AppColors.success : cs.onSurfaceVariant,
              ),
            ),
            trailing: Text(
              formatNaira(stat.earnings / 100),
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LeaderboardSection extends StatelessWidget {
  const _LeaderboardSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
                _LeaderboardTile(
                  rank: 1,
                  name: 'Chima Obi',
                  earnings: 15400000,
                ),
                Divider(height: 1, color: Colors.white24),
                _LeaderboardTile(
                  rank: 2,
                  name: 'Aisha Bello',
                  earnings: 8900000,
                ),
                Divider(height: 1, color: Colors.white24),
                _LeaderboardTile(rank: 3, name: 'Samuel O.', earnings: 7600000),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
              ),
              onPressed: () {},
              child: const Text('View Full Rankings'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({
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
              name[0],
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
