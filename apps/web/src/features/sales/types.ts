export type OrderStatus = 'Draft' | 'Awaiting Approval' | 'Pending' | 'Processing' | 'Ready' | 'Out for Delivery' | 'Completed' | 'Cancelled' | 'Refunded' | 'Partially Refunded';
export type PaymentStatus = 'Unpaid' | 'Partially Paid' | 'Paid' | 'Overdue' | 'Refunded' | 'Partially Refunded' | 'Failed';
export type FulfilmentStatus = 'Unfulfilled' | 'Partially Fulfilled' | 'Fulfilled' | 'Returned';
export type SalesChannel = 'Admin' | 'POS' | 'Web' | 'Portal';

export interface OrderLine {
  id: string;
  productId: string;
  productName: string;
  sku: string;
  quantity: number;
  unitPrice: number; // in minor units
  discount: number; // in minor units
  tax: number; // in minor units
  lineTotal: number;
  fulfilledQty: number;
  returnedQty: number;
  status?: string;
}

export interface FulfilmentRecordItem {
  lineId: string;
  productId: string;
  productName: string;
  sku: string;
  quantity: number;
}

export interface FulfilmentRecord {
  id: string;
  fulfilmentNo: string;
  orderId: string;
  createdAt: string;
  warehouseId: string;
  warehouseName: string;
  packedBy: string;
  carrier?: string;
  trackingNumber?: string;
  notes?: string;
  items: FulfilmentRecordItem[];
}

export interface Order {
  id: string;
  orderNumber: string;
  createdAt: string;
  updatedAt: string;
  
  customerId?: string;
  customerName: string;
  customerPhone?: string;
  merchantId: string;
  merchantName: string;
  
  channel: SalesChannel;
  status: OrderStatus;
  paymentStatus: PaymentStatus;
  fulfilmentStatus: FulfilmentStatus;
  
  lines: OrderLine[];
  fulfilments?: FulfilmentRecord[];
  
  subtotal: number;
  discountTotal: number;
  taxTotal: number;
  deliveryFee: number;
  totalAmount: number;
  amountPaid: number;
  balanceDue: number;
  amountRefunded: number;
  
  deliveryMethod: 'Pickup' | 'Delivery';
  deliveryAddress?: string;
  expectedDeliveryDate?: string;
  
  internalNotes?: string;
  customerNotes?: string;
  notes?: string;
  
  referrerId?: string; // Links to commission
}

export interface FulfilOrderLineInput {
  lineId: string;
  productId: string;
  quantityToFulfil: number;
}

export interface FulfilOrderInput {
  orderId: string;
  warehouseId: string;
  packedBy: string;
  date?: string;
  carrier?: string;
  trackingNumber?: string;
  notes?: string;
  items: FulfilOrderLineInput[];
}
