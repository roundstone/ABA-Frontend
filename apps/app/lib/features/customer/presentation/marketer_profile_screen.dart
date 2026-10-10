import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import 'widgets/network_tree.dart';

// ─── Domain & Providers ───────────────────────────────────────────────────

class MarketerProfileData {
  final String alias;
  final int level;
  final DateTime? joinedDate;
  final int? performancePercentile;
  final int networkSales;
  final int personalSales;
  final int totalTeamSize;
  final int activeMembers;
  final NetworkNode networkData;
  
  final List<LevelStat> teamSizeByLevel;
  final List<LevelStat> salesByLevel;

  MarketerProfileData({
    required this.alias,
    required this.level,
    this.joinedDate,
    this.performancePercentile,
    required this.networkSales,
    required this.personalSales,
    required this.totalTeamSize,
    required this.activeMembers,
    required this.networkData,
    required this.teamSizeByLevel,
    required this.salesByLevel,
  });
}

class LevelStat {
  final String name;
  final int value;
  LevelStat(this.name, this.value);
}

final marketerProfileProvider = FutureProvider.autoDispose<MarketerProfileData>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return MarketerProfileData(
    alias: 'Chima Obi',
    level: 4,
    joinedDate: DateTime(2023, 5, 10),
    performancePercentile: 5,
    networkSales: 45000000,
    personalSales: 1200000,
    totalTeamSize: 142,
    activeMembers: 85,
    networkData: NetworkNode(
      id: 'root',
      name: 'Chima Obi',
      code: 'CHIMA001',
      level: 4,
      sales: 45000000,
      personalSales: 1200000,
      active: true,
      performancePercentile: 5,
      joinedDate: DateTime(2023, 5, 10),
      children: [
        NetworkNode(
          id: 'child1',
          name: 'Aisha Bello',
          code: 'AISHA001',
          level: 3,
          sales: 12000000,
          personalSales: 500000,
          active: true,
          performancePercentile: 15,
          children: [
            NetworkNode(
              id: 'grandchild1',
              name: 'Samuel O.',
              code: 'SAM001',
              level: 2,
              sales: 3000000,
              personalSales: 100000,
              active: false,
              performancePercentile: 60,
            ),
          ],
        ),
        NetworkNode(
          id: 'child2',
          name: 'Ibrahim M.',
          code: 'IBR001',
          level: 2,
          sales: 5000000,
          personalSales: 200000,
          active: true,
          performancePercentile: 45,
        ),
      ],
    ),
    teamSizeByLevel: [
      LevelStat('Level 1', 20),
      LevelStat('Level 2', 45),
      LevelStat('Level 3', 77),
    ],
    salesByLevel: [
      LevelStat('Level 1', 12000000),
      LevelStat('Level 2', 15000000),
      LevelStat('Level 3', 18000000),
    ],
  );
});

// ─── Screen ───────────────────────────────────────────────────────────────

class MarketerProfileScreen extends ConsumerStatefulWidget {
  const MarketerProfileScreen({super.key});

  @override
  ConsumerState<MarketerProfileScreen> createState() => _MarketerProfileScreenState();
}

class _MarketerProfileScreenState extends ConsumerState<MarketerProfileScreen> {
  bool isPublic = false;

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(marketerProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketer Profile'),
      ),
      body: asyncData.when(
        loading: () => const LoadingState(message: 'Loading profile...'),
        error: (err, _) => ErrorState(
          message: 'Could not load profile.\n${err.toString()}',
          onRetry: () => ref.invalidate(marketerProfileProvider),
        ),
        data: (profile) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      _HeaderSection(profile: profile, isPublic: isPublic, onPublicChanged: (val) {
                        setState(() => isPublic = val);
                      }),
                      const SizedBox(height: AppSpacing.xl),

                      // KPIs
                      _ProfileKpis(profile: profile),
                      const SizedBox(height: AppSpacing.xl),

                      // Network Visualisation
                      Text('Network Visualisation', style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.md),
                      NetworkTreeWidget(data: profile.networkData, anonymize: true),
                      const SizedBox(height: AppSpacing.xl),

                      // Performance Metrics
                      Text('Performance Metrics', style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.md),
                      _PerformanceCharts(profile: profile),
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.profile,
    required this.isPublic,
    required this.onPublicChanged,
  });

  final MarketerProfileData profile;
  final bool isPublic;
  final ValueChanged<bool> onPublicChanged;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.green.shade50,
                child: Text(
                  profile.alias.isNotEmpty ? profile.alias[0] : 'A',
                  style: TextStyle(fontSize: 24, color: Colors.green.shade700, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.alias, style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Level ${profile.level}', style: AppTypography.caption.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text('•', style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
                        const SizedBox(width: AppSpacing.sm),
                        Text('Joined ${profile.joinedDate?.year ?? "N/A"}', style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                    if (profile.performancePercentile != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text('Top ${100 - profile.performancePercentile!}% of peers', style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                    ]
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainerHighest : AppColors.background,
              borderRadius: AppSpacing.borderRadiusMD,
              border: Border.all(color: isDark ? Colors.transparent : AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Public Profile', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Show your aggregated stats at /community/${profile.alias.replaceAll(" ", "").toLowerCase()}', style: AppTypography.caption),
                    ],
                  ),
                ),
                Switch(value: isPublic, onChanged: onPublicChanged),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileKpis extends StatelessWidget {
  const _ProfileKpis({required this.profile});
  final MarketerProfileData profile;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.2,
      children: [
        _SmallKpiCard(title: 'Network Sales', value: formatNaira(profile.networkSales / 100)),
        _SmallKpiCard(title: 'Personal Sales', value: formatNaira(profile.personalSales / 100)),
        _SmallKpiCard(title: 'Total Team Size', value: profile.totalTeamSize.toString()),
        _SmallKpiCard(title: 'Active Members', value: profile.activeMembers.toString()),
      ],
    );
  }
}

class _SmallKpiCard extends StatelessWidget {
  const _SmallKpiCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTypography.caption.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _PerformanceCharts extends StatelessWidget {
  const _PerformanceCharts({required this.profile});
  final MarketerProfileData profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BarChart(title: 'Team Size by Level', data: profile.teamSizeByLevel, isCurrency: false),
        const SizedBox(height: AppSpacing.md),
        _BarChart(title: 'Sales by Level', data: profile.salesByLevel, isCurrency: true),
      ],
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.title, required this.data, required this.isCurrency});
  final String title;
  final List<LevelStat> data;
  final bool isCurrency;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final int maxValue = data.fold(0, (max, stat) => stat.value > max ? stat.value : max);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.lg),
          ...data.map((stat) {
            final double percent = maxValue == 0 ? 0 : stat.value / maxValue;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(stat.name, style: AppTypography.caption),
                      Text(
                        isCurrency ? formatNaira(stat.value / 100) : stat.value.toString(),
                        style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: isCurrency ? AppColors.success : AppColors.info,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
