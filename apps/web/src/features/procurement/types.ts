export type ApprovalStatus = 'Draft' | 'Awaiting Approval' | 'Approved' | 'Rejected' | 'Converted' | 'Cancelled';
export type PoStatus = 'Draft' | 'Awaiting Approval' | 'Approved' | 'Ordered' | 'Partially Received' | 'Received' | 'Closed' | 'Cancelled';
export type GrnStatus = 'Draft' | 'Posted' | 'Voided';
export type InvoiceStatus = 'Draft' | 'Matched' | 'On hold' | 'Approved' | 'Partially paid' | 'Paid' | 'Overdue' | 'Void';
export type Urgency = 'Low' | 'Normal' | 'High' | 'Critical';
export type RequestType = 'Raw materials' | 'Finished goods' | 'Other';

export interface PurchaseRequestLine {
  id: string;
  productId: string;
  productName: string;
  quantity: number;
  unit: string;
  estimatedUnitCost: number;
  preferredSupplierId?: string;
  note?: string;
}

export interface PurchaseRequest {
  id: string;
  prNumber: string;
  requestType: RequestType;
  requesterId: string;
  requesterName: string;
  department: string;
  deliverToLocationId: string;
  deliverToLocationName: string;
  requiredByDate: string;
  urgency: Urgency;
  justification?: string;
  status: ApprovalStatus;
  lines: PurchaseRequestLine[];
  estimatedTotal: number;
  linkedPoId?: string;
  linkedPoNumber?: string;
  createdAt: string;
}

export interface PurchaseOrderLine {
  id: string;
  productId: string;
  productName: string;
  supplierSku?: string;
  quantity: number;
  unitPrice: number; // in minor units
  taxRate: number; // percentage
  discount: number; // in minor units
  lineTotal: number;
}

export interface PurchaseOrder {
  id: string;
  poNumber: string;
  supplierId: string;
  supplierName: string;
  deliverToLocationId: string;
  deliverToLocationName: string;
  orderDate: string;
  expectedDeliveryDate: string;
  paymentTerms: string;
  currency: string;
  status: PoStatus;
  
  lines: PurchaseOrderLine[];
  subtotal: number;
  taxTotal: number;
  discountTotal: number;
  shippingCharge: number;
  totalAmount: number;
  
  receivedPercentage: number;
  invoicedPercentage: number;
  paymentStatus: 'Unpaid' | 'Partially Paid' | 'Paid';
  
  internalNotes?: string;
  supplierNotes?: string;
}

export interface GRNLine {
  id: string;
  poLineId: string;
  productId: string;
  productName: string;
  orderedQty: number;
  previouslyReceivedQty: number;
  receivedNow: number;
  acceptedQty: number;
  rejectedQty: number;
  rejectionReason?: 'Damaged' | 'Wrong item' | 'Quality fail' | 'Short';
  batchNo?: string;
  expiryDate?: string;
  binLocation?: string;
}

export interface GoodsReceiptNote {
  id: string;
  grnNumber: string;
  poId: string;
  poNumber: string;
  supplierName: string;
  receivingWarehouseId: string;
  receivingWarehouseName: string;
  receivedDate: string;
  deliveryNoteNo?: string;
  vehicleDriver?: string;
  status: GrnStatus;
  lines: GRNLine[];
  notes?: string;
}

export interface InvoiceLine {
  id: string;
  grnLineId: string;
  productId: string;
  productName: string;
  quantity: number;
  unitPrice: number;
  lineTotal: number;
  varianceWarning?: string; // Mismatch flag from 3-way match
}

export interface SupplierInvoice {
  id: string;
  invoiceNumber: string;
  supplierInvoiceNo: string;
  supplierId: string;
  supplierName: string;
  poIds: string[];
  grnIds: string[];
  invoiceDate: string;
  dueDate: string;
  status: InvoiceStatus;
  lines: InvoiceLine[];
  subtotal: number;
  taxAmount: number;
  additionalCharges: number;
  totalAmount: number;
  amountPaid: number;
}
