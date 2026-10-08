import { Payment } from './types';

export const mockPayments: Payment[] = [
  {
    id: 'pay-1',
    referenceNumber: 'PAY-2026-001',
    createdAt: '2026-09-12T10:00:00Z',
    paymentDate: '2026-09-12T10:00:00Z',
    direction: 'In',
    type: 'Order',
    method: 'Transfer',
    status: 'Completed',
    partyName: 'John Smith',
    amount: 15000000,
    fee: 0,
    netAmount: 15000000,
    accountId: 'acc-1',
    accountName: 'GTBank Main',
    isReconciled: true,
    recordedBy: 'Admin User',
    allocations: [
      { id: 'alloc-1', documentType: 'Order', documentId: 'ord-1', documentNumber: 'ORD-10482', amountAllocated: 15000000 }
    ]
  },
  {
    id: 'pay-2',
    referenceNumber: 'PAY-2026-002',
    createdAt: '2026-09-13T14:30:00Z',
    paymentDate: '2026-09-13T14:30:00Z',
    direction: 'Out',
    type: 'Supplier',
    method: 'Transfer',
    status: 'Pending',
    partyName: 'Tech Supplies Co',
    amount: 50000000,
    fee: 5000,
    netAmount: 49950000,
    accountId: 'acc-1',
    accountName: 'GTBank Main',
    isReconciled: false,
    recordedBy: 'Finance Mgr',
    allocations: [
      { id: 'alloc-2', documentType: 'Invoice', documentId: 'inv-1', documentNumber: 'INV-001', amountAllocated: 50000000 }
    ]
  }
];

export const mockRefunds = [
  {
    id: 'ref-1',
    refundNumber: 'REF-2026-001',
    originalPaymentId: 'pay-1',
    orderNumber: 'ORD-10482',
    customerName: 'John Smith',
    amount: 1500000,
    method: 'Original method',
    reason: 'Customer requested return due to damage',
    requestedBy: 'Support Agent',
    status: 'Requested',
    date: '2026-09-14T09:00:00Z'
  },
  {
    id: 'ref-2',
    refundNumber: 'REF-2026-002',
    originalPaymentId: 'pay-2',
    orderNumber: 'ORD-10450',
    customerName: 'Emily Buyer',
    amount: 5000000,
    method: 'Wallet',
    reason: 'Order cancelled out of stock',
    requestedBy: 'System',
    status: 'Completed',
    date: '2026-09-10T11:15:00Z'
  }
];

export const mockPaymentKPIs = {
  collectedPeriod: 125000000,
  pending: 55000000,
  failed: 1200000,
  refunded: 450000,
  outstandingReceivables: 80000000,
  paymentsDueOut: 50000000
};
