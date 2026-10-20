import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../../core/config/app_brand.dart';
import '../../../core/router/safe_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/content_mock_data.dart';
import '../domain/content_entities.dart';
import 'community_profile_widgets.dart';

/// Public Community Partner Profile Screen matching Web /community/[handle].
class CommunityProfileScreen extends StatelessWidget {
  const CommunityProfileScreen({super.key, required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final partner = ContentMockData.getPartnerByHandle(handle);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '@$handle',
          style: AppTypography.h4.copyWith(fontWeight: FontWeight.w800),
        ),
        leading: context.canPopSafely
            ? IconButton(
                tooltip: 'Back',
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: isDark ? Colors.white : AppColors.onBackground,
                  size: 20,
                ),
                onPressed: () => context.popOrGo('/community'),
              )
            : null,
      ),
      body: partner == null
          ? CommunityNotFoundView(handle: handle)
          : _ProfileBody(partner: partner),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.partner});
  final CommunityPartnerProfile partner;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxl * 2,
      ),
      child: Column(
        children: [
          // Partner Avatar & Header
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            child: Text(
              partner.alias.substring(0, 1).toUpperCase(),
              style: AppTypography.h2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Text(
            '@${partner.alias}',
            style: AppTypography.h3.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.xs),

          Text(
            'Level ${partner.level} ${AppBrand.shortName} Partner • ${partner.state}',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Percentile Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(isDark ? 50 : 25),
              borderRadius: AppSpacing.borderRadiusSM,
              border: Border.all(color: AppColors.success.withAlpha(80)),
            ),
            child: Text(
              'Top ${100 - partner.performancePercentile}% Performer',
              style: AppTypography.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Network Statistics Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: AppSpacing.borderRadiusXL,
              border: Border.all(
                color: isDark ? Colors.white10 : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 8),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Network Statistics',
                  style: AppTypography.h5.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: CommunityStatBox(
                        title: 'Team Members',
                        value: '${partner.downlineCount}',
                        icon: HugeIcons.strokeRoundedHierarchy,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: CommunityStatBox(
                        title: 'Network Sales',
                        value: currencyFormatter.format(partner.salesVolumeNaira),
                        icon: HugeIcons.strokeRoundedCoins01,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Join this team card
          CommunityJoinNetworkCard(partner: partner),
        ],
      ),
    );
  }
}
