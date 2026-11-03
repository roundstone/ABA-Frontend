'use client';

import { Order } from '../types';
import { Button } from '@/components/ui/button';
import { Package, Truck, CheckCircle2 } from 'lucide-react';

interface OrderFulfilmentTabProps {
  order: Order;
  onFulfil?: () => void;
}

export function OrderFulfilmentTab({ order, onFulfil }: OrderFulfilmentTabProps) {
  const isFulfilled = order.fulfilmentStatus === 'Fulfilled';

  return (
    <div className="space-y-6">
      <div className="bg-surface rounded-xl border border-border p-6 flex flex-col md:flex-row items-center justify-between gap-4">
        <div>
          <h3 className="font-medium text-lg">
            Fulfilment Status:{' '}
            <span className={isFulfilled ? 'text-success' : 'text-warning-dark'}>
              {order.fulfilmentStatus}
            </span>
          </h3>
          <p className="text-sm text-text-muted mt-1">
            Track packing and delivery of order items across facilities.
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" disabled={isFulfilled} onClick={onFulfil}>
            Pack Items
          </Button>
          <Button
            variant={isFulfilled ? 'outline' : 'primary'}
            disabled={isFulfilled}
            onClick={onFulfil}
          >
            Fulfil Order
          </Button>
        </div>
      </div>

      {order.fulfilments && order.fulfilments.length > 0 && (
        <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
          <h4 className="font-medium text-base">Fulfilment Packages</h4>
          <div className="space-y-3">
            {order.fulfilments.map((f) => (
              <div key={f.id} className="p-4 rounded-lg border border-border bg-surface-2/40 space-y-2">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <div className="flex items-center gap-2">
                    <span className="font-mono text-xs font-semibold px-2 py-0.5 rounded bg-surface border border-border">
                      {f.fulfilmentNo}
                    </span>
                    <span className="text-xs text-text-muted">from {f.warehouseName}</span>
                  </div>
                  <span className="text-xs text-text-muted font-mono">
                    {new Date(f.createdAt).toLocaleString()}
                  </span>
                </div>
                <div className="text-xs text-text-muted">
                  Packed by: <span className="font-medium text-text">{f.packedBy}</span>
                  {f.carrier && (
                    <span> • Carrier: <span className="font-medium text-text">{f.carrier}</span></span>
                  )}
                  {f.trackingNumber && (
                    <span> • Tracking: <span className="font-mono font-medium text-text">{f.trackingNumber}</span></span>
                  )}
                </div>
                {f.notes && <p className="text-xs italic text-text-muted">{f.notes}</p>}
                <div className="pt-1">
                  <div className="text-xs font-medium mb-1">Items in this package:</div>
                  <ul className="text-xs space-y-1">
                    {f.items.map((it, idx) => (
                      <li key={idx} className="flex justify-between border-b border-border/50 py-1">
                        <span>{it.productName} ({it.sku})</span>
                        <span className="font-semibold text-success">x{it.quantity}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="relative border-l-2 border-border ml-4 space-y-8 pb-4">
        {isFulfilled && (
          <div className="relative pl-6">
            <div className="absolute w-6 h-6 bg-success text-white rounded-full flex items-center justify-center -left-[13px] top-0">
              <CheckCircle2 className="w-4 h-4" />
            </div>
            <div>
              <h4 className="font-medium">Delivered</h4>
              <p className="text-sm text-text-muted mt-0.5">Order was marked as delivered to the customer.</p>
              <p className="text-xs text-text-muted mt-1 font-mono">
                {new Date(order.updatedAt).toLocaleString()}
              </p>
            </div>
          </div>
        )}

        {(order.fulfilmentStatus === 'Fulfilled' || order.fulfilmentStatus === 'Partially Fulfilled') && (
          <div className="relative pl-6">
            <div className="absolute w-6 h-6 bg-primary/10 text-primary border border-primary/20 rounded-full flex items-center justify-center -left-[13px] top-0">
              <Truck className="w-3.5 h-3.5" />
            </div>
            <div>
              <h4 className="font-medium">Packed & Issued</h4>
              <p className="text-sm text-text-muted mt-0.5">Items were issued from warehouse stock.</p>
            </div>
          </div>
        )}

        <div className="relative pl-6">
          <div className="absolute w-6 h-6 bg-surface-2 text-text-muted border border-border rounded-full flex items-center justify-center -left-[13px] top-0">
            <Package className="w-3.5 h-3.5" />
          </div>
          <div>
            <h4 className="font-medium">Order Placed</h4>
            <p className="text-sm text-text-muted mt-0.5">Order was placed and stock was reserved.</p>
            <p className="text-xs text-text-muted mt-1 font-mono">
              {new Date(order.createdAt).toLocaleString()}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
