import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class CommissionFlowTimelineCard extends StatelessWidget {
  const CommissionFlowTimelineCard({super.key});

  static const _steps = [
    (
      step: '1',
      title: 'Order Paid',
      accounts: 'Source: Sales Order',
      desc: 'Buyer payment captured and order delivered.',
      icon: HugeIcons.strokeRoundedShoppingBag01,
      color: Color(0xFF1E88E5),
    ),
    (
      step: '2',
      title: 'Accrual Posted',
      accounts: 'Dr. 6000 / Cr. 2110',
      desc: 'Commission recorded against operating expense.',
      icon: HugeIcons.strokeRoundedBook02,
      color: Color(0xFFFFA000),
    ),
    (
      step: '3',
      title: '14-Day Safety Hold',
      accounts: 'Cool-off Buffer',
      desc: 'Customer dispute and return safety window.',
      icon: HugeIcons.strokeRoundedClock01,
      color: Color(0xFF8E24AA),
    ),
    (
      step: '4',
      title: 'Wallet Credited',
      accounts: 'Dr. 2110 / Cr. 2100',
      desc: 'Settled to marketer wallet for withdrawal.',
      icon: HugeIcons.strokeRoundedWallet01,
      color: Color(0xFF43A047),
    ),
    (
      step: '5',
      title: 'Bank Payout',
      accounts: 'Dr. 2100 / Cr. 1010',
      desc: 'Liquid transfer to commercial Nigerian bank.',
      icon: HugeIcons.strokeRoundedBank,
      color: Color(0xFF00897B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(isDark ? 50 : 25),
                  shape: BoxShape.circle,
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShieldCheck,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commission Financial Flow',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Double-entry General Ledger journey (GAAP/IFRS)',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _steps.map((st) {
                final isLast = st.step == '5';
                return Row(
                  children: [
                    Container(
                      width: 140,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: st.color.withAlpha(isDark ? 30 : 15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: st.color.withAlpha(isDark ? 90 : 50),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: st.color,
                                child: Text(
                                  st.step,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              HugeIcon(
                                icon: st.icon,
                                color: st.color,
                                size: 14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            st.title,
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black26 : Colors.white70,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              st.accounts,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            st.desc,
                            style: AppTypography.caption.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
