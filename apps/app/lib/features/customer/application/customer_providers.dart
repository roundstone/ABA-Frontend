import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/customer_mock_repository.dart';
import '../domain/customer_entities.dart';
import '../domain/customer_repository.dart';

// ─── Repository provider ──────────────────────────────────────────────────
// Change useValue to CustomerRemoteRepository(ref.read(dioClientProvider))
// when the real API is ready. Zero other changes required.
final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => CustomerMockRepository(),
);

// ─── Dashboard async state ────────────────────────────────────────────────
final dashboardSummaryProvider =
    FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.fetchDashboardSummary();
});

// ─── Orders async state ───────────────────────────────────────────────────
final customerOrdersProvider =
    FutureProvider.autoDispose<List<CustomerOrder>>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.fetchOrders();
});

// ─── Commissions async state ──────────────────────────────────────────────
final customerCommissionsProvider =
    FutureProvider.autoDispose<List<CommissionEntry>>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.fetchCommissions();
});
