import 'package:intl/intl.dart';
import 'customer_order.dart';

/// Represents a group of orders clustered by year and month.
class OrderDateCluster {
  final String key;
  final String monthLabel;
  final String yearLabel;
  final DateTime date;
  final List<CustomerOrder> orders;
  final int totalAmount;

  const OrderDateCluster({
    required this.key,
    required this.monthLabel,
    required this.yearLabel,
    required this.date,
    required this.orders,
    required this.totalAmount,
  });

  String get fullTitle => '$monthLabel $yearLabel';
}

/// Clusters a list of orders by month, sorted newest month first.
List<OrderDateCluster> clusterOrdersByDate(List<CustomerOrder> orders) {
  if (orders.isEmpty) return const [];

  final Map<String, List<CustomerOrder>> groups = {};
  for (final order in orders) {
    final key = DateFormat('yyyy-MM').format(order.date);
    groups.putIfAbsent(key, () => []).add(order);
  }

  final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

  return sortedKeys.map((key) {
    final list = groups[key]!;
    list.sort((a, b) => b.date.compareTo(a.date));
    final firstDate = list.first.date;
    final monthLabel = DateFormat('MMM').format(firstDate);
    final yearLabel = DateFormat('yyyy').format(firstDate);
    final total = list.fold<int>(0, (sum, o) => sum + o.total);

    return OrderDateCluster(
      key: key,
      monthLabel: monthLabel,
      yearLabel: yearLabel,
      date: firstDate,
      orders: list,
      totalAmount: total,
    );
  }).toList();
}

/// Formats a date with ordinal suffix, e.g. "Nov 1st, 07:53:33".
String formatOrderDateOrdinal(DateTime date) {
  final day = date.day;
  final String suffix;
  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }
  final month = DateFormat('MMM').format(date);
  final time = DateFormat('HH:mm:ss').format(date);
  return '$month $day$suffix, $time';
}

