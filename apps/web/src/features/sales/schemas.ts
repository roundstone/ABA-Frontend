import { z } from 'zod';

export const createOrderSchema = z.object({
  customerId: z.string().optional(),
  customerName: z.string().min(1, 'Customer name is required'),
  customerPhone: z.string().optional(),
  
  channel: z.enum(['Admin', 'POS', 'Web', 'Portal']).default('Admin'),
  merchantId: z.string().min(1, 'Merchant is required'),
  
  lines: z.array(z.object({
    productId: z.string().min(1, 'Product is required'),
    quantity: z.coerce.number().min(1, 'Qty must be at least 1'),
    unitPrice: z.coerce.number().min(0),
    discount: z.coerce.number().min(0).default(0),
    taxRate: z.coerce.number().min(0).max(100).default(7.5),
  })).min(1, 'At least one line item is required'),
  
  orderDiscount: z.coerce.number().min(0).default(0),
  deliveryFee: z.coerce.number().min(0).default(0),
  
  deliveryMethod: z.enum(['Pickup', 'Delivery']),
  deliveryAddress: z.string().optional(),
  expectedDeliveryDate: z.string().optional(),
  
  paymentOption: z.enum(['Pay now', 'Pay later', 'Partial']),
  
  internalNotes: z.string().optional(),
  customerNotes: z.string().optional(),
});

export type CreateOrderInput = z.infer<typeof createOrderSchema>;

export const fulfilOrderSchema = z.object({
  orderId: z.string().min(1, 'Order ID is required'),
  warehouseId: z.string().min(1, 'Warehouse is required'),
  packedBy: z.string().min(2, 'Packed by name must be at least 2 characters'),
  date: z.string().min(1, 'Fulfilment date is required'),
  carrier: z.string().optional(),
  trackingNumber: z.string().optional(),
  notes: z.string().optional(),
  items: z.array(z.object({
    lineId: z.string().min(1),
    productId: z.string().min(1),
    quantityToFulfil: z.coerce.number().min(0, 'Quantity cannot be negative'),
  })).min(1, 'At least one item is required'),
});

export type FulfilOrderFormInput = z.infer<typeof fulfilOrderSchema>;
