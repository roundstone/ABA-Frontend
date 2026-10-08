import { brand } from '@/config/brand';
import { Order } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_ORDERS: Order[] = [
  {
    id: 'ord-1',
    orderNumber: 'ORD-10482',
    createdAt: '2026-09-30T10:30:00Z',
    updatedAt: '2026-09-30T10:30:00Z',
    amountRefunded: 0,
    customerId: 'cus-1',
    customerName: 'Aisha Bello',
    customerPhone: '+2348012345678',
    merchantId: 'mer-1',
    merchantName: `${brand.name} HQ Store`,
    channel: 'Admin',
    status: 'Pending',
    paymentStatus: 'Unpaid',
    fulfilmentStatus: 'Unfulfilled',
    subtotal: 15000000, // 150,000 NGN
    discountTotal: 0,
    taxTotal: 1125000,
    deliveryFee: 500000,
    totalAmount: 16625000,
    amountPaid: 0,
    balanceDue: 16625000,
    deliveryMethod: 'Delivery',
    deliveryAddress: '15 Victoria Island, Lagos',
    lines: [
      {
        id: 'ol-1',
        productId: 'prod-1',
        productName: 'Premium Sofa Set',
        sku: 'FURN-SOF-01',
        quantity: 1,
        unitPrice: 15000000,
        discount: 0,
        tax: 1125000,
        lineTotal: 16125000,
        fulfilledQty: 0,
        returnedQty: 0
      }
    ]
  },
  {
    id: 'ord-2',
    orderNumber: 'ORD-10483',
    createdAt: '2026-09-30T11:15:00Z',
    updatedAt: '2026-09-30T11:15:00Z',
    amountRefunded: 0,
    customerName: 'Walk-in Customer',
    merchantId: 'mer-2',
    merchantName: 'Ikeja Branch POS',
    channel: 'POS',
    status: 'Completed',
    paymentStatus: 'Paid',
    fulfilmentStatus: 'Fulfilled',
    subtotal: 2500000,
    discountTotal: 0,
    taxTotal: 187500,
    deliveryFee: 0,
    totalAmount: 2687500,
    amountPaid: 2687500,
    balanceDue: 0,
    deliveryMethod: 'Pickup',
    lines: [
      {
        id: 'ol-2',
        productId: 'prod-5',
        productName: 'Office Chair (Ergo)',
        sku: 'FURN-CHR-99',
        quantity: 1,
        unitPrice: 2500000,
        discount: 0,
        tax: 187500,
        lineTotal: 2687500,
        fulfilledQty: 1,
        returnedQty: 0
      }
    ]
  }
];

export const getOrders = async (): Promise<Order[]> => {
  await delay(800);
  return MOCK_ORDERS;
};

export const getOrderById = async (id: string): Promise<Order> => {
  await delay(500);
  const order = MOCK_ORDERS.find(o => o.id === id || o.orderNumber === id);
  if (!order) throw new Error('Not found');
  return order;
};
