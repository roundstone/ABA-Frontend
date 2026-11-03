import { API_MODE, fetchApi } from '@/lib/api';
import { MOCK_ORDERS } from '../mocks';
import { FulfilOrderInput, Order, FulfilmentRecord } from '../types';
import { MOCK_WAREHOUSES, MOCK_STOCK_LEVELS, MOCK_MOVEMENTS } from '@/features/inventory/mocks';
import { mockShopProducts } from '@/features/shop/mocks';

const delay = (ms: number) => new Promise((res) => setTimeout(res, ms));

export const getOrders = async (): Promise<Order[]> => {
  if (API_MODE !== 'mock') {
    return fetchApi<Order[]>('/api/v1/orders');
  }
  await delay(500);
  return MOCK_ORDERS;
};

export const getOrderById = async (id: string): Promise<Order> => {
  if (API_MODE !== 'mock') {
    return fetchApi<Order>(`/api/v1/orders/${encodeURIComponent(id)}`);
  }
  await delay(300);
  const order = MOCK_ORDERS.find((o) => o.id === id || o.orderNumber === id);
  if (!order) throw new Error('Order not found');
  return order;
};

export const fulfilOrder = async (input: FulfilOrderInput): Promise<Order> => {
  if (API_MODE !== 'mock') {
    return fetchApi<Order>(`/api/v1/orders/${encodeURIComponent(input.orderId)}/fulfil`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(input),
    });
  }

  await delay(600);
  const order = MOCK_ORDERS.find((o) => o.id === input.orderId || o.orderNumber === input.orderId);
  if (!order) throw new Error('Order not found');

  const itemsToFulfil = input.items.filter((i) => i.quantityToFulfil > 0);
  if (itemsToFulfil.length === 0) {
    throw new Error('Please enter a quantity greater than zero for at least one item');
  }

  for (const item of itemsToFulfil) {
    const line = order.lines.find((l) => l.id === item.lineId);
    if (!line) continue;
    const remaining = line.quantity - line.fulfilledQty;
    if (item.quantityToFulfil > remaining) {
      throw new Error(`Cannot fulfil more than ${remaining} remaining for ${line.productName}`);
    }
    line.fulfilledQty += item.quantityToFulfil;
  }

  const allFulfilled = order.lines.every((l) => l.fulfilledQty >= l.quantity);
  const anyFulfilled = order.lines.some((l) => l.fulfilledQty > 0);

  if (allFulfilled) {
    order.fulfilmentStatus = 'Fulfilled';
    order.status = order.paymentStatus === 'Paid' ? 'Completed' : 'Ready';
  } else if (anyFulfilled) {
    order.fulfilmentStatus = 'Partially Fulfilled';
    order.status = 'Processing';
  }

  const warehouse = MOCK_WAREHOUSES.find((w) => w.id === input.warehouseId);
  const fulfilmentRecord: FulfilmentRecord = {
    id: `ful-${Date.now()}`,
    fulfilmentNo: `FUL-${Math.floor(1000 + Math.random() * 9000)}`,
    orderId: order.id,
    createdAt: input.date || new Date().toISOString(),
    warehouseId: input.warehouseId,
    warehouseName: warehouse?.name || 'Central Warehouse',
    packedBy: input.packedBy,
    carrier: input.carrier,
    trackingNumber: input.trackingNumber,
    notes: input.notes,
    items: itemsToFulfil.map((item) => {
      const line = order.lines.find((l) => l.id === item.lineId);
      return {
        lineId: item.lineId,
        productId: item.productId,
        productName: line?.productName || 'Product',
        sku: line?.sku || '',
        quantity: item.quantityToFulfil,
      };
    }),
  };

  order.fulfilments = [fulfilmentRecord, ...(order.fulfilments || [])];
  order.updatedAt = new Date().toISOString();

  // Create inventory movements and decrement stock
  for (const item of itemsToFulfil) {
    const prod = mockShopProducts.find((p) => p.id === item.productId);
    if (prod) {
      prod.totalStock = Math.max(0, prod.totalStock - item.quantityToFulfil);
    }
    const stockLvl = MOCK_STOCK_LEVELS.find(
      (s) => s.productId === item.productId && s.locationId === input.warehouseId,
    );
    if (stockLvl) {
      stockLvl.onHand = Math.max(0, stockLvl.onHand - item.quantityToFulfil);
      stockLvl.available = Math.max(0, stockLvl.onHand - stockLvl.reserved);
    }
    MOCK_MOVEMENTS.unshift({
      id: `mov-${Date.now()}-${item.lineId}`,
      movementNo: `ISSUE-${Math.floor(1000 + Math.random() * 9000)}`,
      date: input.date || new Date().toISOString(),
      type: 'issue',
      productId: item.productId,
      productName: prod?.name || 'Product',
      fromLocationId: input.warehouseId,
      quantity: -item.quantityToFulfil,
      unitCost: prod?.price || 0,
      totalValue: (prod?.price || 0) * item.quantityToFulfil,
      balanceAfter: prod?.totalStock || 0,
      sourceDocument: { type: 'Order', id: order.id, ref: order.orderNumber },
      userId: 'usr-1',
      userName: input.packedBy,
    });
  }

  return { ...order };
};
