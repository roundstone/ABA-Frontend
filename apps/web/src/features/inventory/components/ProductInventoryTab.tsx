'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { AmountText } from '@/components/patterns/AmountText';
import { Button } from '@/components/ui/button';
import { Product } from '@/features/products/types';
import { StockLevel, StockMovement } from '../types';
import { getStockByProductId, getMovementsByProductId } from '../api/inventory.api';

interface ProductInventoryTabProps {
  product: Product;
  onAdjustStock: () => void;
}

export function ProductInventoryTab({ product, onAdjustStock }: ProductInventoryTabProps) {
  const [stockLevels, setStockLevels] = useState<StockLevel[]>([]);
  const [movements, setMovements] = useState<StockMovement[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    setIsLoading(true);
    Promise.all([
      getStockByProductId(product.id),
      getMovementsByProductId(product.id),
    ])
      .then(([stockData, movementsData]) => {
        setStockLevels(stockData);
        setMovements(movementsData);
      })
      .finally(() => setIsLoading(false));
  }, [product.id, product.totalStock]);

  if (isLoading) {
    return <div className="p-8 text-center text-text-muted">Loading inventory data...</div>;
  }

  return (
    <div className="space-y-6">
      {/* Stock by Warehouse */}
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="px-6 py-4 border-b border-border flex items-center justify-between">
          <div>
            <h3 className="font-medium text-base">Stock by Location</h3>
            <p className="text-xs text-text-muted">On-hand and available quantities across all facilities</p>
          </div>
          <Button size="sm" variant="outline" onClick={onAdjustStock}>
            Adjust Stock
          </Button>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="bg-surface-2/60 text-xs text-text-muted border-b border-border">
              <tr>
                <th className="px-6 py-3 font-medium">Warehouse</th>
                <th className="px-6 py-3 font-medium text-right">On Hand</th>
                <th className="px-6 py-3 font-medium text-right">Reserved</th>
                <th className="px-6 py-3 font-medium text-right">Available</th>
                <th className="px-6 py-3 font-medium text-right">Reorder Level</th>
                <th className="px-6 py-3 font-medium text-right">Valuation</th>
                <th className="px-6 py-3 font-medium text-right">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {stockLevels.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-6 py-8 text-center text-text-muted">
                    No warehouse inventory recorded yet.
                  </td>
                </tr>
              ) : (
                stockLevels.map((lvl) => (
                  <tr key={lvl.id} className="hover:bg-surface-2/30">
                    <td className="px-6 py-3">
                      <div className="font-medium">{lvl.locationName}</div>
                      <div className="text-xs text-text-muted">{lvl.sku}</div>
                    </td>
                    <td className="px-6 py-3 text-right font-semibold">{lvl.onHand}</td>
                    <td className="px-6 py-3 text-right text-text-muted">{lvl.reserved}</td>
                    <td className="px-6 py-3 text-right text-success font-medium">{lvl.available}</td>
                    <td className="px-6 py-3 text-right text-text-muted">{lvl.reorderLevel}</td>
                    <td className="px-6 py-3 text-right font-medium">
                      <AmountText amountInKobo={lvl.totalValue} />
                    </td>
                    <td className="px-6 py-3 text-right">
                      <Button variant="ghost" size="sm" className="text-xs h-7" onClick={onAdjustStock}>
                        Adjust
                      </Button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Recent Movements */}
      <div className="bg-surface rounded-xl border border-border overflow-hidden">
        <div className="px-6 py-4 border-b border-border flex items-center justify-between">
          <div>
            <h3 className="font-medium text-base">Recent Movements</h3>
            <p className="text-xs text-text-muted">Append-only audit ledger of stock ins, outs, and adjustments</p>
          </div>
          <Link href="/erp/inventory/movements" className="text-xs text-primary hover:underline">
            View full ledger →
          </Link>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-sm text-left">
            <thead className="bg-surface-2/60 text-xs text-text-muted border-b border-border">
              <tr>
                <th className="px-6 py-3 font-medium">Date</th>
                <th className="px-6 py-3 font-medium">Movement No</th>
                <th className="px-6 py-3 font-medium">Type</th>
                <th className="px-6 py-3 font-medium text-right">Quantity</th>
                <th className="px-6 py-3 font-medium text-right">Unit Cost</th>
                <th className="px-6 py-3 font-medium text-right">Value</th>
                <th className="px-6 py-3 font-medium">Source Ref</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {movements.length === 0 ? (
                <tr>
                  <td colSpan={7} className="px-6 py-8 text-center text-text-muted">
                    No movements recorded for this product yet.
                  </td>
                </tr>
              ) : (
                movements.map((m) => (
                  <tr key={m.id} className="hover:bg-surface-2/30">
                    <td className="px-6 py-3 text-xs text-text-muted">
                      {new Date(m.date).toLocaleDateString()}
                    </td>
                    <td className="px-6 py-3 font-mono text-xs font-medium">{m.movementNo}</td>
                    <td className="px-6 py-3">
                      <span className="capitalize text-xs px-2 py-0.5 rounded bg-surface-2 border border-border">
                        {m.type.replace('_', ' ')}
                      </span>
                    </td>
                    <td className={`px-6 py-3 text-right font-medium ${m.quantity > 0 ? 'text-success' : 'text-error'}`}>
                      {m.quantity > 0 ? `+${m.quantity}` : m.quantity}
                    </td>
                    <td className="px-6 py-3 text-right text-xs">
                      <AmountText amountInKobo={m.unitCost} />
                    </td>
                    <td className="px-6 py-3 text-right font-medium text-xs">
                      <AmountText amountInKobo={m.totalValue} />
                    </td>
                    <td className="px-6 py-3 text-xs">
                      <span className="font-mono">{m.sourceDocument.ref}</span>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

