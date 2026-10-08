'use client';

import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { useQuery } from '@tanstack/react-query';
import { getReferralRecords } from '@/features/referrals/api';
import { Badge } from '@/components/ui/badge';
import { AmountText } from '@/components/patterns/AmountText';
import { useParams } from 'next/navigation';

export default function ReferralDetailPage() {
  const params = useParams();
  const id = params.id as string;
  
  const { data, isLoading } = useQuery({
    queryKey: ['referral', id],
    queryFn: () => getReferralRecords().then(res => res.data.find(r => r.id === id || r.referralNumber === id))
  });

  if (isLoading) return <div>Loading...</div>;
  if (!data) return <div>Referral not found</div>;

  return (
    <div className="space-y-6 pb-20 mx-auto max-w-5xl">
      <PageHeader 
        title={`Referral ${data.referralNumber}`} 
        description={`Referred by ${data.referrerName} (${data.referrerCode})`}
        backHref="/erp/referrals/records"
        action={
          <div className="flex gap-2">
            <Button variant="outline">View Referrer</Button>
            {data.status === 'Flagged' && <Button variant="outline" className="text-error border-error-muted hover:bg-error-light hover:text-error">Disqualify</Button>}
            {data.status === 'Flagged' && <Button variant="primary">Clear Flag & Qualify</Button>}
          </div>
        }
      />

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-2 space-y-6">
          <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Referral Overview</h3>
            
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-text-muted">Referred Customer</p>
                <p className="font-medium">{data.referredCustomerName}</p>
              </div>
              <div>
                <p className="text-sm text-text-muted">Status</p>
                <div className="flex items-center gap-1 mt-1">
                  <Badge variant="outline">{data.status}</Badge>
                  {data.flags > 0 && <span className="text-error text-xs ml-2">⚠️ {data.flags} Flags</span>}
                </div>
              </div>
              <div>
                <p className="text-sm text-text-muted">Source Channel</p>
                <p className="font-medium">{data.sourceChannel}</p>
              </div>
              <div>
                <p className="text-sm text-text-muted">Date Referred</p>
                <p className="font-medium">{new Date(data.dateReferred).toLocaleDateString()}</p>
              </div>
            </div>

            <div className="bg-surface-2 p-4 rounded-lg border border-border space-y-2 mt-4">
              <div className="flex justify-between">
                <span className="text-text-muted text-sm">First Order Value</span>
                <span className="font-medium">
                  {data.firstOrderValue ? <AmountText amountInKobo={data.firstOrderValue} /> : 'Pending'}
                </span>
              </div>
              <div className="flex justify-between font-bold text-success-dark">
                <span>Commission Generated</span>
                <span>
                  {data.commissionGenerated ? <AmountText amountInKobo={data.commissionGenerated} /> : 'N/A'}
                </span>
              </div>
            </div>
          </div>
          
          {/* Upline Chain would go here */}
          <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
             <h3 className="font-bold text-lg border-b border-border pb-2">Upline Chain</h3>
             <p className="text-sm text-text-muted">The upline hierarchy tracking back from this referral.</p>
             <div className="space-y-2">
               <div className="p-3 border border-border bg-surface-2 rounded-lg flex justify-between items-center">
                 <div>
                   <p className="font-medium text-sm">{data.referrerName}</p>
                   <p className="text-[10px] text-text-muted">Direct Referrer (Level 1)</p>
                 </div>
               </div>
             </div>
          </div>
        </div>

        <div className="space-y-6">
          <div className="bg-surface rounded-xl border border-border p-6 space-y-4">
            <h3 className="font-bold text-lg border-b border-border pb-2">Admin Actions</h3>
            <div className="space-y-3">
              <Button variant="outline" className="w-full justify-start">Reassign Upline</Button>
              <Button variant="outline" className="w-full justify-start">View Orders</Button>
              <Button variant="outline" className="w-full justify-start text-error hover:bg-error-light hover:text-error">Flag as Suspicious</Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
