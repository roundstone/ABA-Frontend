final mockOrders = [
  {
    "id": 1811,
    "customer_id": 4,
    "delivery_address_id": 106,
    "delivery_method": "standard",
    "order_number": "ORD-1793458691802-863YFRV2",
    "total_amount": "25300.00",
    "status": "pending",
    "cancellation_reason": null,
    "deliveryAddress": {
      "id": 106,
      "name": "Office/Work",
      "street": "nexus road",
      "city": "Aba",
      "state": "Abia",
      "zip": "450001",
      "createdAt": "2026-10-31T06:16:30.601Z",
    },
    "payments": [
      {
        "id": 1813,
        "order_id": 1811,
        "reference": "PSK-54fc7825b5f546a2b407860ea7d627c7",
        "amount": "25300.00",
        "currency": "NGN",
        "status": "pending",
        "payment_method": "card_or_bank",
        "createdAt": "2026-10-31T14:58:12.398Z"
      }
    ],
    "items": [
      {
        "id": 310,
        "order_id": 1811,
        "quantity": 1,
        "unit_price": "12700.00",
        "total_price": "12700.00",
        "status": "pending",
        "productVariant": {
          "id": 4,
          "name": "Demo Product 2 - Black",
          "sku": "DEMO-SKU-002-B",
          "attributes": {"color": "Black", "size": "42"},
          "product": {
            "id": 3,
            "name": "Demo Product 2",
            "images": [
              {"url": "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800&auto=format&fit=crop&q=80"}
            ]
          }
        }
      },
      {
        "id": 309,
        "order_id": 1811,
        "quantity": 1,
        "unit_price": "12600.00",
        "total_price": "12600.00",
        "status": "pending",
        "productVariant": {
          "id": 2,
          "name": "Demo Product 1 - Black",
          "sku": "DEMO-SKU-001-B",
          "attributes": {"color": "Black"},
          "product": {
            "id": 2,
            "name": "Demo Product 1",
            "images": [
              {"url": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80"}
            ]
          }
        }
      }
    ],
    "createdAt": "2026-10-31T14:58:11.789Z",
    "updatedAt": "2026-10-31T14:58:11.789Z"
  },
  {
    "id": 1810,
    "customer_id": 4,
    "delivery_address_id": 106,
    "delivery_method": "standard",
    "order_number": "ORD-1793457713652-NS4UADG1",
    "total_amount": "25300.00",
    "status": "shipped_or_ready_for_pickup",
    "cancellation_reason": null,
    "deliveryAddress": {
      "id": 106,
      "name": "Office/Work",
      "street": "nexus road",
      "city": "Aba",
      "state": "Abia",
      "zip": "450001",
      "phone": "+234 801 234 5678"
    },
    "payments": [
      {
        "id": 1812,
        "reference": "PSK-4fdb17236bea48cdbffe28dee3ef5b95",
        "amount": "25300.00",
        "currency": "NGN",
        "status": "success",
        "payment_method": "card_or_bank",
        "paid_at": "2026-10-31T14:42:10.000Z",
        "createdAt": "2026-10-31T14:41:54.760Z"
      }
    ],
    "items": [
      {
        "id": 308,
        "productName": "Demo Product 2 - Black",
        "unit_price": "25300.00",
        "quantity": 1,
        "status": "shipped_or_ready_for_pickup",
        "imageUrl": "https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800&auto=format&fit=crop&q=80"
      }
    ],
    "createdAt": "2026-10-31T14:41:53.645Z",
    "updatedAt": "2026-10-31T14:42:10.000Z"
  },
  {
    "id": 1807,
    "customer_id": 4,
    "delivery_address_id": 106,
    "delivery_method": "standard",
    "order_number": "ORD-1793449837461-MFUYZXMU",
    "total_amount": "12800.00",
    "status": "pending",
    "cancellation_reason": null,
    "deliveryAddress": {
      "id": 106,
      "name": "Office/Work",
      "street": "nexus road",
      "city": "Aba",
      "state": "Abia",
      "zip": "450001",
      "phone": "+234 801 234 5678"
    },
    "payments": [
      {
        "id": 1807,
        "reference": "PSK-0c9f0be106c84ab59f23b66eb03690d4",
        "amount": "12800.00",
        "currency": "NGN",
        "status": "failed",
        "failure_reason": "Paystack is not configured",
        "payment_method": "card_or_bank",
        "createdAt": "2026-10-31T12:31:48.638Z"
      }
    ],
    "items": [
      {
        "id": 302,
        "productName": "Demo Product 3 - Black",
        "unit_price": "12800.00",
        "quantity": 1,
        "status": "pending",
        "imageUrl": "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80"
      }
    ],
    "createdAt": "2026-10-31T12:30:37.447Z",
    "updatedAt": "2026-10-31T12:31:48.646Z"
  },
  {
    "id": 1806,
    "customer_id": 4,
    "delivery_address_id": 106,
    "delivery_method": "standard",
    "order_number": "ORD-1793449837461-CANCLD01",
    "total_amount": "15000.00",
    "status": "cancelled",
    "cancellation_reason": "Customer requested cancellation before dispatch",
    "deliveryAddress": {
      "id": 106,
      "name": "Home",
      "street": "12 Commercial Road",
      "city": "Aba",
      "state": "Abia",
      "zip": "450001",
      "phone": "+234 801 234 5678"
    },
    "payments": [],
    "items": [
      {
        "id": 301,
        "productName": "Aba Leather Loafers",
        "unit_price": "15000.00",
        "quantity": 1,
        "status": "cancelled"
      }
    ],
    "createdAt": "2026-10-29T10:00:00.000Z",
    "updatedAt": "2026-10-29T10:30:00.000Z"
  }
];
