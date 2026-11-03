'use client';

import React, { useState, useEffect } from 'react';
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription, SheetFooter } from '@/components/ui/sheet';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';
import { Order } from '../types';
import { fulfilOrder } from '../api/sales.api';
import { getWarehouses } from '@/features/inventory/api/inventory.api';
import { Warehouse } from '@/features/inventory/types';
import { FulfilOrderItemsTable } from './FulfilOrderItemsTable';

interface FulfilOrderDrawerProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  order: Order;
  onSuccess?: () => void;
}

export function FulfilOrderDrawer({
  open,
  onOpenChange,
  order,
  onSuccess,
}: FulfilOrderDrawerProps) {
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [warehouseId, setWarehouseId] = useState<string>('');
  const [packedBy, setPackedBy] = useState<string>('Warehouse Officer');
  const [date, setDate] = useState<string>(new Date().toISOString().slice(0, 10));
  const [carrier, setCarrier] = useState<string>('');
  const [trackingNumber, setTrackingNumber] = useState<string>('');
  const [notes, setNotes] = useState<string>('');
  const [quantities, setQuantities] = useState<Record<string, number>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    getWarehouses().then((data) => {
      setWarehouses(data);
      if (data.length > 0 && !warehouseId) setWarehouseId(data[0].id);
    });
  }, []);

  useEffect(() => {
    const initial: Record<string, number> = {};
    order.lines.forEach((l) => {
      initial[l.id] = Math.max(0, l.quantity - l.fulfilledQty);
    });
    setQuantities(initial);
  }, [order, open]);

  const handleFillAllRemaining = () => {
    const updated: Record<string, number> = {};
    order.lines.forEach((l) => {
      updated[l.id] = Math.max(0, l.quantity - l.fulfilledQty);
    });
    setQuantities(updated);
  };

  const totalPackingNow = Object.values(quantities).reduce((acc, q) => acc + (q || 0), 0);
  const totalRemainingBefore = order.lines.reduce(
    (acc, l) => acc + Math.max(0, l.quantity - l.fulfilledQty),
    0,
  );
  const isFullFulfilment = totalPackingNow > 0 && totalPackingNow === totalRemainingBefore;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!warehouseId) {
      toast.error('Please select an issue warehouse');
      return;
    }
    if (totalPackingNow <= 0) {
      toast.error('Please enter a pack quantity greater than 0 for at least one item');
      return;
    }

    setIsSubmitting(true);
    try {
      const items = order.lines
        .map((l) => ({
          lineId: l.id,
          productId: l.productId,
          quantityToFulfil: quantities[l.id] || 0,
        }))
        .filter((i) => i.quantityToFulfil > 0);

      await fulfilOrder({
        orderId: order.id,
        warehouseId,
        packedBy,
        date,
        carrier: carrier.trim() || undefined,
        trackingNumber: trackingNumber.trim() || undefined,
        notes: notes.trim() || undefined,
        items,
      });

      toast.success(
        isFullFulfilment
          ? `Order ${order.orderNumber} fully fulfilled!`
          : `Order ${order.orderNumber} partially fulfilled (${totalPackingNow} items packed).`,
      );
      onOpenChange(false);
      onSuccess?.();
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Failed to fulfil order';
      toast.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="w-full gap-0 p-0 sm:max-w-[500px]">
        <SheetHeader className="gap-1 border-b border-border px-6 py-5 pr-14">
          <SheetTitle className="text-lg font-semibold tracking-tight">
            Fulfil Order {order.orderNumber}
          </SheetTitle>
          <SheetDescription className="text-xs text-text-muted">
            Customer: {order.customerName} • {order.deliveryMethod} ({order.channel})
          </SheetDescription>
        </SheetHeader>

        <form onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-6 space-y-5">
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <label className="text-xs font-medium">Issue Warehouse *</label>
              <select
                value={warehouseId}
                onChange={(e) => setWarehouseId(e.target.value)}
                className="w-full h-9 rounded-md border border-border bg-surface px-2.5 py-1.5 text-sm"
                required
              >
                {warehouses.map((w) => (
                  <option key={w.id} value={w.id}>{w.name}</option>
                ))}
              </select>
            </div>
            <div className="space-y-1.5">
              <label className="text-xs font-medium">Packed By *</label>
              <Input
                value={packedBy}
                onChange={(e) => setPackedBy(e.target.value)}
                className="h-9 text-xs"
                placeholder="Staff name"
                required
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <label className="text-xs font-medium">Carrier / Rider</label>
              <Input
                value={carrier}
                onChange={(e) => setCarrier(e.target.value)}
                placeholder="e.g. GIG Logistics, Dispatch"
                className="h-9 text-xs"
              />
            </div>
            <div className="space-y-1.5">
              <label className="text-xs font-medium">Tracking / Waybill No</label>
              <Input
                value={trackingNumber}
                onChange={(e) => setTrackingNumber(e.target.value)}
                placeholder="e.g. TRK-98124"
                className="h-9 text-xs"
              />
            </div>
          </div>

          <FulfilOrderItemsTable
            lines={order.lines}
            quantities={quantities}
            onQuantityChange={(lineId, val) => setQuantities((prev) => ({ ...prev, [lineId]: val }))}
            onFillAllRemaining={handleFillAllRemaining}
          />

          <div className="rounded-xl border border-border bg-surface-2/40 p-4 space-y-2">
            <div className="flex items-center justify-between text-xs">
              <span className="font-medium text-text-muted">Fulfilment Plan:</span>
              <span className={`px-2 py-0.5 rounded text-xs font-medium border ${
                isFullFulfilment ? 'bg-success-bg text-success border-success-border' :
                totalPackingNow > 0 ? 'bg-warning-bg text-warning-dark border-warning-border' :
                'bg-surface-2 text-text-muted border-border'
              }`}>
                {isFullFulfilment ? 'Full Fulfilment' : totalPackingNow > 0 ? 'Partial Fulfilment' : 'No items selected'}
              </span>
            </div>
            <p className="text-xs text-text-muted">
              Packing <strong>{totalPackingNow}</strong> of <strong>{totalRemainingBefore}</strong> remaining units.
              Stock will be decremented and logged in inventory movements.
            </p>
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-medium">Packing Notes</label>
            <Input
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="e.g. Package inspected, sealed with security tape..."
              className="text-xs"
            />
          </div>

          <SheetFooter className="mt-6 flex flex-row justify-end gap-2 border-t border-border pt-4">
            <Button type="button" variant="outline" size="sm" onClick={() => onOpenChange(false)} disabled={isSubmitting}>
              Cancel
            </Button>
            <Button type="submit" size="sm" disabled={isSubmitting || totalPackingNow <= 0}>
              {isSubmitting ? 'Packing...' : `Fulfil ${totalPackingNow} Items`}
            </Button>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}
