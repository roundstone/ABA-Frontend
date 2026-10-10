import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/checkout_mock_repository.dart';
import '../domain/checkout_repository.dart';
import 'checkout_notifier.dart';
import 'checkout_state.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutMockRepository();
});

final checkoutProvider =
    StateNotifierProvider.autoDispose<CheckoutNotifier, CheckoutState>((ref) {
  final repo = ref.watch(checkoutRepositoryProvider);
  return CheckoutNotifier(repository: repo, ref: ref);
});
