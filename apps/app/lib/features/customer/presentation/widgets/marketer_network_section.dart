import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/referrals_network_providers.dart';
import 'network_member_tile.dart';

class MarketerNetworkSection extends ConsumerWidget {
  const MarketerNetworkSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(referralNetworkViewModeProvider);
    final depth = ref.watch(referralNetworkDepthProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final asyncMembers = mode == ReferralNetworkViewMode.downline
        ? ref.watch(referralDownlineProvider(depth))
        : ref.watch(referralUplineProvider(depth));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: isDark ? Colors.white12 : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Referral Network Explorer',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
              ),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedHierarchy,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 1. Mode Tabs (Downline vs Upline)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252525) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _buildModeTab(
                  context,
                  ref,
                  mode: ReferralNetworkViewMode.downline,
                  current: mode,
                  icon: HugeIcons.strokeRoundedUserMultiple02,
                ),
                _buildModeTab(
                  context,
                  ref,
                  mode: ReferralNetworkViewMode.upline,
                  current: mode,
                  icon: HugeIcons.strokeRoundedCrown,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 2. Depth Selector Chips
          Row(
            children: [
              Text(
                'Depth:',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ...[1, 2, 3].map((d) {
                final isSelected = depth == d;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text('Level $d'),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (_) {
                      ref.read(referralNetworkDepthProvider.notifier).state = d;
                    },
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 4),

          // Depth Explanation Caption
          Text(
            _depthDescription(mode, depth),
            style: AppTypography.caption.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 3. Member List or States
          asyncMembers.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Column(
                children: [
                  Text(
                    ApiError.toUserFriendlyMessage(err),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      if (mode == ReferralNetworkViewMode.downline) {
                        ref.invalidate(referralDownlineProvider(depth));
                      } else {
                        ref.invalidate(referralUplineProvider(depth));
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (members) {
              if (members.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(
                    child: Text(
                      mode == ReferralNetworkViewMode.downline
                          ? 'No downline members found at depth $depth.\nShare your referral code to invite others!'
                          : 'No upline sponsors found at depth $depth.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.grey,
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) =>
                    NetworkMemberTile(member: members[i]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(
    BuildContext context,
    WidgetRef ref, {
    required ReferralNetworkViewMode mode,
    required ReferralNetworkViewMode current,
    required List<List<dynamic>> icon,
  }) {
    final isSelected = mode == current;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(referralNetworkViewModeProvider.notifier).state = mode;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                mode.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _depthDescription(ReferralNetworkViewMode mode, int depth) {
    if (mode == ReferralNetworkViewMode.downline) {
      if (depth == 1) return 'Depth 1: Users you directly referred';
      if (depth == 2) {
        return 'Depth 2: Direct referrals plus users referred by them';
      }
      return 'Depth 3: Includes third-level network referrals';
    } else {
      if (depth == 1) return 'Depth 1: The person who directly referred you';
      if (depth == 2) return 'Depth 2: Direct referrer plus their referrer';
      return 'Depth 3: Continues further upward sponsor chain';
    }
  }
}
