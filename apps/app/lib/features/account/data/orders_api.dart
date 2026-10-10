import '../domain/customer_order.dart';

final mockOrders = [
  {
    "id": "ORD-2026-X8F9A",
    "date": "2026-10-01T10:42:00Z",
    "status": "Processing",
    "total": 4670000,
    "paymentMethod": "wallet",
    "shippingAddress": {
      "fullName": "Jane Doe",
      "street": "123 Market Street, Victoria Island",
      "city": "Lagos",
      "zipCode": "101241",
      "phone": "+234 801 234 5678"
    },
    "items": [
      {
        "id": "item-1",
        "productId": "prod-1",
        "productName": "Apple Watch Series 9 GPS 45mm",
        "price": 4520000,
        "quantity": 1
      }
    ]
  },
  {
    "id": "ORD-2026-B9C3D",
    "date": "2026-09-28T14:15:00Z",
    "status": "Shipped",
    "total": 1250000,
    "paymentMethod": "card",
    "shippingAddress": {
      "fullName": "Jane Doe",
      "street": "123 Market Street, Victoria Island",
      "city": "Lagos",
      "zipCode": "101241",
      "phone": "+234 801 234 5678"
    },
    "items": [
      {
        "id": "item-2",
        "productId": "prod-2",
        "productName": "Samsung Galaxy S24 Ultra",
        "price": 1250000,
        "quantity": 1
      }
    ]
  },
  {
    "id": "ORD-2026-E4F2A",
    "date": "2026-09-15T09:30:00Z",
    "status": "Delivered",
    "total": 850000,
    "paymentMethod": "bank_transfer",
    "shippingAddress": {
      "fullName": "Jane Doe",
      "street": "123 Market Street, Victoria Island",
      "city": "Lagos",
      "zipCode": "101241",
      "phone": "+234 801 234 5678"
    },
    "items": [
      {
        "id": "item-3",
        "productId": "prod-3",
        "productName": "Sony WH-1000XM5 Headphones",
        "price": 4250000,
        "quantity": 2
      }
    ]
  }
];

class OrdersApi {
  Future<List<CustomerOrder>> getOrders({OrderStatus? status, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var orders = mockOrders.map((json) => CustomerOrder.fromJson(json)).toList();
    if (status != null) {
      orders = orders.where((o) => o.status == status).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final lowerQuery = query.trim().toLowerCase();
      orders = orders.where((o) {
        final matchesId = o.id.toLowerCase().contains(lowerQuery);
        final matchesItems = o.items.any((item) => item.productName.toLowerCase().contains(lowerQuery));
        return matchesId || matchesItems;
      }).toList();
    }
    return orders;
  }

  Future<CustomerOrder> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final orderJson = mockOrders.firstWhere(
      (json) => json['id'] == id,
      orElse: () => throw Exception('Order not found'),
    );
    return CustomerOrder.fromJson(orderJson);
  }
}
