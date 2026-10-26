import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'infinite_scroll_listener.dart';

/// Standard, reusable paginated list view with smooth and silent prefetching.
class PaginatedListView<T> extends StatelessWidget {
  const PaginatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    this.separatorBuilder,
    this.onRefresh,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.prefetchDistance = 250.0,
    this.showBottomLoader = true,
    this.emptyWidget,
    this.loadingWidget,
    this.header,
    this.footer,
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.controller,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Future<void> Function()? onRefresh;
  final FutureOr<void> Function() onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final double prefetchDistance;
  final bool showBottomLoader;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? header;
  final Widget? footer;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return loadingWidget ??
          const Center(child: CircularProgressIndicator.adaptive());
    }

    if (items.isEmpty && !isLoading) {
      final empty = emptyWidget ?? const SizedBox.shrink();
      if (onRefresh != null) {
        return RefreshIndicator(
          onRefresh: onRefresh!,
          child: ListView(
            physics: physics,
            controller: controller,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(child: empty),
              ),
            ],
          ),
        );
      }
      return Center(child: empty);
    }

    final hasHeader = header != null;
    final hasFooter = footer != null;
    final hasLoader = isLoadingMore && showBottomLoader;

    int totalCount = items.length;
    if (hasHeader) totalCount += 1;
    if (hasFooter) totalCount += 1;
    if (hasLoader) totalCount += 1;

    Widget listView;

    if (separatorBuilder != null) {
      listView = ListView.separated(
        controller: controller,
        physics: physics,
        padding: padding,
        itemCount: totalCount,
        separatorBuilder: (ctx, i) {
          if (hasHeader && i == 0) return const SizedBox.shrink();
          final dataIndex = hasHeader ? i - 1 : i;
          if (dataIndex >= 0 && dataIndex < items.length - 1) {
            return separatorBuilder!(ctx, dataIndex);
          }
          return const SizedBox.shrink();
        },
        itemBuilder: (ctx, i) => _buildRow(ctx, i, hasHeader, hasFooter, hasLoader),
      );
    } else {
      listView = ListView.builder(
        controller: controller,
        physics: physics,
        padding: padding,
        itemCount: totalCount,
        itemBuilder: (ctx, i) => _buildRow(ctx, i, hasHeader, hasFooter, hasLoader),
      );
    }

    if (onRefresh != null) {
      listView = RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return InfiniteScrollListener(
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      isLoading: isLoading,
      isLoadingMore: isLoadingMore,
      prefetchDistance: prefetchDistance,
      child: listView,
    );
  }

  Widget _buildRow(
    BuildContext context,
    int index,
    bool hasHeader,
    bool hasFooter,
    bool hasLoader,
  ) {
    if (hasHeader && index == 0) {
      return header!;
    }

    final dataIndex = hasHeader ? index - 1 : index;

    if (dataIndex < items.length) {
      return itemBuilder(context, items[dataIndex], dataIndex);
    }

    final extraIndex = dataIndex - items.length;
    if (hasFooter && extraIndex == 0) {
      return footer!;
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ),
    );
  }
}
