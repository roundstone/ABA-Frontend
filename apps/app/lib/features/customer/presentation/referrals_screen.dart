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
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_widgets.dart';
import 'widgets/referral_activation_card.dart';
import 'widgets/referral_invite_card.dart';
import 'widgets/referral_kpi_cards.dart';
import 'widgets/referral_leaderboard_section.dart';
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
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedShare01,
              color: Colors.white,
              size: 24,
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
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Actions (Marketer & Ledger)
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  label: 'Network Tree',
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedNetwork,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  onPressed: () =>
                                      context.push('/referrals/profile'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: AppButton(
                                  label: 'Ledger',
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  icon: const HugeIcon(
                                    icon: HugeIcons.strokeRoundedBook02,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  onPressed: () =>
                                      context.push('/referrals/ledger'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Referral Activation Status & Fee Notice
                          const ReferralActivationCard(),

                          // KPI Cards (Total Network, Active Buyers, Total Earned)
                          ReferralKpiCardsRow(metrics: data.metrics),
                          const SizedBox(height: AppSpacing.xl),

                          // Invite & Earn Card
                          ReferralInviteCard(
                            referralCode: activeCode,
                            referralLink: activeLink,
                            hasCode: hasCode,
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
                          ReferralNetworkList(stats: data.stats),
                          const SizedBox(height: AppSpacing.xl),

                          // Top Promoters Leaderboard -> Not needed now; leave commented for future reference
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
