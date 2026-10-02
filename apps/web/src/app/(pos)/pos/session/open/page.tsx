'use client';

import { useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { openSession } from '@/features/pos/api/pos.api';
import { toast } from 'sonner';

import { Suspense } from 'react';

function OpenSessionContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const registerId = searchParams.get('register') || 'reg-1';

  const [floatAmount, setFloatAmount] = useState<string>('');
  const [notes, setNotes] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleOpenSession = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!floatAmount || isNaN(Number(floatAmount))) {
      toast.error('Please enter a valid float amount');
      return;
    }

    setIsSubmitting(true);
    try {
      const amountInKobo = Math.round(Number(floatAmount) * 100);
      await openSession(registerId, amountInKobo, notes);
      toast.success('Session opened successfully');
      router.push('/pos/sell');
    } catch (err) {
      toast.error('Failed to open session');
      setIsSubmitting(false);
    }
  };

  return (
    <div className="flex-1 flex items-center justify-center bg-bg p-6">
      <div className="max-w-md w-full bg-surface rounded-2xl border border-border shadow-sm p-8 space-y-8">
        
        <div className="space-y-2 text-center">
          <h1 className="text-2xl font-semibold">Open Register Session</h1>
          <p className="text-text-muted text-sm">Verify the cash in the drawer to start selling.</p>
        </div>

        <form onSubmit={handleOpenSession} className="space-y-6">
          
          <div className="space-y-2">
            <label className="text-sm font-medium">Opening Cash Float (₦) <span className="text-error">*</span></label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted font-medium">₦</span>
              <Input 
                type="number" 
                className="pl-8 text-lg h-12 font-mono font-medium" 
                placeholder="0.00" 
                value={floatAmount}
                onChange={(e) => setFloatAmount(e.target.value)}
                autoFocus
              />
            </div>
            <p className="text-xs text-text-muted">Count the physical cash currently in the drawer.</p>
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium">Notes (Optional)</label>
            <Input 
              placeholder="e.g. Received extra change from manager" 
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
            />
          </div>

          <div className="pt-4 flex gap-3">
            <Button type="button" variant="outline" className="flex-1" onClick={() => router.push('/pos')} disabled={isSubmitting}>
              Cancel
            </Button>
            <Button type="submit" className="flex-[2]" disabled={isSubmitting}>
              {isSubmitting ? 'Opening...' : 'Open Session & Start'}
            </Button>
          </div>

        </form>
      </div>
    </div>
  );
}

export default function OpenSessionPage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <OpenSessionContent />
    </Suspense>
  );
}
