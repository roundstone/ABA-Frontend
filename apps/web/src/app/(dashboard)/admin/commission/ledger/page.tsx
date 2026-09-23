'use client';

import React, { useEffect, useState } from 'react';
import Breadcrumb from '@/components/ui/Breadcrumb';
import UserSidebar from '@/components/layout/UserSidebar';
import { CommissionService, CommissionLedgerEntry } from '@/services/mock/commission.service';
import CommissionLedgerTable from '@/components/CommissionLedgerTable';

export default function AdminCommissionLedgerPage() {
  const [ledger, setLedger] = useState<CommissionLedgerEntry[]>([]);

  useEffect(() => {
    setLedger(CommissionService.getLedger());
  }, []);

  const totalPending = ledger.filter(e => e.status === 'PENDING').reduce((sum, e) => sum + e.amount, 0);
  const totalPaid = ledger.filter(e => e.status === 'PAID').reduce((sum, e) => sum + e.amount, 0);

  return (
    <>
      <Breadcrumb
        title="Admin - Commission Ledger"
        items={[{ label: 'Home', url: '/' }, { label: 'Commission Ledger' }]}
      />
      <section className="section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-lg-3">
              <UserSidebar />
            </div>
            <div className="col-sm-9">
              <div className="dashboard-right">
                <div className="dashboard">
                  <div className="page-title">
                    <h2>Platform Commission Ledger</h2>
                  </div>
                  
                  <div className="welcome-msg">
                    <p>Track all generated commissions and payouts across the platform.</p>
                  </div>

                  <div className="row mt-4 mb-4">
                    <div className="col-md-6">
                      <div className="card shadow-sm border-0 bg-warning bg-opacity-10">
                        <div className="card-body p-4 text-center">
                          <h5 className="text-warning">Total Pending Payouts</h5>
                          <h3 className="font-bold mt-2">₦{totalPending.toLocaleString(undefined, { minimumFractionDigits: 2 })}</h3>
                        </div>
                      </div>
                    </div>
                    <div className="col-md-6">
                      <div className="card shadow-sm border-0 bg-success bg-opacity-10">
                        <div className="card-body p-4 text-center">
                          <h5 className="text-success">Total Paid Out</h5>
                          <h3 className="font-bold mt-2">₦{totalPaid.toLocaleString(undefined, { minimumFractionDigits: 2 })}</h3>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="box-account">
                    <CommissionLedgerTable entries={ledger} showRecipient={true} />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
