import { z } from 'zod';

export const recordPaymentSchema = z.object({
  direction: z.enum(['In', 'Out']),
  type: z.enum(['Order', 'Wallet top-up', 'Supplier', 'Refund', 'Payout', 'Merchant settlement']),
  
  partyId: z.string().min(1, 'Party is required'),
  
  amount: z.coerce.number().min(1, 'Amount must be greater than 0'),
  fee: z.coerce.number().min(0).default(0),
  
  method: z.enum(['Cash', 'Transfer', 'Card', 'Wallet', 'Cheque', 'Gateway']),
  accountId: z.string().min(1, 'Account is required'),
  
  paymentDate: z.string().min(1, 'Payment date is required'),
  
  reference: z.string().optional(),
  notes: z.string().optional(),
  
  allocations: z.array(z.object({
    documentId: z.string(),
    documentType: z.enum(['Order', 'Invoice', 'Wallet']),
    amountAllocated: z.coerce.number().min(0)
  })).default([])
}).superRefine((data, ctx) => {
  if (['Transfer', 'Card', 'Cheque'].includes(data.method) && !data.reference) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Reference is required for this payment method',
      path: ['reference']
    });
  }
});

export type RecordPaymentInput = z.infer<typeof recordPaymentSchema>;
