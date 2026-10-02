import { z } from 'zod';

export const createPRSchema = z.object({
  requestType: z.enum(['Raw materials', 'Finished goods', 'Other']),
  deliverToLocationId: z.string().min(1, 'Delivery location is required'),
  requiredByDate: z.string().min(1, 'Required by date is required'),
  urgency: z.enum(['Low', 'Normal', 'High', 'Critical']).default('Normal'),
  justification: z.string().optional(),
  lines: z.array(z.object({
    productId: z.string().min(1, 'Product is required'),
    quantity: z.coerce.number().min(1, 'Quantity must be at least 1'),
    unit: z.string().min(1, 'Unit is required'),
    estimatedUnitCost: z.coerce.number().min(0),
    preferredSupplierId: z.string().optional(),
    note: z.string().optional(),
  })).min(1, 'At least one line item is required'),
}).superRefine((data, ctx) => {
  if ((data.urgency === 'High' || data.urgency === 'Critical') && (!data.justification || data.justification.length < 5)) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: "Justification is required for High or Critical urgency requests",
      path: ["justification"],
    });
  }
});

export type CreatePRInput = z.infer<typeof createPRSchema>;

export const createPOSchema = z.object({
  supplierId: z.string().min(1, 'Supplier is required'),
  deliverToLocationId: z.string().min(1, 'Delivery location is required'),
  orderDate: z.string().min(1, 'Order date is required'),
  expectedDeliveryDate: z.string().min(1, 'Expected delivery date is required'),
  paymentTerms: z.string().min(1, 'Payment terms required'),
  currency: z.string().min(3),
  
  lines: z.array(z.object({
    productId: z.string().min(1, 'Product is required'),
    supplierSku: z.string().optional(),
    quantity: z.coerce.number().min(1, 'Qty must be at least 1'),
    unitPrice: z.coerce.number().min(0, 'Unit price required'),
    taxRate: z.coerce.number().min(0).max(100).default(0),
    discount: z.coerce.number().min(0).default(0),
  })).min(1, 'At least one line item is required'),
  
  shippingCharge: z.coerce.number().min(0).default(0),
  supplierNotes: z.string().optional(),
  internalNotes: z.string().optional(),
});

export type CreatePOInput = z.infer<typeof createPOSchema>;

export const createGRNSchema = z.object({
  poId: z.string().min(1, 'Purchase Order is required'),
  receivingWarehouseId: z.string().min(1, 'Warehouse is required'),
  receivedDate: z.string().min(1, 'Received date is required'),
  deliveryNoteNo: z.string().optional(),
  vehicleDriver: z.string().optional(),
  
  lines: z.array(z.object({
    poLineId: z.string(),
    productId: z.string(),
    receivedNow: z.coerce.number().min(0),
    acceptedQty: z.coerce.number().min(0),
    rejectedQty: z.coerce.number().min(0),
    rejectionReason: z.enum(['Damaged', 'Wrong item', 'Quality fail', 'Short']).optional(),
    batchNo: z.string().optional(),
    expiryDate: z.string().optional(),
  })).min(1, 'At least one line item is required'),
  
  notes: z.string().optional(),
}).superRefine((data, ctx) => {
  data.lines.forEach((line, index) => {
    if (line.receivedNow !== (line.acceptedQty + line.rejectedQty)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Accepted + Rejected quantities must equal Received Now",
        path: ["lines", index, "acceptedQty"],
      });
    }
    if (line.rejectedQty > 0 && !line.rejectionReason) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        message: "Rejection reason is required if items are rejected",
        path: ["lines", index, "rejectionReason"],
      });
    }
  });
});

export type CreateGRNInput = z.infer<typeof createGRNSchema>;

export const createInvoiceSchema = z.object({
  supplierId: z.string().min(1, 'Supplier is required'),
  supplierInvoiceNo: z.string().min(1, 'Supplier Invoice Number is required'),
  invoiceDate: z.string().min(1, 'Invoice date is required'),
  dueDate: z.string().min(1, 'Due date is required'),
  poIds: z.array(z.string()).min(1, 'At least one PO must be linked'),
  
  lines: z.array(z.object({
    productId: z.string(),
    quantity: z.coerce.number().min(0),
    unitPrice: z.coerce.number().min(0),
  })).min(1),
  
  additionalCharges: z.coerce.number().min(0).default(0),
  taxAmount: z.coerce.number().min(0).default(0),
});

export type CreateInvoiceInput = z.infer<typeof createInvoiceSchema>;
