import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../application/shop_providers.dart';
import '../../domain/shop_entities.dart';

class ReviewFormSheet extends ConsumerStatefulWidget {
  const ReviewFormSheet({super.key, required this.reviewableId, this.existing});
  final int reviewableId;
  final ProductReview? existing;

  @override
  ConsumerState<ReviewFormSheet> createState() => _ReviewFormSheetState();
}

class _ReviewFormSheetState extends ConsumerState<ReviewFormSheet> {
  late double _rating = widget.existing?.rating ?? 5.0;
  late final TextEditingController _commentCtrl =
      TextEditingController(text: widget.existing?.comment ?? '');
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final comment = _commentCtrl.text.trim();
    if (comment.isEmpty) {
      setState(() => _errorMessage = 'Please enter your review comments.');
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(shopRepositoryProvider);
      if (widget.existing != null) {
        await repo.updateReview(
          widget.existing!.id.toString(),
          UpdateReviewInput(rating: _rating, comment: comment),
        );
      } else {
        await repo.createReview(
          CreateReviewInput(
            reviewableType: 'product',
            reviewableId: widget.reviewableId,
            rating: _rating,
            comment: comment,
          ),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      String msg = 'Failed to submit review';
      if (e is DioException) {
        msg = ApiError.fromDio(e).message;
      } else if (e is ApiError) {
        msg = e.message;
      } else {
        msg = e.toString().replaceFirst('Exception: ', '');
      }
      if (mounted) {
        setState(() => _errorMessage = msg);
        AppSnackbar.error(context, msg);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomOffset = MediaQuery.viewInsetsOf(context).bottom +
        MediaQuery.viewPaddingOf(context).bottom +
        AppSpacing.xl;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        bottomOffset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.existing != null ? 'Edit Review' : 'Write a Review',
                style: AppTypography.h5.copyWith(fontWeight: FontWeight.w800),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(20),
                borderRadius: AppSpacing.borderRadiusSM,
                border: Border.all(color: AppColors.error.withAlpha(60)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, size: 18, color: AppColors.error),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Row(
            children: [
              ...List.generate(5, (i) {
                final starValue = (i + 1).toDouble();
                return GestureDetector(
                  onTap: () => setState(() => _rating = starValue),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      starValue <= _rating
                          ? Icons.star_rounded
                          : (starValue - 0.5 <= _rating
                              ? Icons.star_half_rounded
                              : Icons.star_border_rounded),
                      size: 28,
                      color: Colors.amber,
                    ),
                  ),
                );
              }),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _rating.toStringAsFixed(1),
                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              Expanded(
                child: Slider(
                  value: _rating,
                  min: 1.0,
                  max: 5.0,
                  divisions: 8,
                  onChanged: (v) => setState(() => _rating = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _commentCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your experience with this product...',
              filled: true,
              fillColor: cs.surfaceContainerHighest.withAlpha(90),
              border: const OutlineInputBorder(
                borderRadius: AppSpacing.borderRadiusMD,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              child: Text(
                _submitting
                    ? 'Submitting...'
                    : (widget.existing != null ? 'Update Review' : 'Submit Review'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

