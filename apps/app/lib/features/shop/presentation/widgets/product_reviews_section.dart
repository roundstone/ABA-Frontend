import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/application/auth_providers.dart';
import '../../application/shop_providers.dart';
import '../../domain/shop_entities.dart';

/// Displays paginated product 
///  (`GET /api/v1/reviews`) with smooth loading,
/// "Load more" pagination, and allows users to submit (`POST`), edit (`PATCH`), or delete (`DELETE`).
class ProductReviewsSection extends ConsumerWidget {
  const ProductReviewsSection({super.key, required this.productId});
  final String productId;

  int? get _numericProductId =>
      int.tryParse(productId) ?? int.tryParse(productId.replaceAll(RegExp(r'[^0-9]'), ''));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pid = _numericProductId;
    final paginated = ref.watch(paginatedReviewsNotifierProvider(pid));
    final currentUser = ref.watch(currentUserProvider);
    final cs = Theme.of(context).colorScheme;
    final accent = Theme.of(context).brightness == Brightness.dark ? AppColors.secondary : cs.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('Customer Reviews', style: AppTypography.h6.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '(${paginated.totalCount})',
                  style: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => _openReviewSheet(context, ref, pid ?? 1),
              icon: HugeIcon(icon: HugeIcons.strokeRoundedEdit02, size: 16, color: accent),
              label: Text('Write a review', style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (paginated.isInitialLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else if (paginated.error != null && paginated.items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text('Unable to load reviews right now.', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
          )
        else if (paginated.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(
              child: Text('No reviews yet. Be the first to review this product!',
                  style: AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant)),
            ),
          )
        else ...[
          Column(
            children: paginated.items.map((review) {
              final isOwner = currentUser != null &&
                  ((review.userId != null && review.userId.toString() == currentUser.id) ||
                      (review.authorEmail != null && review.authorEmail == currentUser.email));
              return _ReviewTile(
                review: review,
                canManage: isOwner,
                onEdit: () => _openReviewSheet(context, ref, pid ?? review.reviewableId, existing: review),
                onDelete: () => _confirmDelete(context, ref, review),
              );
            }).toList(),
          ),
          if (paginated.hasMore)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Center(
                child: TextButton.icon(
                  onPressed: paginated.isLoadingMore
                      ? null
                      : () => ref.read(paginatedReviewsNotifierProvider(pid).notifier).loadMore(),
                  icon: paginated.isLoadingMore
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator.adaptive(strokeWidth: 2))
                      : HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, size: 16, color: accent),
                  label: Text(paginated.isLoadingMore ? 'Loading more...' : 'Load more reviews',
                      style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Future<void> _openReviewSheet(BuildContext context, WidgetRef ref, int reviewableId, {ProductReview? existing}) async {
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _ReviewFormSheet(reviewableId: reviewableId, existing: existing),
    );
    if (submitted == true) {
      ref.read(paginatedReviewsNotifierProvider(_numericProductId).notifier).fetchFirstPage();
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, ProductReview review) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Are you sure you want to delete your review?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(shopRepositoryProvider).deleteReview(review.id.toString());
        ref.read(paginatedReviewsNotifierProvider(_numericProductId).notifier).fetchFirstPage();
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review deleted')));
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete review: $e')));
      }
    }
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review, required this.canManage, required this.onEdit, required this.onDelete});
  final ProductReview review;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final d = review.createdAt;
    final dateStr = d != null ? '${d.day}/${d.month}/${d.year}' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: cs.surface, borderRadius: AppSpacing.borderRadiusMD, border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: cs.primary.withAlpha(25),
                child: Text(review.authorName.isNotEmpty ? review.authorName[0].toUpperCase() : 'U',
                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: cs.primary)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.authorName, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                            i + 1 <= review.rating ? Icons.star_rounded : (i + 0.5 <= review.rating ? Icons.star_half_rounded : Icons.star_border_rounded),
                            size: 15, color: Colors.amber)),
                        const SizedBox(width: 6),
                        Text(review.rating.toStringAsFixed(1), style: AppTypography.label.copyWith(fontWeight: FontWeight.w600)),
                        if (dateStr.isNotEmpty) Text(' • $dateStr', style: AppTypography.label.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),
              if (canManage) ...[
                IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: onEdit, visualDensity: VisualDensity.compact),
                IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error), onPressed: onDelete, visualDensity: VisualDensity.compact),
              ],
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(review.comment, style: AppTypography.bodySmall.copyWith(color: cs.onSurface)),
          ],
        ],
      ),
    );
  }
}

class _ReviewFormSheet extends ConsumerStatefulWidget {
  const _ReviewFormSheet({required this.reviewableId, this.existing});
  final int reviewableId;
  final ProductReview? existing;

  @override
  ConsumerState<_ReviewFormSheet> createState() => _ReviewFormSheetState();
}

class _ReviewFormSheetState extends ConsumerState<_ReviewFormSheet> {
  late double _rating = widget.existing?.rating ?? 5.0;
  late final TextEditingController _commentCtrl = TextEditingController(text: widget.existing?.comment ?? '');
  bool _submitting = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final comment = _commentCtrl.text.trim();
    if (comment.isEmpty) return;
    setState(() => _submitting = true);
    try {
      final repo = ref.read(shopRepositoryProvider);
      if (widget.existing != null) {
        await repo.updateReview(widget.existing!.id.toString(), UpdateReviewInput(rating: _rating, comment: comment));
      } else {
        await repo.createReview(CreateReviewInput(reviewableType: 'product', reviewableId: widget.reviewableId, rating: _rating, comment: comment));
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit review: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomOffset = MediaQuery.viewInsetsOf(context).bottom + MediaQuery.viewPaddingOf(context).bottom + AppSpacing.xl;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, bottomOffset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4, margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(color: cs.onSurfaceVariant.withAlpha(60), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.existing != null ? 'Edit Review' : 'Write a Review', style: AppTypography.h5.copyWith(fontWeight: FontWeight.w800)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 20), visualDensity: VisualDensity.compact),
            ],
          ),
          Row(
            children: [
              ...List.generate(5, (i) {
                final starValue = (i + 1).toDouble();
                return GestureDetector(
                  onTap: () => setState(() => _rating = starValue),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      starValue <= _rating ? Icons.star_rounded : (starValue - 0.5 <= _rating ? Icons.star_half_rounded : Icons.star_border_rounded),
                      size: 28, color: Colors.amber,
                    ),
                  ),
                );
              }),
              const SizedBox(width: AppSpacing.xs),
              Text(_rating.toStringAsFixed(1), style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
              Expanded(child: Slider(value: _rating, min: 1.0, max: 5.0, divisions: 8, onChanged: (v) => setState(() => _rating = v))),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _commentCtrl, maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your experience with this product...', filled: true,
              fillColor: cs.surfaceContainerHighest.withAlpha(90),
              border: const OutlineInputBorder(borderRadius: AppSpacing.borderRadiusMD, borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity, height: 48,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              child: Text(_submitting ? 'Submitting...' : (widget.existing != null ? 'Update Review' : 'Submit Review')),
            ),
          ),
        ],
      ),
    );
  }
}
