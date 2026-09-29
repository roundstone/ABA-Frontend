import 'customer_entities.dart';

/// Repository contract — the application layer talks only to this interface.
/// The data layer provides the implementation (mock today, real API tomorrow).
abstract class CustomerRepository {
  /// Fetch the full dashboard summary in a single call.
  /// On real API this maps to: GET /api/customers/me/dashboard
  Future<DashboardSummary> fetchDashboardSummary();

  /// Fetch all orders for the authenticated customer.
  /// On real API: GET /api/customers/me/orders
  Future<List<CustomerOrder>> fetchOrders();

  /// Fetch commission ledger entries for the authenticated customer.
  /// On real API: GET /api/customers/me/commissions
  Future<List<CommissionEntry>> fetchCommissions();
}
