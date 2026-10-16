import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/merchant_dashboard_entities.dart';

class MerchantSalesChart extends StatefulWidget {
  const MerchantSalesChart({
    super.key,
    required this.trendPoints,
    required this.growthPercentage,
  });

  final List<SalesTrendPoint> trendPoints;
  final double growthPercentage;

  @override
  State<MerchantSalesChart> createState() => _MerchantSalesChartState();
}

class _MerchantSalesChartState extends State<MerchantSalesChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE2E8F0);
    final activeBarColor = isDark ? AppColors.secondary : AppColors.primary;

    final maxAmount = widget.trendPoints.fold<double>(
      1.0,
      (maxVal, pt) => max(maxVal, pt.amount),
    );

    final totalWeekSales = widget.trendPoints.fold<double>(
      0.0,
      (sum, pt) => sum + pt.amount,
    );

    final selectedPoint = _selectedIndex != null &&
            _selectedIndex! < widget.trendPoints.length
        ? widget.trendPoints[_selectedIndex!]
        : null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Sales Performance',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      selectedPoint != null
                          ? '${selectedPoint.day}: ${formatNaira(selectedPoint.amount)}'
                          : 'Week Total: ${formatNaira(totalWeekSales)}',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.secondary : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withAlpha(isDark ? 40 : 25),
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
                child: Text(
                  '+${widget.growthPercentage}% vs last week',
                  style: AppTypography.caption.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.trendPoints.length, (index) {
                final pt = widget.trendPoints[index];
                final heightRatio = (pt.amount / maxAmount).clamp(0.12, 1.0);
                final isSelected = _selectedIndex == index;
                final isPeak = pt.amount == maxAmount;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = _selectedIndex == index ? null : index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isSelected || isPeak)
                            Text(
                              '${(pt.amount / 1000).toStringAsFixed(0)}k',
                              style: AppTypography.caption.copyWith(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? activeBarColor
                                    : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                              ),
                            )
                          else
                            const SizedBox(height: 12),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 75 * heightRatio,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? activeBarColor
                                  : isPeak
                                      ? activeBarColor.withAlpha(isDark ? 190 : 150)
                                      : (isDark
                                          ? const Color(0xFF333333)
                                          : const Color(0xFFCBD5E1)),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            pt.day,
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? activeBarColor
                                  : (isDark ? Colors.white60 : const Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
