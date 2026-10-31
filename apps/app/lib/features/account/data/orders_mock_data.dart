final mockOrders = [
  {
    "id": "1811",
    "order_number": "ORD-1793458691802-863YFRV2",
    "createdAt": "2026-10-31T14:58:11.849Z",
    "status": "Pending",
    "payment_state": "unpaid",
    "total_amount": "25300.00",
    "paymentMethod": "card_or_bank",
    "deliveryAddress": {
      "name": "Jane Doe",
      "street": "nexus road",
      "city": "Aba",
      "state": "Abia",
      "zip": "450001",
      "phone": "+234 801 234 5678"
    },
    "items": [
      {
        "id": "306",
        "product_variant_id": 6,
        "quantity": 1,
        "unit_price": "25300.00",
        "productVariant": {
          "id": 6,
          "name": "Demo Product 3 - Black",
          "price": "25300.00",
          "product": {
            "id": 4,
            "name": "Demo Product 3",
            "images": [
              {
                "url": "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800&auto=format&fit=crop&q=80"
              }
            ]
          }
        }
      }
    ]
  },
  {
    "id": "1810",
    "order_number": "ORD-1793458691802-772ABC11",
    "createdAt": "2026-10-30T10:42:00Z",
    "status": "Processing",
    "payment_state": "paid",
    "total_amount": "46700.00",
    "paymentMethod": "wallet",
    "deliveryAddress": {
      "name": "Jane Doe",
      "street": "123 Market Street, Victoria Island",
      "city": "Lagos",
      "state": "Lagos",
      "zip": "101241",
      "phone": "+234 801 234 5678"
    },
    "items": [
      {
        "id": "item-1",
        "productId": "prod-1",
        "productName": "Apple Watch Series 9 GPS 45mm",
        "unit_price": "46700.00",
        "quantity": 1
      }
    ]
  },
  {
    "id": "1809",
    "order_number": "ORD-2026-B9C3D",
    "createdAt": "2026-09-28T14:15:00Z",
    "status": "Shipped",
    "payment_state": "paid",
    "total_amount": "12500.00",
    "paymentMethod": "card",
    "deliveryAddress": {
      "name": "Jane Doe",
      "street": "123 Market Street, Victoria Island",
      "city": "Lagos",
      "state": "Lagos",
      "zip": "101241",
      "phone": "+234 801 234 5678"
    },
    "items": [
      {
        "id": "item-2",
        "productId": "prod-2",
        "productName": "Samsung Galaxy S24 Ultra",
        "unit_price": "12500.00",
        "quantity": 1
      }
    ]
  }
];

