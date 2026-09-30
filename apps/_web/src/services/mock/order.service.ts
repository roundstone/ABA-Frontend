import { CommissionService } from "./commission.service";
import { ReferralService } from "./referral.service";

export type OrderStatus = 'PENDING' | 'PROCESSING' | 'SHIPPED' | 'DELIVERED' | 'CANCELLED';

export interface OrderItem {
  id: string;
  productId: string;
  productName: string;
  price: number;
  quantity: number;
  image?: string;
}

export interface OrderTrackingEvent {
  status: OrderStatus;
  date: string;
  location?: string;
  description?: string;
}

export interface Order {
  id: string;
  customerId: string;
  items: OrderItem[];
  subtotal: number;
  tax: number;
  shipping: number;
  total: number;
  status: OrderStatus;
  createdAt: string;
  shippingAddress?: string;
  paymentMethod?: string;
  trackingHistory: OrderTrackingEvent[];
}

// Mock Data
let mockOrders: Order[] = [
  {
    id: 'ord_12345',
    customerId: 'usr_abc',
    items: [
      { id: '1', productId: 'p1', productName: 'Premium Backpack', price: 89.99, quantity: 1, image: '/images/bags/product/1.jpg' },
    ],
    subtotal: 89.99,
    tax: 4.50,
    shipping: 10.00,
    total: 104.49,
    status: 'SHIPPED',
    createdAt: new Date(Date.now() - 86400000 * 2).toISOString(),
    shippingAddress: '123 Main St, Anytown, USA',
    paymentMethod: 'STRIPE',
    trackingHistory: [
      { status: 'PENDING', date: new Date(Date.now() - 86400000 * 2).toISOString(), description: 'Order Placed' },
      { status: 'PROCESSING', date: new Date(Date.now() - 86400000 * 1.5).toISOString(), description: 'Processing Order' },
      { status: 'SHIPPED', date: new Date(Date.now() - 86400000 * 0.5).toISOString(), description: 'Package handed to carrier', location: 'Denver, CO' }
    ]
  },
  {
    id: 'ord_67890',
    customerId: 'usr_xyz',
    items: [
      { id: '2', productId: 'p2', productName: 'Leather Wallet', price: 49.99, quantity: 2, image: '/images/bags/product/2.jpg' },
    ],
    subtotal: 99.98,
    tax: 5.00,
    shipping: 0.00,
    total: 104.98,
    status: 'DELIVERED',
    createdAt: new Date(Date.now() - 86400000 * 10).toISOString(),
    shippingAddress: '456 Oak Ave, Somewhere, CA',
    paymentMethod: 'PAYPAL',
    trackingHistory: [
      { status: 'PENDING', date: new Date(Date.now() - 86400000 * 10).toISOString(), description: 'Order Placed' },
      { status: 'PROCESSING', date: new Date(Date.now() - 86400000 * 9).toISOString(), description: 'Processing Order' },
      { status: 'SHIPPED', date: new Date(Date.now() - 86400000 * 8).toISOString(), description: 'Package handed to carrier', location: 'Denver, CO' },
      { status: 'DELIVERED', date: new Date(Date.now() - 86400000 * 5).toISOString(), description: 'Package Delivered', location: 'Somewhere, CA' }
    ]
  }
];

export const OrderService = {
  getOrders: (): Order[] => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('aba_mock_orders');
      if (stored) return JSON.parse(stored);
      localStorage.setItem('aba_mock_orders', JSON.stringify(mockOrders));
    }
    return mockOrders;
  },

  getUserOrders: (userId: string): Order[] => {
    const orders = OrderService.getOrders();
    return orders.filter(order => order.customerId === userId);
  },

  getOrderById: (orderId: string): Order | undefined => {
    const orders = OrderService.getOrders();
    return orders.find(o => o.id === orderId);
  },

  createOrder: (orderData: Omit<Order, 'id' | 'createdAt' | 'status' | 'trackingHistory'>, referralCode?: string): Order => {
    const newOrder: Order = {
      ...orderData,
      id: `ord_${Math.random().toString(36).substr(2, 9)}`,
      createdAt: new Date().toISOString(),
      status: 'PENDING',
      trackingHistory: [
        { status: 'PENDING', date: new Date().toISOString(), description: 'Order Placed' }
      ]
    };

    if (referralCode) {
      const mockReferrerId = `usr_${referralCode.toLowerCase()}`;
      const upline = ReferralService.getUplineChain(newOrder.customerId);
      if (upline.length === 0 && mockReferrerId !== newOrder.customerId) {
        ReferralService.addReferral({
          referrerId: mockReferrerId,
          referredId: newOrder.customerId,
          referralCode: referralCode,
          channel: 'CHECKOUT',
        });
      }
    }

    if (newOrder.items.length > 0) {
      // In a real system, you might loop through items. Here we just use the first item for mock commissions, or calculate total
      CommissionService.calculateCommission(newOrder.id, newOrder.customerId, newOrder.items[0].productId, newOrder.subtotal);
    }

    const orders = OrderService.getOrders();
    const updatedOrders = [newOrder, ...orders];
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_orders', JSON.stringify(updatedOrders));
    }
    mockOrders = updatedOrders;
    
    return newOrder;
  },

  updateOrderStatus: (orderId: string, status: OrderStatus): Order | undefined => {
    const orders = OrderService.getOrders();
    const index = orders.findIndex(o => o.id === orderId);
    if (index > -1) {
      orders[index].status = status;
      if (typeof window !== 'undefined') {
        localStorage.setItem('aba_mock_orders', JSON.stringify(orders));
      }
      mockOrders = orders;
      return orders[index];
    }
    return undefined;
  }
};
