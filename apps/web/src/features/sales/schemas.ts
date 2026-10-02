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
