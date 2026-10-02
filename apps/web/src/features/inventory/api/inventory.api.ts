import { StockLevel, StockMovement, Warehouse } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_WAREHOUSES: Warehouse[] = [
  { id: 'wh-1', name: 'Central Warehouse (Ikeja)', type: 'Central', address: 'Plot 4, Industrial Estate, Ikeja', isActive: true },
  { id: 'wh-2', name: 'Production Floor A', type: 'Production', address: 'Plot 4, Industrial Estate, Ikeja', isActive: true },
  { id: 'wh-3', name: 'Ikeja Flagship Store', type: 'Shop', address: '123 Retail Avenue, Ikeja', isActive: true },
  { id: 'wh-4', name: 'Quarantine Zone', type: 'Quarantine', address: 'Plot 4, Industrial Estate, Ikeja', isActive: true },
];

const MOCK_STOCK_LEVELS: StockLevel[] = [
  {
    id: 'stock-1',
    productId: 'prod-1',
    productName: 'Premium Cotton T-Shirt',
    sku: 'APP-TS-001',
    category: 'Apparel',
    type: 'Finished good',
    locationId: 'wh-1',
    locationName: 'Central Warehouse (Ikeja)',
    onHand: 1500,
    reserved: 200,
    available: 1300,
    inTransit: 0,
    onOrder: 500,
    reorderLevel: 500,
    unitCost: 800000, // 8,000 NGN
    totalValue: 1200000000, // 12m NGN
    status: 'In Stock'
  },
  {
    id: 'stock-2',
    productId: 'prod-2',
    productName: 'Raw Cotton 100%',
    sku: 'RAW-COT-01',
    category: 'Fabric',
    type: 'Raw material',
    locationId: 'wh-1',
    locationName: 'Central Warehouse (Ikeja)',
    onHand: 40,
    reserved: 10,
    available: 30,
    inTransit: 100,
    onOrder: 200,
    reorderLevel: 100,
    unitCost: 150000, // 1,500 NGN per kg
    totalValue: 6000000,
    status: 'Low Stock'
  },
  {
    id: 'stock-3',
    productId: 'prod-1',
    productName: 'Premium Cotton T-Shirt',
    sku: 'APP-TS-001',
    category: 'Apparel',
    type: 'Finished good',
    locationId: 'wh-3',
    locationName: 'Ikeja Flagship Store',
    onHand: 0,
    reserved: 0,
    available: 0,
    inTransit: 50,
    onOrder: 0,
    reorderLevel: 20,
    unitCost: 800000,
    totalValue: 0,
    status: 'Out of Stock'
  }
];

export const getStockLevels = async (): Promise<StockLevel[]> => {
  await delay(800);
  return MOCK_STOCK_LEVELS;
};

export const getWarehouses = async (): Promise<Warehouse[]> => {
  await delay(500);
  return MOCK_WAREHOUSES;
};

const MOCK_MOVEMENTS: StockMovement[] = [
  {
    id: 'mov-1',
    movementNo: 'TRF-0010',
    date: '2026-09-30T10:30:00Z',
    type: 'transfer_out',
    productId: 'prod-1',
    productName: 'Premium Cotton T-Shirt',
    fromLocationId: 'wh-1',
    toLocationId: 'wh-3',
    quantity: -50,
    unitCost: 800000,
    totalValue: -40000000,
    balanceAfter: 1500,
    sourceDocument: { type: 'Transfer', id: 'trf-1', ref: 'TRF-1042' },
    userId: 'user-1',
    userName: 'Admin User'
  },
  {
    id: 'mov-2',
    movementNo: 'GRN-0310',
    date: '2026-09-29T14:15:00Z',
    type: 'receipt',
    productId: 'prod-2',
    productName: 'Raw Cotton 100%',
    toLocationId: 'wh-1',
    quantity: 40,
    unitCost: 150000,
    totalValue: 6000000,
    balanceAfter: 40,
    sourceDocument: { type: 'PO', id: 'po-1', ref: 'PO-2041' },
    userId: 'user-2',
    userName: 'Warehouse Manager'
  },
  {
    id: 'mov-3',
    movementNo: 'ADJ-004',
    date: '2026-09-28T09:00:00Z',
    type: 'adjustment_down',
    productId: 'prod-1',
    productName: 'Premium Cotton T-Shirt',
    fromLocationId: 'wh-1',
    quantity: -5,
    unitCost: 800000,
    totalValue: -4000000,
    balanceAfter: 1550,
    sourceDocument: { type: 'Adjustment', id: 'adj-1', ref: 'ADJ-109' },
    userId: 'user-2',
    userName: 'Warehouse Manager'
  }
];

export const getStockMovements = async (): Promise<StockMovement[]> => {
  await delay(800);
  return MOCK_MOVEMENTS;
};
