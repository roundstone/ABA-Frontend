'use client';

import React from 'react';
import Link from 'next/link';
import { Input } from '@/components/ui/input';
import { Warehouse, AdjustmentReason } from '../types';
import { ProductVariant } from '@/features/products/types';

const REASONS: AdjustmentReason[] = [
  'Damage',
  'Expiry',
  'Theft/Loss',
  'Count correction',
  'Found stock',
  'Opening balance',
  'Other',
];

interface AdjustStockFormFieldsProps {
  productId: string;
  unitOfMeasure: string;
  hasVariants?: boolean;
  variants?: ProductVariant[];
  warehouses: Warehouse[];
  locationId: string;
  onLocationChange: (val: string) => void;
  selectedVariantId: string;
  onVariantChange: (val: string) => void;
  mode: 'delta' | 'absolute';
  onModeChange: (val: 'delta' | 'absolute') => void;
  deltaQty: number;
  onDeltaQtyChange: (val: number) => void;
  newQty: number;
  onNewQtyChange: (val: number) => void;
  currentStock: number;
  reason: AdjustmentReason;
  onReasonChange: (val: AdjustmentReason) => void;
  date: string;
  onDateChange: (val: string) => void;
  notes: string;
  onNotesChange: (val: string) => void;
}

export function AdjustStockFormFields({
  productId,
  unitOfMeasure,
  hasVariants,
  variants,
  warehouses,
  locationId,
  onLocationChange,
  selectedVariantId,
  onVariantChange,
  mode,
  onModeChange,
  deltaQty,
  onDeltaQtyChange,
  newQty,
  onNewQtyChange,
  currentStock,
  reason,
  onReasonChange,
  date,
  onDateChange,
  notes,
  onNotesChange,
}: AdjustStockFormFieldsProps) {
  return (
    <div className="space-y-5">
      <div className="space-y-1.5">
        <label className="text-xs font-medium">Warehouse / Location *</label>
        <select
          value={locationId}
          onChange={(e) => onLocationChange(e.target.value)}
          className="w-full h-9 rounded-md border border-border bg-surface px-3 py-1.5 text-sm"
          required
        >
          {warehouses.map((w) => (
            <option key={w.id} value={w.id}>
              {w.name} ({w.type})
            </option>
          ))}
        </select>
      </div>

      {hasVariants && variants && variants.length > 0 && (
        <div className="space-y-1.5">
          <label className="text-xs font-medium">Product Variant *</label>
          <select
            value={selectedVariantId}
            onChange={(e) => onVariantChange(e.target.value)}
            className="w-full h-9 rounded-md border border-border bg-surface px-3 py-1.5 text-sm"
          >
            {variants.map((v) => (
              <option key={v.id} value={v.id}>
                {v.name} ({v.sku}) — Stock: {v.stockCount ?? 0}
              </option>
            ))}
          </select>
        </div>
      )}

      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <label className="text-xs font-medium">Adjustment Method</label>
          <div className="flex gap-1 text-xs bg-surface-2 p-0.5 rounded-md border border-border">
            <button
              type="button"
              onClick={() => onModeChange('delta')}
              className={`px-2.5 py-1 rounded transition-colors ${
                mode === 'delta'
                  ? 'bg-surface text-text font-medium shadow-sm'
                  : 'text-text-muted'
              }`}
            >
              Relative (±)
            </button>
            <button
              type="button"
              onClick={() => onModeChange('absolute')}
              className={`px-2.5 py-1 rounded transition-colors ${
                mode === 'absolute'
                  ? 'bg-surface text-text font-medium shadow-sm'
                  : 'text-text-muted'
              }`}
            >
              Set New Quantity
            </button>
          </div>
        </div>

        {mode === 'delta' ? (
          <div className="space-y-1">
            <Input
              type="number"
              value={deltaQty}
              onChange={(e) => onDeltaQtyChange(Number(e.target.value))}
              placeholder="e.g. -2 for shrinkage, +5 for found"
              className="font-mono text-sm"
              required
            />
            <span className="text-xs text-text-muted">
              Use negative values for shrinkage/loss, positive for found items.
            </span>
          </div>
        ) : (
          <div className="space-y-1">
            <Input
              type="number"
              min="0"
              value={newQty}
              onChange={(e) => onNewQtyChange(Math.max(0, Number(e.target.value)))}
              className="font-mono text-sm"
              required
            />
            <span className="text-xs text-text-muted">
              Current on-hand: {currentStock} {unitOfMeasure}
            </span>
          </div>
        )}
      </div>

      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1.5">
          <label className="text-xs font-medium">Reason *</label>
          <select
            value={reason}
            onChange={(e) => onReasonChange(e.target.value as AdjustmentReason)}
            className="w-full h-9 rounded-md border border-border bg-surface px-2.5 py-1.5 text-sm"
            required
          >
            {REASONS.map((r) => (
              <option key={r} value={r}>
                {r}
              </option>
            ))}
          </select>
        </div>

        <div className="space-y-1.5">
          <label className="text-xs font-medium">Effective Date</label>
          <Input
            type="date"
            value={date}
            onChange={(e) => onDateChange(e.target.value)}
            className="h-9 text-xs"
            required
          />
        </div>
      </div>

      <div className="space-y-1.5">
        <label className="text-xs font-medium">Audit Notes / Explanation</label>
        <Input
          value={notes}
          onChange={(e) => onNotesChange(e.target.value)}
          placeholder="e.g. Physical count discrepancy, damage..."
          className="text-xs"
        />
      </div>

      <div className="pt-1 text-center">
        <Link
          href={`/erp/inventory/adjustments/new?productId=${productId}`}
          className="text-xs text-primary hover:underline"
        >
          Need to adjust multiple products? Open batch adjustment →
        </Link>
      </div>
    </div>
  );
}

