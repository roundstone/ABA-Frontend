'use client';

import React from 'react';
import { OrderLine } from '../types';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

interface FulfilOrderItemsTableProps {
  lines: OrderLine[];
  quantities: Record<string, number>;
  onQuantityChange: (lineId: string, qty: number) => void;
  onFillAllRemaining: () => void;
}

export function FulfilOrderItemsTable({
  lines,
  quantities,
  onQuantityChange,
  onFillAllRemaining,
}: FulfilOrderItemsTableProps) {
  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <div>
          <label className="text-xs font-semibold uppercase tracking-wider text-text-muted">
            Items to Fulfil
          </label>
          <p className="text-xs text-text-muted">Enter quantity to pack per item</p>
        </div>
        <Button
          type="button"
          variant="outline"
          size="sm"
          className="text-xs h-7"
          onClick={onFillAllRemaining}
        >
          Fill All Remaining
        </Button>
      </div>

      <div className="rounded-xl border border-border bg-surface overflow-x-auto">
        <table className="w-full text-xs text-left">
          <thead className="bg-surface-2 text-text-muted border-b border-border">
            <tr>
              <th className="px-3 py-2.5 font-medium">Product</th>
              <th className="px-2 py-2.5 font-medium text-center">Ordered</th>
              <th className="px-2 py-2.5 font-medium text-center">Fulfilled</th>
              <th className="px-2 py-2.5 font-medium text-center">Remaining</th>
              <th className="px-3 py-2.5 font-medium text-right w-24">Pack Qty</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-border">
            {lines.map((line) => {
              const remaining = Math.max(0, line.quantity - line.fulfilledQty);
              const currentVal = quantities[line.id] ?? remaining;
              const isComplete = remaining === 0;

              return (
                <tr key={line.id} className={isComplete ? 'opacity-60 bg-surface-2/20' : ''}>
                  <td className="px-3 py-2.5">
                    <div className="font-medium text-text">{line.productName}</div>
                    <div className="text-[11px] text-text-muted font-mono">{line.sku}</div>
                  </td>
                  <td className="px-2 py-2.5 text-center font-medium">{line.quantity}</td>
                  <td className="px-2 py-2.5 text-center text-text-muted">{line.fulfilledQty}</td>
                  <td className="px-2 py-2.5 text-center font-semibold">
                    <span className={remaining > 0 ? 'text-primary' : 'text-success'}>
                      {remaining}
                    </span>
                  </td>
                  <td className="px-3 py-2.5 text-right">
                    {isComplete ? (
                      <span className="text-[11px] text-success font-medium">Done</span>
                    ) : (
                      <Input
                        type="number"
                        min="0"
                        max={remaining}
                        value={currentVal}
                        onChange={(e) => {
                          const val = Math.max(0, Math.min(remaining, Number(e.target.value) || 0));
                          onQuantityChange(line.id, val);
                        }}
                        className="h-8 w-20 text-right font-mono text-xs ml-auto"
                      />
                    )}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}

