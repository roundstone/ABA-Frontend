import { Order } from '../types';
import { Button } from '@/components/ui/button';
import { AlertCircle } from 'lucide-react';

interface OrderReturnsTabProps {
  order: Order;
}

export function OrderReturnsTab({ order }: OrderReturnsTabProps) {
  // Mock returns data
  const hasReturns = false;
  
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="font-medium text-lg">Returns & Refunds</h3>
          <p className="text-sm text-text-muted">Manage item returns and initiate refunds.</p>
        </div>
        <Button variant="outline" className="text-error border-error/20 hover:bg-error/5 hover:text-error">
          Create Return
        </Button>
      </div>
      
      {!hasReturns ? (
        <div className="bg-surface rounded-xl border border-border p-12 flex flex-col items-center justify-center text-center">
          <div className="w-12 h-12 bg-surface-2 rounded-full flex items-center justify-center mb-4 border border-border text-text-muted">
            <AlertCircle className="w-6 h-6 opacity-50" />
          </div>
          <h4 className="font-medium text-lg">No Returns</h4>
          <p className="text-text-muted text-sm mt-1 max-w-md">
            There are no return requests or refunds logged for this order. 
            Click "Create Return" to initiate one if a customer brings items back.
          </p>
        </div>
      ) : (
        <div className="bg-surface rounded-xl border border-border overflow-hidden">
          {/* We would render return list here */}
        </div>
      )}
    </div>
  );
}
