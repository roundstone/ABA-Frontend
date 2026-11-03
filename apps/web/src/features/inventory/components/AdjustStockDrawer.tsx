'use client';

import React, { useState, useEffect } from 'react';
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetDescription,
  SheetFooter,
} from '@/components/ui/sheet';
import { Button } from '@/components/ui/button';
import { toast } from 'sonner';
import { Warehouse, AdjustmentReason } from '../types';
import { ProductVariant } from '@/features/products/types';
import { getWarehouses, adjustProductStock } from '../api/inventory.api';
import { AdjustStockValueImpact } from './AdjustStockValueImpact';
import { AdjustStockFormFields } from './AdjustStockFormFields';

export interface AdjustStockDrawerProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  product: {
    id: string;
    name: string;
    sku: string;
    categoryName: string;
    unitOfMeasure: string;
    price: number;
    totalStock: number;
    hasVariants?: boolean;
    variants?: ProductVariant[];
  };
  onSuccess?: () => void;
}

export function AdjustStockDrawer({
  open,
  onOpenChange,
  product,
  onSuccess,
}: AdjustStockDrawerProps) {
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [locationId, setLocationId] = useState<string>('');
  const [selectedVariantId, setSelectedVariantId] = useState<string>('');
  const [mode, setMode] = useState<'delta' | 'absolute'>('delta');
  const [deltaQty, setDeltaQty] = useState<number>(-1);
  const [newQty, setNewQty] = useState<number>(0);
  const [reason, setReason] = useState<AdjustmentReason>('Damage');
  const [date, setDate] = useState<string>(new Date().toISOString().slice(0, 10));
  const [unitCost, setUnitCost] = useState<number>(product.price);
  const [notes, setNotes] = useState<string>('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    getWarehouses().then((data) => {
      setWarehouses(data);
      if (data.length > 0 && !locationId) {
        setLocationId(data[0].id);
      }
    });
  }, []);

  useEffect(() => {
    if (product.hasVariants && product.variants?.length) {
      const firstVar = product.variants[0];
      setSelectedVariantId(firstVar.id);
      setUnitCost(firstVar.cost || product.price);
      setNewQty(Math.max(0, (firstVar.stockCount ?? 0) - 1));
    } else {
      setUnitCost(product.price);
      setNewQty(Math.max(0, product.totalStock - 1));
    }
    setDeltaQty(-1);
    setReason('Damage');
  }, [product, open]);

  const selectedVariant = product.variants?.find((v) => v.id === selectedVariantId);
  const currentStock = selectedVariant ? (selectedVariant.stockCount ?? 0) : product.totalStock;

  const effectiveDelta = mode === 'absolute' ? newQty - currentStock : deltaQty;
  const effectiveNewStock = Math.max(0, currentStock + effectiveDelta);

  const handleVariantChange = (vId: string) => {
    setSelectedVariantId(vId);
    const v = product.variants?.find((item) => item.id === vId);
    if (v) {
      setUnitCost(v.cost || product.price);
      if (mode === 'absolute') setNewQty(v.stockCount ?? 0);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!locationId) {
      toast.error('Please select a warehouse location');
      return;
    }
    if (effectiveDelta === 0) {
      toast.error('Adjustment quantity must result in a change');
      return;
    }
    if (currentStock + effectiveDelta < 0) {
      toast.error('Stock cannot become negative');
      return;
    }

    setIsSubmitting(true);
    try {
      const result = await adjustProductStock({
        productId: product.id,
        variantId: selectedVariantId || undefined,
        locationId,
        mode,
        deltaQty: effectiveDelta,
        newQty: effectiveNewStock,
        reason,
        unitCost,
        date,
        notes: notes.trim() || undefined,
      });

      if (result.status === 'Awaiting Approval') {
        toast.info(result.message || 'Submitted for manager approval');
      } else {
        toast.success(`Stock adjusted successfully. New on-hand: ${result.newStock}`);
      }

      onOpenChange(false);
      onSuccess?.();
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Failed to adjust stock';
      toast.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="w-full gap-0 p-0 sm:max-w-[480px]">
        <SheetHeader className="gap-1 border-b border-border px-6 py-5 pr-14">
          <SheetTitle className="text-lg font-semibold tracking-tight">Adjust Stock</SheetTitle>
          <SheetDescription className="text-xs text-text-muted">
            {product.name} ({product.sku}) • {product.categoryName}
          </SheetDescription>
        </SheetHeader>

        <form onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-6 space-y-5">
          <AdjustStockFormFields
            productId={product.id}
            unitOfMeasure={product.unitOfMeasure}
            hasVariants={product.hasVariants}
            variants={product.variants}
            warehouses={warehouses}
            locationId={locationId}
            onLocationChange={setLocationId}
            selectedVariantId={selectedVariantId}
            onVariantChange={handleVariantChange}
            mode={mode}
            onModeChange={setMode}
            deltaQty={deltaQty}
            onDeltaQtyChange={setDeltaQty}
            newQty={newQty}
            onNewQtyChange={setNewQty}
            currentStock={currentStock}
            reason={reason}
            onReasonChange={setReason}
            date={date}
            onDateChange={setDate}
            notes={notes}
            onNotesChange={setNotes}
          />

          <AdjustStockValueImpact
            currentStock={currentStock}
            newStock={effectiveNewStock}
            deltaQty={effectiveDelta}
            unitCost={unitCost}
            unitOfMeasure={product.unitOfMeasure}
          />

          <SheetFooter className="mt-6 flex flex-row justify-end gap-2 border-t border-border pt-4">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => onOpenChange(false)}
              disabled={isSubmitting}
            >
              Cancel
            </Button>
            <Button type="submit" size="sm" disabled={isSubmitting || effectiveDelta === 0}>
              {isSubmitting ? 'Posting...' : 'Submit Adjustment'}
            </Button>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}
