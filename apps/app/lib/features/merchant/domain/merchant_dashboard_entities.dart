// Domain entities for Merchant Dashboard metrics & insights.

class SalesTrendPoint {
  const SalesTrendPoint({
    required this.day,
    required this.amount,
  });

  final String day;
  final double amount;
}

class MerchantDashboardMetrics {
  const MerchantDashboardMetrics({
    required this.todaySales,
    required this.todayOrdersCount,
    required this.totalRevenue,
    required this.lowStockCount,
    required this.activeProductsCount,
    required this.pendingOrdersCount,
    required this.commissionEarned,
    required this.salesTrend,
    required this.salesGrowthPercentage,
  });

  final double todaySales;
  final int todayOrdersCount;
  final double totalRevenue;
  final int lowStockCount;
  final int activeProductsCount;
  final int pendingOrdersCount;
  final double commissionEarned;
  final List<SalesTrendPoint> salesTrend;
  final double salesGrowthPercentage;
}
