'use client';

import { useParams } from 'next/navigation';
import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';
import { AmountText } from '@/components/patterns/AmountText';

export default function PayoutDetailPage() {
  const params = useParams();
  const id = params.id as string;

  return (
    <div className="space-y-6 pb-20 pt-4 max-w-5xl mx-auto">
      <div className="flex items-center justify-between">
        <div>
          <div className="flex items-center gap-3 mb-1">
            <h1 className="text-h3 font-mono">{id || 'PYT-4029'}</h1>
            <span className="bg-warning-bg text-warning-dark border-warning-border border px-2 py-0.5 rounded text-xs font-medium">
              Pending Approval
            </span>
          </div>
          <p className="text-sm text-text-muted">Requested on Sept 30, 2026 at 08:14 AM</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" className="text-error border-error hover:bg-error-bg">Reject</Button>
          <Button className="bg-success hover:bg-success-dark text-white">Approve & Process</Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">

        {/* Left Col */}
        <div className="md:col-span-2 space-y-6">
          <div className="bg-surface rounded-xl border border-border p-6 flex justify-between items-center">
            <div>
              <p className="text-text-muted text-sm mb-1">Net Transfer Amount</p>
              <p className="text-4xl font-bold"><AmountText amountInKobo={14995000} /></p>
            </div>
            <div className="text-right text-sm">
              <p className="text-text-muted mb-1">Gross: <AmountText amountInKobo={15000000} /></p>
              <p className="text-text-muted">Fee: -<AmountText amountInKobo={5000} /></p>
            </div>
          </div>

          <div className="bg-surface rounded-xl border border-border p-6">
            <h3 className="font-medium mb-4">Risk & Fraud Checks</h3>
            <div className="space-y-3">
              <div className="flex items-start gap-3 p-3 rounded-lg bg-error-bg border border-error-border">
                <span className="text-error mt-0.5">⚠️</span>
                <div>
                  <p className="font-medium text-error text-sm">New Destination Account</p>
                  <p className="text-xs text-error/80 mt-1">This bank account has never been used by this payee before.</p>
                </div>
              </div>
              <div className="flex items-start gap-3 p-3 rounded-lg bg-success-bg border border-success-border">
                <span className="text-success mt-0.5">✓</span>
                <div>
                  <p className="font-medium text-success text-sm">KYC Verified</p>
                  <p className="text-xs text-success/80 mt-1">Payee identity and limits are verified.</p>
                </div>
              </div>
              <div className="flex items-start gap-3 p-3 rounded-lg bg-success-bg border border-success-border">
                <span className="text-success mt-0.5">✓</span>
                <div>
                  <p className="font-medium text-success text-sm">Velocity Check</p>
                  <p className="text-xs text-success/80 mt-1">No other withdrawal requests within the last 24 hours.</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Col */}
        <div className="space-y-6">
          <div className="bg-surface rounded-xl border border-border p-6">
            <h3 className="font-medium mb-4">Payee & Destination</h3>
            <dl className="space-y-4 text-sm">
              <div>
                <dt className="text-text-muted text-xs mb-1">Payee</dt>
                <dd className="font-medium">Aisha Bello (ABA-492)</dd>
              </div>
              <div>
                <dt className="text-text-muted text-xs mb-1">Source Balance</dt>
                <dd className="font-medium">Commission Wallet</dd>
              </div>
              <div className="pt-4 border-t border-border">
                <dt className="text-text-muted text-xs mb-1">Bank Name</dt>
                <dd className="font-medium">GTBank</dd>
              </div>
              <div>
                <dt className="text-text-muted text-xs mb-1">Account Number</dt>
                <dd className="font-mono">0123994192</dd>
              </div>
              <div>
                <dt className="text-text-muted text-xs mb-1">Account Name</dt>
                <dd className="font-medium">Aisha Fatima Bello</dd>
              </div>
            </dl>
          </div>
        </div>

      </div>
    </div>
  );
}
