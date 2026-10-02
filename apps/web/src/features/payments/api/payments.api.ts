import { Payment } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_PAYMENTS: Payment[] = [
  {
    id: 'pay-1',
    referenceNumber: 'PAY-89234',
    createdAt: '2026-09-30T10:35:00Z',
    paymentDate: '2026-09-30T10:35:00Z',
    direction: 'In',
    type: 'Order',
    method: 'Transfer',
    status: 'Pending',
    partyId: 'cus-1',
    partyName: 'Aisha Bello',
    amount: 16625000,
    fee: 0,
    netAmount: 16625000,
    accountId: 'acc-gtb',
    accountName: 'GTBank Corporate',
    bankReference: 'GTB-TRANS-99002',
    isReconciled: false,
    recordedBy: 'Admin User',
    allocations: [
      {
        id: 'pa-1',
        documentType: 'Order',
        documentId: 'ord-1',
        documentNumber: 'ORD-10482',
        amountAllocated: 16625000
      }
    ]
  },
  {
    id: 'pay-2',
    referenceNumber: 'PAY-89235',
    createdAt: '2026-09-30T11:20:00Z',
    paymentDate: '2026-09-30T11:20:00Z',
    direction: 'In',
    type: 'Order',
    method: 'Card',
    status: 'Completed',
    partyName: 'Walk-in Customer',
    amount: 2687500,
    fee: 35000, // POS fee
    netAmount: 2652500,
    accountId: 'acc-pos',
    accountName: 'POS Settlement',
    gatewayReference: 'PAYSTACK-1903',
    isReconciled: true,
    recordedBy: 'POS Terminal',
    allocations: [
      {
        id: 'pa-2',
        documentType: 'Order',
        documentId: 'ord-2',
        documentNumber: 'ORD-10483',
        amountAllocated: 2687500
      }
    ]
  }
];

export const getPayments = async (): Promise<Payment[]> => {
  await delay(800);
  return MOCK_PAYMENTS;
};

export const getPaymentById = async (id: string): Promise<Payment> => {
  await delay(500);
  const payment = MOCK_PAYMENTS.find(p => p.id === id || p.referenceNumber === id);
  if (!payment) throw new Error('Not found');
  return payment;
};
