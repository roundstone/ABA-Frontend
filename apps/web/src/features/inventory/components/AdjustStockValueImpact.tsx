'use client';

import React from 'react';
import { AmountText } from '@/components/patterns/AmountText';

interface AdjustStockValueImpactProps {
  currentStock: number;
  newStock: number;
  deltaQty: number;
  unitCost: number;
  unitOfMeasure: string;
  thresholdKobo?: number;
}

export function AdjustStockValueImpact({
  currentStock,
  newStock,
  deltaQty,
  unitCost,
  unitOfMeasure,
  thresholdKobo = 5000000, // ₦50,000 approval threshold
}: AdjustStockValueImpactProps) {
  const valueImpact = deltaQty * unitCost;
  const isGain = deltaQty > 0;
  const isLoss = deltaQty < 0;
  const requiresApproval = Math.abs(valueImpact) > thresholdKobo;

  return (
    <div className="rounded-xl border border-border bg-surface-2/40 p-4 space-y-3">
      <div className="flex items-center justify-between">
        <span className="text-xs font-semibold tracking-wider uppercase text-text-muted">
          Value & Ledger Impact
        </span>
        <span
          className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border ${
            requiresApproval
              ? 'bg-warning-bg text-warning-dark border-warning-border'
              : 'bg-success-bg text-success border-success-border'
          }`}
        >
          {requiresApproval ? 'Requires Approval' : 'Direct Post'}
        </span>
      </div>

      <div className="grid grid-cols-2 gap-3 pt-1 text-sm">
        <div>
          <span className="text-xs text-text-muted block">Stock Change</span>
          <span className="font-semibold text-text">
            {currentStock} → {newStock} {unitOfMeasure}
          </span>
          <span className={`text-xs ml-1 font-medium ${isGain ? 'text-success' : isLoss ? 'text-error' : 'text-text-muted'}`}>
            ({deltaQty > 0 ? `+${deltaQty}` : deltaQty} {unitOfMeasure})
          </span>
        </div>

        <div>
          <span className="text-xs text-text-muted block">Net Valuation Impact</span>
          <span className={`font-semibold flex items-center ${isGain ? 'text-success' : isLoss ? 'text-error' : 'text-text'}`}>
            {deltaQty < 0 && '−'}
            {deltaQty > 0 && '+'}
            <AmountText amountInKobo={Math.abs(valueImpact)} />
          </span>
        </div>
      </div>

      {requiresApproval ? (
        <div className="text-xs text-warning-dark bg-warning-bg/50 border border-warning-border rounded-lg p-2.5">
          <strong>Approval Notice:</strong> Adjustments exceeding{' '}
          <AmountText amountInKobo={thresholdKobo} /> require manager review before active stock is updated.
        </div>
      ) : (
        <p className="text-xs text-text-muted">
          This adjustment will immediately record an append-only stock movement and update on-hand balance.
        </p>
      )}
    </div>
  );
}

