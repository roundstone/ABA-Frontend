import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension on [BuildContext] providing fail-safe navigation methods.
///
/// Unlike GoRouter's direct [canPop] or [pop], these methods never throw an
/// assertion exception when GoRouter is not present in the widget tree (e.g.,
/// in isolated unit/widget tests using standard [MaterialApp]).
extension SafeNavigation on BuildContext {
  /// Returns `true` if there is a route in the navigation stack that can be popped.
  ///
  /// Checks the local [Navigator] first, then falls back safely to [GoRouter].
  bool get canPopSafely {
    final nav = Navigator.maybeOf(this);
    if (nav != null && nav.canPop()) {
      return true;
    }
    try {
      return canPop();
    } catch (_) {
      return false;
    }
  }

  /// Pops the current route if possible; otherwise navigates to [fallbackRoute].
  void popOrGo(String fallbackRoute) {
    if (canPopSafely) {
      final nav = Navigator.maybeOf(this);
      if (nav != null && nav.canPop()) {
        nav.pop();
        return;
      }
      try {
        pop();
        return;
      } catch (_) {}
    }
    try {
      go(fallbackRoute);
    } catch (_) {}
  }
}
