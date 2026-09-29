import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Debounced search bar for the shop.
class ShopSearchBar extends StatefulWidget {
  const ShopSearchBar({
    super.key,
    required this.onChanged,
    this.initialValue = '',
  });

  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  State<ShopSearchBar> createState() => _ShopSearchBarState();
}

class _ShopSearchBarState extends State<ShopSearchBar> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF4F4F6),
        borderRadius: AppSpacing.avatarRadius,
      ),
      child: TextField(
        controller: _ctrl,
        onChanged: widget.onChanged,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search products, brands…',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: cs.onSurface.withAlpha(100),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: AppSpacing.iconSizeSM,
              color: cs.onSurface.withAlpha(120),
            ),
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: _ctrl,
            builder: (_, value, __) => value.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _ctrl.clear();
                      widget.onChanged('');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        size: AppSpacing.iconSizeSM,
                        color: AppColors.grey,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}
