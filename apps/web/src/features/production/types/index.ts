export type BomStatus = 'Draft' | 'Active' | 'Archived';

export interface BomComponent {
  id: string;
  productId: string;
  productName: string;
  quantity: number;
  unit: string;
  cost: number;
}

export interface Bom {
  id: string;
  bomNumber: string;
  finishedProductId: string;
  finishedProductName: string;
  version: string;
  yieldQty: number;
  yieldUnit: string;
  components: BomComponent[];
  stdCost: number;
  status: BomStatus;
  updatedAt: string;
}
