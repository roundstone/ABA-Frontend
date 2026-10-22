import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';

class ReferralSignupField extends StatefulWidget {
  const ReferralSignupField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<ReferralSignupField> createState() => _ReferralSignupFieldState();
}

class _ReferralSignupFieldState extends State<ReferralSignupField> {
  static const Map<String, ({String name, String username})> _knownReferrers = {
    'BN-EMEK-8821': (name: 'Emeka Nwosu', username: 'emekanwosu'),
    'ABA492': (name: 'Aisha Bello', username: 'aishabello'),
    '492': (name: 'Aisha Bello', username: 'aishabello'),
    'AISHABELLO': (name: 'Aisha Bello', username: 'aishabello'),
    'ABA881': (name: 'Michael Okon', username: 'mokoloko'),
    '881': (name: 'Michael Okon', username: 'mokoloko'),
    'MOKOLOKO': (name: 'Michael Okon', username: 'mokoloko'),
    'CHIMA': (name: 'Chima Obi', username: 'chimaobi'),
    'JANEDOE': (name: 'Jane Doe', username: 'janedoe'),
  };

  ({String name, String username})? _resolved;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_resolveReferrer);
    _resolveReferrer();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_resolveReferrer);
    super.dispose();
  }

  void _resolveReferrer() {
    final raw = widget.controller.text.trim();
    if (raw.isEmpty) {
      if (_resolved != null) setState(() => _resolved = null);
      return;
    }

    final normalized = raw.toUpperCase().replaceAll('@', '').replaceAll(' ', '');
    final match = _knownReferrers[normalized];

    if (match != null) {
      if (_resolved?.username != match.username) {
        setState(() => _resolved = match);
      }
    } else {
      final fallback = (
        name: raw,
        username: raw.toLowerCase().replaceAll('@', ''),
      );
      if (_resolved?.name != fallback.name) {
        setState(() => _resolved = fallback);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: "Referral Code or Referrer's Username (Optional)",
          hintText: 'e.g. BN-EMEK-8821, ABA492, or @username',
          controller: widget.controller,
          prefixIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedUserGroup,
            color: AppColors.primary,
            size: 16,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: AppColors.grey),
                  onPressed: () {
                    widget.controller.clear();
                    setState(() => _resolved = null);
                  },
                )
              : null,
        ),
        if (_resolved != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2B22) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark ? const Color(0xFF2E4E36) : const Color(0xFFC8E6C9),
              ),
            ),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                  color: AppColors.success,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Referred by ${_resolved!.name} (@${_resolved!.username})',
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          'Entering your referrer connects you to their community network and unlocks bonus reward points.',
          style: AppTypography.caption.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
