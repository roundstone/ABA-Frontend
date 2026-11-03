export type MovementType = 'receipt' | 'issue' | 'transfer_out' | 'transfer_in' | 'adjustment_up' | 'adjustment_down' | 'return';
export type StockStatus = 'In Stock' | 'Low Stock' | 'Out of Stock' | 'Overstock';

export interface Warehouse {
  id: string;
  name: string;
  type: 'Central' | 'Production' | 'Shop' | 'Quarantine';
  address: string;
  isActive: boolean;
}

export interface StockLevel {
  id: string; // product_location composite ideally
  productId: string;
  productName: string;
  sku: string;
  imageUrl?: string;
  category: string;
  type: 'Finished good' | 'Raw material';
  locationId: string;
  locationName: string;
  
  onHand: number;
  reserved: number; // orders/holds
  available: number; // onHand - reserved
  inTransit: number;
  onOrder: number; // open POs
  
  reorderLevel: number;
  unitCost: number;
  totalValue: number; // onHand * unitCost
  status: StockStatus;
}

export interface StockMovement {
  id: string;
  movementNo: string;
  date: string;
  type: MovementType;
  productId: string;
  productName: string;
  fromLocationId?: string;
  toLocationId?: string;
  quantity: number;
  unitCost: number;
  totalValue: number;
  balanceAfter: number;
  sourceDocument: {
    type: 'PO' | 'Order' | 'Transfer' | 'Adjustment' | 'Production';
    id: string;
    ref: string;
  };
  userId: string;
  userName: string;
}

export type AdjustmentReason =
  | 'Damage'
  | 'Expiry'
  | 'Theft/Loss'
  | 'Count correction'
  | 'Found stock'
  | 'Opening balance'
  | 'Other';

export type AdjustmentStatus = 'Draft' | 'Awaiting Approval' | 'Posted' | 'Rejected';

export interface QuickAdjustParams {
  productId: string;
  variantId?: string;
  locationId: string;
  mode: 'delta' | 'absolute';
  deltaQty: number;
  newQty: number;
  reason: AdjustmentReason;
  unitCost: number;
  date: string;
  notes?: string;
}

export interface AdjustStockResult {
  success: boolean;
  status: AdjustmentStatus;
  deltaQty: number;
  newStock: number;
  valueImpact: number;
  movement?: StockMovement;
  message?: string;
}
