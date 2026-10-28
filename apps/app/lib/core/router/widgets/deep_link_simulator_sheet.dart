import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../deep_link_service.dart';

/// Interactive developer sheet to simulate incoming deep links.
class DeepLinkSimulatorSheet extends StatefulWidget {
  const DeepLinkSimulatorSheet({super.key});

  @override
  State<DeepLinkSimulatorSheet> createState() => _DeepLinkSimulatorSheetState();
}

class _DeepLinkSimulatorSheetState extends State<DeepLinkSimulatorSheet> {
  final _controller = TextEditingController(
    text: 'https://app.abaerp.com/reset-password?token=0001',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyToken(String token) {
    setState(() {
      _controller.text = 'https://app.abaerp.com/reset-password?token=$token';
    });
  }

  void _submit() {
    final link = _controller.text.trim();
    if (link.isEmpty) return;
    Navigator.of(context).pop();
    DeepLinkService.instance.handleDeepLink(context, link);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: AppSpacing.borderRadiusSM,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.link_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Deep Link Simulator',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Test App Links, custom schemes, and password reset tokens in development.',
            style: AppTypography.caption.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'RESET PASSWORD TOKENS',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: DeepLinkService.sampleResetTokens.map((token) {
              final isSelected = _controller.text.contains('token=$token');
              return FilterChip(
                label: Text('Token $token'),
                selected: isSelected,
                selectedColor: AppColors.primary.withAlpha(40),
                onSelected: (_) => _applyToken(token),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'OTHER PRESETS',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              ActionChip(
                label: const Text('Storefront Shop'),
                onPressed: () {
                  setState(() => _controller.text = 'https://app.abaerp.com/shop');
                },
              ),
              ActionChip(
                label: const Text('Merchants Directory'),
                onPressed: () {
                  setState(() => _controller.text = 'https://app.abaerp.com/merchants');
                },
              ),
              ActionChip(
                label: const Text('Custom Scheme (abaerp://)'),
                onPressed: () {
                  setState(() => _controller.text = 'abaerp://reset-password?token=0001');
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Deep Link URL',
              hintText: 'https://app.abaerp.com/reset-password?token=0001',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () => setState(() => _controller.clear()),
              ),
            ),
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Simulate Open Deep Link',
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

/// Helper function to display the Deep Link Simulator modal sheet.
void showDeepLinkSimulatorSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
    ),
    builder: (_) => const DeepLinkSimulatorSheet(),
  );
}
