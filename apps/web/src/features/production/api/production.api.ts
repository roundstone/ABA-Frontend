export const getProductionOrders = async () => [];

import { Bom } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

export const MOCK_BOMS: Bom[] = [
  {
    id: 'bom-1',
    bomNumber: 'BOM-001',
    finishedProductId: 'prod-1',
    finishedProductName: 'Apple Watch Series 9 GPS 45mm',
    version: '1.0',
    yieldQty: 1,
    yieldUnit: 'piece',
    components: [
      { id: 'comp-1', productId: 'raw-1', productName: 'Watch Casing', quantity: 1, unit: 'piece', cost: 150000 },
      { id: 'comp-2', productId: 'raw-2', productName: 'S9 Chip', quantity: 1, unit: 'piece', cost: 80000 },
      { id: 'comp-3', productId: 'raw-3', productName: 'OLED Display', quantity: 1, unit: 'piece', cost: 70000 },
    ],
    stdCost: 300000,
    status: 'Active',
    updatedAt: '2026-10-01T10:00:00.000Z'
  },
  {
    id: 'bom-2',
    bomNumber: 'BOM-002',
    finishedProductId: 'prod-5',
    finishedProductName: 'Minimalist Leather Backpack',
    version: '1.1',
    yieldQty: 1,
    yieldUnit: 'piece',
    components: [
      { id: 'comp-4', productId: 'raw-4', productName: 'Premium Leather', quantity: 2.5, unit: 'sq_meter', cost: 5000 },
      { id: 'comp-5', productId: 'raw-5', productName: 'Zippers', quantity: 3, unit: 'piece', cost: 500 },
    ],
    stdCost: 14000,
    status: 'Active',
    updatedAt: '2026-09-15T14:30:00.000Z'
  },
  {
    id: 'bom-3',
    bomNumber: 'BOM-003',
    finishedProductId: 'prod-12',
    finishedProductName: 'Premium Cotton T-shirt',
    version: '1.0',
    yieldQty: 10,
    yieldUnit: 'pieces',
    components: [
      { id: 'comp-6', productId: 'prod-13', productName: 'Premium Cotton Fabric', quantity: 15, unit: 'meter', cost: 2500 },
      { id: 'comp-7', productId: 'raw-6', productName: 'Thread Spool', quantity: 1, unit: 'spool', cost: 800 },
    ],
    stdCost: 38300,
    status: 'Draft',
    updatedAt: '2026-09-28T09:15:00.000Z'
  }
];

export const getBoms = async (): Promise<{ data: Bom[] }> => {
  await delay(500);
  return { data: MOCK_BOMS };
};

export const getBomById = async (id: string): Promise<{ data: Bom }> => {
console.log({id});

  await delay(500);

  const bom = MOCK_BOMS.find(b => b.id === id);
  if (!bom) throw new Error('BOM not found');
  return { data: bom };
};

