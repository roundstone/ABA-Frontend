import '../domain/merchant_dashboard_entities.dart';
import '../domain/merchant_product_entities.dart';
import '../domain/merchant_order_entities.dart';

final List<MerchantProduct> kInitialMerchantProducts = [
  MerchantProduct(
    id: 'prod-101',
    name: 'Handcrafted Oxford Leather Shoes',
    sku: 'ABA-SH-001',
    category: 'Shoes & Footwear',
    price: 32500.0,
    costPrice: 21000.0,
    stock: 14,
    lowStockThreshold: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=400&q=80',
    description:
        'Full grain Italian-style leather handcrafted by master cobblers in Ariaria.',
    status: MerchantProductStatus.active,
    isCommissionable: true,
    soldCount: 42,
    updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  MerchantProduct(
    id: 'prod-102',
    name: 'Classic Men Senator Brogue Shoes',
    sku: 'ABA-SH-002',
    category: 'Shoes & Footwear',
    price: 28000.0,
    costPrice: 18500.0,
    stock: 4, // Low stock
    lowStockThreshold: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=400&q=80',
    description:
        'Comfort cushioned insole with slip-resistant wooden finish heels.',
    status: MerchantProductStatus.active,
    isCommissionable: true,
    soldCount: 31,
    updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  MerchantProduct(
    id: 'prod-103',
    name: 'Genuine Calfskin Leather Belt',
    sku: 'ABA-BL-001',
    category: 'Accessories',
    price: 9500.0,
    costPrice: 5000.0,
    stock: 28,
    lowStockThreshold: 8,
    imageUrl:
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=400&q=80',
    description: 'Double stitched brass buckle belt with custom edge coating.',
    status: MerchantProductStatus.active,
    isCommissionable: true,
    soldCount: 88,
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  MerchantProduct(
    id: 'prod-104',
    name: 'Ariaria Executive Briefcase & Laptop Bag',
    sku: 'ABA-BG-001',
    category: 'Bags & Luggage',
    price: 45000.0,
    costPrice: 28000.0,
    stock: 2, // Low stock
    lowStockThreshold: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=400&q=80',
    description:
        'Water-resistant interior with reinforced handles and brass locks.',
    status: MerchantProductStatus.active,
    isCommissionable: true,
    soldCount: 19,
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  MerchantProduct(
    id: 'prod-105',
    name: 'Aba Traditional Senator Fabric Suit',
    sku: 'ABA-TX-001',
    category: 'Fashion & Textiles',
    price: 36000.0,
    costPrice: 24000.0,
    stock: 0, // Out of stock
    lowStockThreshold: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=400&q=80',
    description: 'High thread count cashmere wool blend with front embroidery.',
    status: MerchantProductStatus.draft,
    isCommissionable: true,
    soldCount: 65,
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  MerchantProduct(
    id: 'prod-106',
    name: 'Ariaria Soft Suede Loafers',
    sku: 'ABA-SH-003',
    category: 'Shoes & Footwear',
    price: 24000.0,
    costPrice: 15000.0,
    stock: 19,
    lowStockThreshold: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1582588678413-dbf45f4823e9?auto=format&fit=crop&w=400&q=80',
    description:
        'Slip-on casual driving shoes with ergonomic orthopedic insoles.',
    status: MerchantProductStatus.active,
    isCommissionable: true,
    soldCount: 54,
    updatedAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
];

final List<MerchantOrder> kInitialMerchantOrders = [
  MerchantOrder(
    id: 'ORD-10482',
    customerName: 'Chidi Okonkwo',
    customerPhone: '+2348039912345',
    channel: OrderChannel.storefront,
    status: MerchantOrderStatus.pending,
    paymentStatus: MerchantPaymentStatus.paid,
    paymentMethod: 'Bank Transfer',
    items: [
      const MerchantOrderItem(
        id: 'item-1',
        productId: 'prod-101',
        productName: 'Handcrafted Oxford Leather Shoes',
        sku: 'ABA-SH-001',
        price: 32500.0,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=400&q=80',
      ),
      const MerchantOrderItem(
        id: 'item-2',
        productId: 'prod-103',
        productName: 'Genuine Calfskin Leather Belt',
        sku: 'ABA-BL-001',
        price: 9500.0,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=400&q=80',
      ),
    ],
    subtotal: 42000.0,
    deliveryFee: 2500.0,
    discount: 0.0,
    total: 44500.0,
    createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
    shippingAddress: '18 Aba-Owerri Road, Umungasi, Aba, Abia State',
    notes: 'Please pack in gift box with extra shoelaces.',
  ),
  MerchantOrder(
    id: 'ORD-10480',
    customerName: 'Walk-in Customer',
    customerPhone: '+2348021110000',
    isWalkIn: true,
    channel: OrderChannel.pos,
    status: MerchantOrderStatus.processing,
    paymentStatus: MerchantPaymentStatus.paid,
    paymentMethod: 'POS Card',
    items: [
      const MerchantOrderItem(
        id: 'item-3',
        productId: 'prod-102',
        productName: 'Classic Men Senator Brogue Shoes',
        sku: 'ABA-SH-002',
        price: 28000.0,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=400&q=80',
      ),
    ],
    subtotal: 28000.0,
    deliveryFee: 0.0,
    discount: 1000.0,
    total: 27000.0,
    createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
    notes: 'Counter 1 register transaction',
  ),
  MerchantOrder(
    id: 'ORD-10478',
    customerName: 'Ngozi Eze',
    customerPhone: '+2348076543210',
    channel: OrderChannel.portal,
    status: MerchantOrderStatus.ready,
    paymentStatus: MerchantPaymentStatus.paid,
    paymentMethod: 'Wallet',
    items: [
      const MerchantOrderItem(
        id: 'item-4',
        productId: 'prod-104',
        productName: 'Ariaria Executive Briefcase & Laptop Bag',
        sku: 'ABA-BG-001',
        price: 45000.0,
        quantity: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=400&q=80',
      ),
    ],
    subtotal: 45000.0,
    deliveryFee: 3000.0,
    discount: 0.0,
    total: 48000.0,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    shippingAddress: '42 Azikiwe Road, City Centre, Aba, Abia State',
    notes: 'Awaiting rider pickup',
  ),
  MerchantOrder(
    id: 'ORD-10465',
    customerName: 'Babatunde Adeleke',
    customerPhone: '+2348021112233',
    channel: OrderChannel.storefront,
    status: MerchantOrderStatus.completed,
    paymentStatus: MerchantPaymentStatus.paid,
    paymentMethod: 'Bank Transfer',
    items: [
      const MerchantOrderItem(
        id: 'item-5',
        productId: 'prod-106',
        productName: 'Ariaria Soft Suede Loafers',
        sku: 'ABA-SH-003',
        price: 24000.0,
        quantity: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1582588678413-dbf45f4823e9?auto=format&fit=crop&w=400&q=80',
      ),
    ],
    subtotal: 48000.0,
    deliveryFee: 4000.0,
    discount: 2000.0,
    total: 50000.0,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    shippingAddress: '12 Otigba Street, Ikeja, Lagos State',
  ),
];

final List<SalesTrendPoint> kMockSalesTrend = [
  const SalesTrendPoint(day: 'Mon', amount: 84000.0),
  const SalesTrendPoint(day: 'Tue', amount: 112000.0),
  const SalesTrendPoint(day: 'Wed', amount: 96500.0),
  const SalesTrendPoint(day: 'Thu', amount: 145000.0),
  const SalesTrendPoint(day: 'Fri', amount: 189000.0),
  const SalesTrendPoint(day: 'Sat', amount: 220000.0),
  const SalesTrendPoint(day: 'Sun', amount: 165000.0),
];
