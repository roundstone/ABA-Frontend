import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../auth/application/auth_providers.dart';
import 'marketer_profile_models.dart';
import 'widgets/marketer_network_section.dart';
import 'widgets/marketer_performance_charts.dart';
import 'widgets/marketer_profile_header.dart';
import 'widgets/marketer_profile_kpis.dart';
import 'widgets/network_tree.dart';

export 'marketer_profile_models.dart';

class MarketerProfileScreen extends ConsumerStatefulWidget {
  const MarketerProfileScreen({super.key});

  @override
  ConsumerState<MarketerProfileScreen> createState() =>
      _MarketerProfileScreenState();
}

class _MarketerProfileScreenState extends ConsumerState<MarketerProfileScreen> {
  bool isPublic = false;

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(marketerProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : AppColors.onBackground,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () {
            final fallback = ref.read(authStateProvider).isMerchant
                ? '/merchant'
                : '/home';
            context.popOrGo(fallback);
          },
        ),
        title: const Text('Marketer Profile'),
      ),
      body: PopScope(
        canPop: context.canPopSafely,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          final fallback = ref.read(authStateProvider).isMerchant
              ? '/merchant'
              : '/home';
          context.popOrGo(fallback);
        },
        child: asyncData.when(
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
                        // 1. Header Section
                        MarketerProfileHeader(
                          profile: profile,
                          isPublic: isPublic,
                          onPublicChanged: (val) {
                            setState(() => isPublic = val);
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // 2. Profile KPIs
                        MarketerProfileKpis(profile: profile),
                        const SizedBox(height: AppSpacing.xl),

                        // 3. Referral Network Explorer (Upline & Downline with Depth 1-3)
                        const MarketerNetworkSection(),
                        const SizedBox(height: AppSpacing.xl),

                        // 4. Network Visualisation (Tree view)
                        Text(
                          'Network Visualisation',
                          style: AppTypography.h6.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        NetworkTreeWidget(
                          data: profile.networkData,
                          anonymize: true,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // 5. Performance Metrics
                        Text(
                          'Performance Metrics',
                          style: AppTypography.h6.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        MarketerPerformanceCharts(profile: profile),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
