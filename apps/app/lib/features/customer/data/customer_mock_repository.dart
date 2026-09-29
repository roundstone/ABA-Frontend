import '../domain/customer_entities.dart';
import '../domain/customer_repository.dart';

/// Mock repository — data matches apps/web/src/services/mock/*.service.ts
/// Swap this for CustomerRemoteRepository once the NestJS API is ready:
///   1. Implement CustomerRemoteRepository(Dio dio) : CustomerRepository
///   2. Change the provider in customer_providers.dart — zero UI changes.
class CustomerMockRepository implements CustomerRepository {
  // ─── static mock data ────────────────────────────────────────────────────

  static const _profile = CustomerProfile(
    id: 'usr_tunde123',
    firstName: 'Tunde',
    lastName: 'Adeyemi',
    email: 'tunde.adeyemi@example.com',
    phone: '+234 801 234 5678',
    referralCode: 'TUNDE-ABA',
  );

  static final _orders = <CustomerOrder>[
    CustomerOrder(
      id: 'ord_12345',
      customerId: 'usr_tunde123',
      items: const [
        OrderItem(
          id: 'i1',
          productId: 'p1',
          productName: 'Premium Backpack',
          price: 89_99,
          quantity: 1,
          imageUrl: null,
        ),
      ],
      subtotal: 89_990,
      tax: 4_500,
      shipping: 10_000,
      total: 104_490,
      status: OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      shippingAddress: '14 Adewale St, Ikeja, Lagos',
      paymentMethod: 'Paystack',
    ),
    CustomerOrder(
      id: 'ord_67890',
      customerId: 'usr_tunde123',
      items: const [
        OrderItem(
          id: 'i2',
          productId: 'p2',
          productName: 'Leather Wallet',
          price: 24_990,
          quantity: 2,
          imageUrl: null,
        ),
      ],
      subtotal: 49_980,
      tax: 2_499,
      shipping: 0,
      total: 52_479,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      shippingAddress: '14 Adewale St, Ikeja, Lagos',
      paymentMethod: 'Bank Transfer',
    ),
    CustomerOrder(
      id: 'ord_11111',
      customerId: 'usr_tunde123',
      items: const [
        OrderItem(
          id: 'i3',
          productId: 'p3',
          productName: 'Wander Pack Backpack',
          price: 18_999,
          quantity: 1,
          imageUrl: null,
        ),
      ],
      subtotal: 18_999,
      tax: 950,
      shipping: 2_000,
      total: 21_949,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      shippingAddress: '14 Adewale St, Ikeja, Lagos',
      paymentMethod: 'Paystack',
    ),
  ];

  static final _commissions = <CommissionEntry>[
    CommissionEntry(
      id: 'com_1',
      orderId: 'ord_123',
      amount: 1_500,
      level: 1,
      status: CommissionStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      purchaserName: 'Ifeoma Obi',
    ),
    CommissionEntry(
      id: 'com_2',
      orderId: 'ord_456',
      amount: 750,
      level: 2,
      status: CommissionStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      purchaserName: 'Bola Ajayi',
    ),
    CommissionEntry(
      id: 'com_3',
      orderId: 'ord_789',
      amount: 300,
      level: 3,
      status: CommissionStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      purchaserName: 'Amaka Eze',
    ),
  ];

  // ─── interface implementation ─────────────────────────────────────────────

  @override
  Future<DashboardSummary> fetchDashboardSummary() async {
    // Simulate realistic network latency
    await Future.delayed(const Duration(milliseconds: 600));

    final totalEarned = _commissions.fold<double>(0, (s, e) => s + e.amount);
    final pending = _commissions
        .where((e) => e.status == CommissionStatus.pending)
        .fold<double>(0, (s, e) => s + e.amount);
    final available = _commissions
        .where((e) => e.status == CommissionStatus.approved)
        .fold<double>(0, (s, e) => s + e.amount);

    return DashboardSummary(
      profile: _profile,
      totalOrderValue: _orders.fold(0, (s, o) => s + o.total),
      totalPoints: 2530,
      totalOrders: _orders.length,
      recentOrders: _orders.take(3).toList(),
      totalEarned: totalEarned,
      pendingCommission: pending,
      availableToWithdraw: available,
    );
  }

  @override
  Future<List<CustomerOrder>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_orders);
  }

  @override
  Future<List<CommissionEntry>> fetchCommissions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_commissions);
  }
}
