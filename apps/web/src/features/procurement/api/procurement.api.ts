import { PurchaseRequest, PurchaseOrder, GoodsReceiptNote, SupplierInvoice } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_PRS: PurchaseRequest[] = [
  {
    id: 'pr-1',
    prNumber: 'PR-0001',
    requestType: 'Raw materials',
    requesterId: 'usr-1',
    requesterName: 'Sarah Jenkins',
    department: 'Production',
    deliverToLocationId: 'wh-1',
    deliverToLocationName: 'Central Warehouse (Ikeja)',
    requiredByDate: '2026-10-15',
    urgency: 'Normal',
    status: 'Awaiting Approval',
    estimatedTotal: 3000000,
    createdAt: '2026-09-30T09:00:00Z',
    lines: [
      {
        id: 'line-1',
        productId: 'prod-2',
        productName: 'Raw Cotton 100%',
        quantity: 200,
        unit: 'kg',
        estimatedUnitCost: 15000
      }
    ]
  },
  {
    id: 'pr-2',
    prNumber: 'PR-0002',
    requestType: 'Finished goods',
    requesterId: 'usr-2',
    requesterName: 'Michael Obi',
    department: 'Retail',
    deliverToLocationId: 'wh-3',
    deliverToLocationName: 'Ikeja Flagship Store',
    requiredByDate: '2026-10-05',
    urgency: 'Critical',
    justification: 'Stock out risk before weekend sale event',
    status: 'Approved',
    estimatedTotal: 850000,
    createdAt: '2026-09-29T14:30:00Z',
    lines: [
      {
        id: 'line-2',
        productId: 'prod-1',
        productName: 'Premium Cotton T-Shirt',
        quantity: 100,
        unit: 'pcs',
        estimatedUnitCost: 8500
      }
    ]
  }
];

export const getPurchaseRequests = async (): Promise<PurchaseRequest[]> => {
  await delay(800);
  return MOCK_PRS;
};

const MOCK_POS: PurchaseOrder[] = [
  {
    id: 'po-1',
    poNumber: 'PO-2041',
    supplierId: 'sup-1',
    supplierName: 'Global Textiles Ltd',
    deliverToLocationId: 'wh-1',
    deliverToLocationName: 'Central Warehouse (Ikeja)',
    orderDate: '2026-09-25',
    expectedDeliveryDate: '2026-10-01',
    paymentTerms: 'Net 30',
    currency: 'NGN',
    status: 'Ordered',
    subtotal: 3000000,
    taxTotal: 225000,
    discountTotal: 0,
    shippingCharge: 50000,
    totalAmount: 3275000,
    receivedPercentage: 0,
    invoicedPercentage: 0,
    paymentStatus: 'Unpaid',
    lines: [
      {
        id: 'line-1',
        productId: 'prod-2',
        productName: 'Raw Cotton 100%',
        quantity: 200,
        unitPrice: 15000,
        taxRate: 7.5,
        discount: 0,
        lineTotal: 3000000
      }
    ]
  },
  {
    id: 'po-2',
    poNumber: 'PO-2038',
    supplierId: 'sup-2',
    supplierName: 'Chemicals Plus',
    deliverToLocationId: 'wh-2',
    deliverToLocationName: 'Production Floor A',
    orderDate: '2026-09-15',
    expectedDeliveryDate: '2026-09-28',
    paymentTerms: 'PIA (Payment in Advance)',
    currency: 'NGN',
    status: 'Partially Received',
    subtotal: 2250000,
    taxTotal: 0,
    discountTotal: 0,
    shippingCharge: 0,
    totalAmount: 2250000,
    receivedPercentage: 50,
    invoicedPercentage: 100,
    paymentStatus: 'Paid',
    lines: [
      {
        id: 'line-1',
        productId: 'prod-3',
        productName: 'Blue Dye (Industrial)',
        quantity: 50,
        unitPrice: 45000,
        taxRate: 0,
        discount: 0,
        lineTotal: 2250000
      }
    ]
  }
];

export const getPurchaseOrders = async (): Promise<PurchaseOrder[]> => {
  await delay(800);
  return MOCK_POS;
};

export const getPurchaseOrderById = async (id: string): Promise<PurchaseOrder> => {
  await delay(500);
  const po = MOCK_POS.find(p => p.id === id || p.poNumber === id);
  if (!po) throw new Error('Not found');
  return po;
};

const MOCK_GRNS: GoodsReceiptNote[] = [
  {
    id: 'grn-1',
    grnNumber: 'GRN-0310',
    poId: 'po-2',
    poNumber: 'PO-2038',
    supplierName: 'Chemicals Plus',
    receivingWarehouseId: 'wh-2',
    receivingWarehouseName: 'Production Floor A',
    receivedDate: '2026-09-28',
    deliveryNoteNo: 'DN-9941',
    status: 'Posted',
    lines: [
      {
        id: 'gl-1',
        poLineId: 'line-1',
        productId: 'prod-3',
        productName: 'Blue Dye (Industrial)',
        orderedQty: 100,
        previouslyReceivedQty: 0,
        receivedNow: 50,
        acceptedQty: 50,
        rejectedQty: 0
      }
    ]
  }
];

export const getGRNs = async (): Promise<GoodsReceiptNote[]> => {
  await delay(800);
  return MOCK_GRNS;
};

const MOCK_INVOICES: SupplierInvoice[] = [
  {
    id: 'inv-1',
    invoiceNumber: 'SINV-0010',
    supplierInvoiceNo: 'INV-CP-2026-88',
    supplierId: 'sup-2',
    supplierName: 'Chemicals Plus',
    poIds: ['po-2'],
    grnIds: ['grn-1'],
    invoiceDate: '2026-09-29',
    dueDate: '2026-10-29',
    status: 'Approved',
    subtotal: 2250000,
    taxAmount: 0,
    additionalCharges: 0,
    totalAmount: 2250000,
    amountPaid: 0,
    lines: [
      {
        id: 'il-1',
        grnLineId: 'gl-1',
        productId: 'prod-3',
        productName: 'Blue Dye (Industrial)',
        quantity: 50,
        unitPrice: 45000,
        lineTotal: 2250000
      }
    ]
  }
];

export const getSupplierInvoices = async (): Promise<SupplierInvoice[]> => {
  await delay(800);
  return MOCK_INVOICES;
};
