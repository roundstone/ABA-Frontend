import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/checkout_entities.dart';

class CheckoutReferralSection extends StatelessWidget {
  const CheckoutReferralSection({
    super.key,
    required this.appliedReferral,
    required this.searchQuery,
    required this.searchResults,
    required this.isSearching,
    required this.onQueryChanged,
    required this.onApplyCandidate,
    required this.onRemove,
  });

  final ReferralCandidate? appliedReferral;
  final String searchQuery;
  final List<ReferralCandidate> searchResults;
  final bool isSearching;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<ReferralCandidate> onApplyCandidate;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedUserGroup,
                color: isDark ? AppColors.secondary : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Referred by someone?',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (appliedReferral != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(20),
                borderRadius: AppSpacing.borderRadiusMD,
                border: Border.all(
                  color: AppColors.success.withAlpha(80),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(appliedReferral!.imageUrl),
                    backgroundColor: AppColors.primary.withAlpha(30),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                              color: AppColors.success,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Referral applied',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Supporting ${appliedReferral!.name} (${appliedReferral!.moniker})',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: onRemove,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ),
          ] else ...[
            AppTextField(
              hintText: 'Enter name or code (e.g. Chisom, Aba, REF-CN2026)',
              prefixIcon: const Icon(Icons.search, size: 18),
              onChanged: onQueryChanged,
            ),
            if (isSearching) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ] else if (searchResults.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252525) : Colors.white,
                  borderRadius: AppSpacing.borderRadiusMD,
                  border: Border.all(
                    color: isDark ? Colors.white12 : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: isDark ? Colors.white10 : AppColors.border,
                  ),
                  itemBuilder: (context, index) {
                    final c = searchResults[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(c.imageUrl),
                      ),
                      title: Text(
                        c.name,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${c.moniker} • ${c.code}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      onTap: () => onApplyCandidate(c),
                    );
                  },
                ),
              ),
            ] else if (searchQuery.trim().length >= 2) ...[
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'No marketers found matching "$searchQuery"',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
