import { API_MODE, fetchApi } from '@/lib/api';
import { mockShopProducts } from '@/features/shop/mocks';
import {
  AdjustStockResult,
  QuickAdjustParams,
  StockLevel,
  StockMovement,
  Warehouse,
} from '../types';
import { MOCK_WAREHOUSES, MOCK_STOCK_LEVELS, MOCK_MOVEMENTS } from '../mocks';

const delay = (ms: number) => new Promise((res) => setTimeout(res, ms));

export const getStockLevels = async (): Promise<StockLevel[]> => {
  await delay(400);
  return MOCK_STOCK_LEVELS;
};

export const getWarehouses = async (): Promise<Warehouse[]> => {
  await delay(250);
  return MOCK_WAREHOUSES;
};

export const getStockMovements = async (): Promise<StockMovement[]> => {
  await delay(400);
  return MOCK_MOVEMENTS;
};

export const getStockByProductId = async (productId: string): Promise<StockLevel[]> => {
  await delay(300);
  const found = MOCK_STOCK_LEVELS.filter((s) => s.productId === productId);
  if (found.length > 0) return found;

  const product = mockShopProducts.find((p) => p.id === productId);
  if (!product) return [];

  return [
    {
      id: `stock-${productId}-wh1`,
      productId: product.id,
      productName: product.name,
      sku: product.sku,
      category: product.categoryName,
      type: product.type === 'Raw material' ? 'Raw material' : 'Finished good',
      locationId: 'wh-1',
      locationName: 'Central Warehouse (Ikeja)',
      onHand: product.totalStock,
      reserved: 0,
      available: product.totalStock,
      inTransit: 0,
      onOrder: 0,
      reorderLevel: product.reorderLevel,
      unitCost: product.price,
      totalValue: product.totalStock * product.price,
      status: product.totalStock === 0 ? 'Out of Stock' : product.totalStock <= product.reorderLevel ? 'Low Stock' : 'In Stock',
    },
  ];
};

export const getMovementsByProductId = async (productId: string): Promise<StockMovement[]> => {
  await delay(300);
  return MOCK_MOVEMENTS.filter((m) => m.productId === productId);
};

export const adjustProductStock = async (params: QuickAdjustParams): Promise<AdjustStockResult> => {
  if (API_MODE !== 'mock') {
    return fetchApi<AdjustStockResult>('/api/v1/inventory/adjustments', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(params),
    });
  }

  await delay(600);

  const product = mockShopProducts.find((p) => p.id === params.productId);
  const currentTotal = product?.totalStock ?? 0;
  let currentTargetStock = currentTotal;

  if (params.variantId && product?.variants?.length) {
    const variant = product.variants.find((v) => v.id === params.variantId);
    if (variant) currentTargetStock = variant.stockCount ?? 0;
  }

  const delta = params.mode === 'absolute' ? params.newQty - currentTargetStock : params.deltaQty;
  const newTargetStock = Math.max(0, currentTargetStock + delta);
  const valueImpact = delta * params.unitCost;

  // Threshold: adjustments with value exceeding 5,000,000 kobo (NGN 50,000) require approval
  const APPROVAL_THRESHOLD = 5000000;
  const status = Math.abs(valueImpact) > APPROVAL_THRESHOLD ? 'Awaiting Approval' : 'Posted';

  let newTotalStock = currentTotal;

  if (status === 'Posted' && product) {
    if (params.variantId && product.variants?.length) {
      const variant = product.variants.find((v) => v.id === params.variantId);
      if (variant) {
        variant.stockCount = newTargetStock;
      }
      product.totalStock = product.variants.reduce((acc, v) => acc + (v.stockCount ?? 0), 0);
      newTotalStock = product.totalStock;
    } else {
      product.totalStock = newTargetStock;
      newTotalStock = newTargetStock;
    }

    const warehouse = MOCK_WAREHOUSES.find((w) => w.id === params.locationId);
    const existingStock = MOCK_STOCK_LEVELS.find(
      (s) => s.productId === params.productId && s.locationId === params.locationId,
    );

    if (existingStock) {
      existingStock.onHand = Math.max(0, existingStock.onHand + delta);
      existingStock.available = Math.max(0, existingStock.onHand - existingStock.reserved);
      existingStock.totalValue = existingStock.onHand * existingStock.unitCost;
      existingStock.status = existingStock.onHand === 0 ? 'Out of Stock' : existingStock.onHand <= existingStock.reorderLevel ? 'Low Stock' : 'In Stock';
    } else if (warehouse) {
      MOCK_STOCK_LEVELS.unshift({
        id: `stock-${Date.now()}`,
        productId: product.id,
        productName: product.name,
        sku: product.sku,
        category: product.categoryName,
        type: product.type === 'Raw material' ? 'Raw material' : 'Finished good',
        locationId: warehouse.id,
        locationName: warehouse.name,
        onHand: Math.max(0, delta),
        reserved: 0,
        available: Math.max(0, delta),
        inTransit: 0,
        onOrder: 0,
        reorderLevel: product.reorderLevel,
        unitCost: params.unitCost,
        totalValue: Math.max(0, delta) * params.unitCost,
        status: delta <= 0 ? 'Out of Stock' : 'In Stock',
      });
    }

    const newMovement: StockMovement = {
      id: `mov-${Date.now()}`,
      movementNo: `ADJ-${Math.floor(1000 + Math.random() * 9000)}`,
      date: params.date || new Date().toISOString(),
      type: delta >= 0 ? 'adjustment_up' : 'adjustment_down',
      productId: params.productId,
      productName: product.name,
      fromLocationId: delta < 0 ? params.locationId : undefined,
      toLocationId: delta > 0 ? params.locationId : undefined,
      quantity: delta,
      unitCost: params.unitCost,
      totalValue: Math.abs(valueImpact),
      balanceAfter: newTotalStock,
      sourceDocument: {
        type: 'Adjustment',
        id: `adj-${Date.now()}`,
        ref: `ADJ-${Math.floor(1000 + Math.random() * 9000)}`,
      },
      userId: 'usr-1',
      userName: 'Current User',
    };

    MOCK_MOVEMENTS.unshift(newMovement);

    return {
      success: true,
      status,
      deltaQty: delta,
      newStock: newTotalStock,
      valueImpact,
      movement: newMovement,
      message: 'Adjustment posted to inventory ledger.',
    };
  }

  return {
    success: true,
    status,
    deltaQty: delta,
    newStock: currentTotal,
    valueImpact,
    message: 'Adjustment submitted for manager approval (value exceeds ₦50,000 threshold).',
  };
};
