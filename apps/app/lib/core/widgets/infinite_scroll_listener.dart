import 'dart:async';
import 'package:flutter/material.dart';

/// A reusable widget that listens to scroll notifications and smoothly and
/// silently triggers [onLoadMore] before the user reaches the bottom.
class InfiniteScrollListener extends StatefulWidget {
  const InfiniteScrollListener({
    super.key,
    required this.child,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.prefetchDistance = 250.0,
    this.scrollDirection = Axis.vertical,
  }) : assert(prefetchDistance >= 0, 'prefetchDistance must be non-negative');

  /// The scrollable child widget (e.g. ListView, CustomScrollView, GridView).
  final Widget child;

  /// Callback invoked when scroll position reaches the prefetch threshold.
  final FutureOr<void> Function() onLoadMore;

  /// Whether additional pages exist.
  final bool hasMore;

  /// Whether the initial data load or a full refresh is currently running.
  final bool isLoading;

  /// Whether a "load more" fetch is currently in progress.
  final bool isLoadingMore;

  /// Distance in logical pixels from the end of the scrollable extent at
  /// which [onLoadMore] will fire. Default is 250.0 pixels.
  final double prefetchDistance;

  /// Direction of the scrollable (default: [Axis.vertical]).
  final Axis scrollDirection;

  @override
  State<InfiniteScrollListener> createState() => _InfiniteScrollListenerState();
}

class _InfiniteScrollListenerState extends State<InfiniteScrollListener> {
  bool _isExecuting = false;

  @override
  void didUpdateWidget(covariant InfiniteScrollListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoadingMore && !widget.isLoadingMore) {
      _isExecuting = false;
    }
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification.metrics.axis != widget.scrollDirection) return false;

    if (!widget.hasMore || widget.isLoading || widget.isLoadingMore || _isExecuting) {
      return false;
    }

    final metrics = notification.metrics;
    if (metrics.maxScrollExtent <= 0) return false;

    final extentAfter = metrics.extentAfter;
    if (extentAfter <= widget.prefetchDistance) {
      if (notification is ScrollUpdateNotification) {
        if ((notification.scrollDelta ?? 0) >= 0) {
          _trigger();
        }
      } else if (notification is OverscrollNotification) {
        if (notification.overscroll > 0) {
          _trigger();
        }
      }
    }
    return false;
  }

  void _trigger() {
    if (_isExecuting || !widget.hasMore || widget.isLoading || widget.isLoadingMore) {
      return;
    }
    _isExecuting = true;
    try {
      final res = widget.onLoadMore();
      if (res is Future) {
        res.whenComplete(() {
          if (mounted) {
            setState(() => _isExecuting = false);
          }
        });
      } else {
        _isExecuting = false;
      }
    } catch (_) {
      _isExecuting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: widget.child,
    );
  }
}
