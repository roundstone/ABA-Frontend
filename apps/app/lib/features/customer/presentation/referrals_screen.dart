import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/router/safe_navigation.dart';
import '../../auth/application/auth_providers.dart';
import '../application/referral_activation_provider.dart';
import '../application/referral_summary_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_widgets.dart';
import 'widgets/referral_activation_card.dart';
import 'widgets/referral_invite_card.dart';
import 'widgets/referral_kpi_cards.dart';
import 'widgets/referral_network_list.dart';

export '../application/referral_summary_providers.dart';

class ReferralsScreen extends ConsumerStatefulWidget {
  const ReferralsScreen({super.key});

  @override
  ConsumerState<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends ConsumerState<ReferralsScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(referralDataProvider);
    final activationState = ref.watch(referralActivationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedCode =
        asyncData.value?.referralCode?.trim().isNotEmpty == true
        ? asyncData.value!.referralCode!.trim()
        : (activationState.hasCode ? activationState.referralCode! : null);
    final hasCode = resolvedCode != null && resolvedCode.isNotEmpty;
    final activeCode = hasCode ? resolvedCode : 'Not generated yet';
    final activeLink = hasCode
        ? 'https://abaonline.vercel.app/community/$activeCode'
        : 'Generate your referral code above to get your invite link';

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
        title: const Text('Referral Network'),
        actions: [
          IconButton(
            tooltip: 'Marketer Tree',
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedNetwork,
              color: isDark ? Colors.white70 : AppColors.onBackground,
              size: 20,
            ),
            onPressed: () => context.push('/referrals/profile'),
          ),
          IconButton(
            tooltip: 'Ledger',
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedBook02,
              color: isDark ? Colors.white70 : AppColors.onBackground,
              size: 20,
            ),
            onPressed: () => context.push('/referrals/ledger'),
          ),
          IconButton(
            tooltip: 'Share',
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedShare01,
              color: AppColors.primary,
              size: 20,
            ),
            onPressed: hasCode
                ? () {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            'Join me on BuyNaija! Use my referral code: $activeCode when signing up: $activeLink',
                      ),
                    );
                  }
                : null,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
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
          loading: () => const LoadingState(message: 'Loading referrals...'),
          error: (err, _) => ErrorState(
            message:
                'Could not load referrals.\n${ApiError.toUserFriendlyMessage(err)}',
            onRetry: () => ref.invalidate(referralDataProvider),
          ),
          data: (data) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(referralDataProvider);
                await ref.read(referralDataProvider.future);
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // -> Not needed now; leave commented for future reference
                          // 1. Quick Navigation Hub (Marketer Tree & Commission Ledger)
                          // const ReferralQuickActions(),
                          // const SizedBox(height: AppSpacing.md),

                          // 2. Referral Activation Status & Fee Notice (if needed)
                          const ReferralActivationCard(),
                          const SizedBox(height: AppSpacing.md),
                          // 3. Invite & Earn Card (Hero Referral Code & 1-tap Actions)
                          ReferralInviteCard(
                            referralCode: activeCode,
                            referralLink: activeLink,
                            hasCode: hasCode,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // 4. KPI Performance Summary Cards
                          ReferralKpiCardsRow(metrics: data.metrics),
                          const SizedBox(height: AppSpacing.md),

                          // 5. Your Network Section
                          Row(
                            children: [
                              Text(
                                'Your Network',
                                style: AppTypography.h6.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  data.stats.length.toString(),
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ReferralNetworkList(stats: data.stats),
                          const SizedBox(height: AppSpacing.xl),

                          // 6. Top Promoters Leaderboard -> Not needed now; leave commented for future reference
                          // const ReferralLeaderboardSection(),
                          // const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
