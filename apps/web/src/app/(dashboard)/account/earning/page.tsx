"use client";

import React, { useEffect, useState } from 'react';
import { useAuthStore } from '@/store/useAuthStore';
import { CommissionService, CommissionLedgerEntry } from '@/services/mock/commission.service';
import CommissionLedgerTable from '@/components/CommissionLedgerTable';

export default function AccountEarningPage() {
  const { user } = useAuthStore();
  const [earnings, setEarnings] = useState<CommissionLedgerEntry[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (user) {
      setEarnings(CommissionService.getUserEarnings(user.id));
    }
  }, [user]);

  if (!mounted) return null;
  if (!user) return <div className="p-5 text-center">Loading...</div>;

  const totalEarned = earnings.reduce((sum, e) => sum + e.amount, 0);
  const pendingClearance = earnings.filter(e => e.status === 'PENDING').reduce((sum, e) => sum + e.amount, 0);
  const availableToWithdraw = earnings.filter(e => e.status === 'APPROVED').reduce((sum, e) => sum + e.amount, 0);

  return (
    <div className="tab-pane fade show active">
      <div className="dashboard-right">
        <div className="dashboard">
          <div className="page-title">
            <h2>My Commission Earnings</h2>
          </div>
          
          <div className="welcome-msg border-0 mb-4 p-0 bg-transparent">
            <p>Track commissions earned from your downline network purchases.</p>
          </div>

          <div className="row mt-4 mb-4">
            <div className="col-md-4 mb-3">
              <div className="card shadow-sm border-0 bg-light">
                <div className="card-body p-4 text-center">
                  <h6 className="text-muted">Total Earned</h6>
                  <h3 className="font-bold mt-2">₦{totalEarned.toLocaleString(undefined, { minimumFractionDigits: 2 })}</h3>
                </div>
              </div>
            </div>
            <div className="col-md-4 mb-3">
              <div className="card shadow-sm border-0 bg-warning bg-opacity-10">
                <div className="card-body p-4 text-center">
                  <h6 className="text-warning">Pending Clearance</h6>
                  <h3 className="font-bold mt-2">₦{pendingClearance.toLocaleString(undefined, { minimumFractionDigits: 2 })}</h3>
                </div>
              </div>
            </div>
            <div className="col-md-4 mb-3">
              <div className="card shadow-sm border-0 bg-success bg-opacity-10">
                <div className="card-body p-4 text-center">
                  <h6 className="text-success">Available to Withdraw</h6>
                  <h3 className="font-bold mt-2">₦{availableToWithdraw.toLocaleString(undefined, { minimumFractionDigits: 2 })}</h3>
                </div>
              </div>
            </div>
          </div>

          <div className="box-account">
            <h4 className="mb-3">Earning History</h4>
            <CommissionLedgerTable entries={earnings} showRecipient={false} />
          </div>
        </div>
      </div>
    </div>
  );
}
