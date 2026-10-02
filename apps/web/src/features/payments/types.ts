export type PaymentDirection = 'In' | 'Out';
export type PaymentType = 'Order' | 'Wallet top-up' | 'Supplier' | 'Refund' | 'Payout' | 'Merchant settlement';
export type PaymentMethod = 'Cash' | 'Transfer' | 'Card' | 'Wallet' | 'Cheque' | 'Gateway';
export type PaymentStatus = 'Pending' | 'Completed' | 'Failed' | 'Refunded' | 'Voided';

export interface PaymentAllocation {
  id: string;
  documentType: 'Order' | 'Invoice' | 'Wallet';
  documentId: string;
  documentNumber: string;
  amountAllocated: number; // in minor units
}

export interface Payment {
  id: string;
  referenceNumber: string;
  createdAt: string;
  paymentDate: string;
  
  direction: PaymentDirection;
  type: PaymentType;
  method: PaymentMethod;
  status: PaymentStatus;
  
  partyId?: string;
  partyName: string;
  
  amount: number; // in minor units
  fee: number; // in minor units
  netAmount: number; // in minor units
  
  accountId: string;
  accountName: string;
  
  bankReference?: string;
  gatewayReference?: string;
  
  isReconciled: boolean;
  notes?: string;
  recordedBy: string;
  
  allocations: PaymentAllocation[];
}
