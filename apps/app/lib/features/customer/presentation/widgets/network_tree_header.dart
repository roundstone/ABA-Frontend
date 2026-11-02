import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/referrals_network_providers.dart';

class NetworkTreeHeader extends ConsumerWidget {
  final bool isListView;
  final VoidCallback onToggleView;

  const NetworkTreeHeader({
    super.key,
    required this.isListView,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mode = ref.watch(referralNetworkViewModeProvider);
    final depth = ref.watch(referralNetworkDepthProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(80),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLG),
        ),
        border: Border(
          bottom: BorderSide(color: isDark ? Colors.white12 : AppColors.border),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModeTab(
                  ref,
                  'Downline Network',
                  ReferralNetworkViewMode.downline,
                  mode,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeTab(
                  ref,
                  'Upline Mentors',
                  ReferralNetworkViewMode.upline,
                  mode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
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
              const Spacer(),
              IconButton.outlined(
                tooltip: isListView
                    ? 'Switch to Tree View'
                    : 'Switch to List View',
                icon: Icon(
                  isListView ? Icons.account_tree_outlined : Icons.list,
                  size: 18,
                ),
                onPressed: onToggleView,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(
    WidgetRef ref,
    String title,
    ReferralNetworkViewMode target,
    ReferralNetworkViewMode current,
  ) {
    final isSelected = current == target;
    return InkWell(
      onTap: () {
        ref.read(referralNetworkViewModeProvider.notifier).state = target;
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
