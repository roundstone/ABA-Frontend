'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { AmountText } from '@/components/patterns/AmountText';
import { toast } from 'sonner';

export default function CloseSessionPage() {
  const router = useRouter();

  // Mock expected session data from backend
  const expectedCashInKobo = 2500000; // Expected to have 25,000 NGN cash in drawer
  
  const [countedAmount, setCountedAmount] = useState<string>('');
  const [notes, setNotes] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const [showVariance, setShowVariance] = useState(false);

  const countedInKobo = Math.round(Number(countedAmount || 0) * 100);
  const variance = countedInKobo - expectedCashInKobo;

  const handleVerify = (e: React.FormEvent) => {
    e.preventDefault();
    if (!countedAmount || isNaN(Number(countedAmount))) {
      toast.error('Please enter a valid count');
      return;
    }
    setShowVariance(true);
  };

  const handleCloseSession = async () => {
    setIsSubmitting(true);
    try {
      await new Promise(res => setTimeout(res, 1000));
      toast.success('Session closed successfully');
      router.push('/pos');
    } catch (err) {
      toast.error('Failed to close session');
      setIsSubmitting(false);
    }
  };

  return (
    <div className="flex-1 flex items-center justify-center bg-bg p-6">
      <div className="max-w-md w-full bg-surface rounded-2xl border border-border shadow-sm p-8 space-y-8">
        
        <div className="space-y-2 text-center">
          <h1 className="text-2xl font-semibold text-error">Close Register Session</h1>
          <p className="text-text-muted text-sm">Perform your end-of-day cash count.</p>
        </div>

        {!showVariance ? (
          <form onSubmit={handleVerify} className="space-y-6">
            <div className="space-y-2">
              <label className="text-sm font-medium">Physical Cash Count (₦) <span className="text-error">*</span></label>
              <div className="relative">
                <span className="absolute left-3 top-1/2 -translate-y-1/2 text-text-muted font-medium">₦</span>
                <Input 
                  type="number" 
                  className="pl-8 text-lg h-12 font-mono font-medium" 
                  placeholder="0.00" 
                  value={countedAmount}
                  onChange={(e) => setCountedAmount(e.target.value)}
                  autoFocus
                />
              </div>
              <p className="text-xs text-text-muted">Count the physical cash currently in the drawer. Do not include card or transfer totals.</p>
            </div>

            <Button type="submit" className="w-full h-12 text-lg">
              Verify Count
            </Button>
            <Button type="button" variant="ghost" className="w-full" onClick={() => router.push('/pos/sell')}>
              Cancel & Return to POS
            </Button>
          </form>
        ) : (
          <div className="space-y-6 animate-fade-in">
            
            <div className="bg-surface-2 p-6 rounded-xl border border-border space-y-4">
              <div className="flex justify-between items-center text-sm">
                <span className="text-text-muted">Expected Cash</span>
                <span className="font-mono font-medium"><AmountText amountInKobo={expectedCashInKobo} /></span>
              </div>
              <div className="flex justify-between items-center text-sm">
                <span className="text-text-muted">Counted Cash</span>
                <span className="font-mono font-medium"><AmountText amountInKobo={countedInKobo} /></span>
              </div>
              
              <div className={`pt-4 border-t border-border flex justify-between items-center font-bold text-lg ${variance === 0 ? 'text-success' : 'text-error'}`}>
                <span>Variance</span>
                <span>
                  {variance > 0 ? '+' : ''}<AmountText amountInKobo={variance} />
                </span>
              </div>
            </div>

            {variance !== 0 && (
              <div className="space-y-2 p-4 bg-error-bg border border-error-border rounded-lg text-sm">
                <p className="font-medium text-error">Variance Detected!</p>
                <p className="text-text-muted">You are {variance > 0 ? 'over' : 'short'} by <AmountText amountInKobo={Math.abs(variance)} />. Please double-check your count or provide a reason below.</p>
                <Input 
                  placeholder="Explain variance..." 
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  className="mt-2 bg-surface"
                />
              </div>
            )}

            <div className="pt-2 flex gap-3 flex-col">
              <Button type="button" onClick={handleCloseSession} disabled={isSubmitting || (variance !== 0 && notes.length < 5)} className="w-full h-12 text-lg">
                {isSubmitting ? 'Closing...' : 'Confirm & Close Register'}
              </Button>
              <Button type="button" variant="outline" className="w-full" onClick={() => setShowVariance(false)} disabled={isSubmitting}>
                Recount Cash
              </Button>
            </div>
          </div>
        )}

      </div>
    </div>
  );
}
