'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { CommissionService, CommissionLedgerEntry } from '@/services/mock/commission.service';
import CommissionLedgerTable from '@/components/CommissionLedgerTable';
import { Clock, CheckCircle } from 'lucide-react';
import MetricCard from '@/components/admin/dashboard/MetricCard';

export default function AdminCommissionPage() {
  const [ledger, setLedger] = useState<CommissionLedgerEntry[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setLedger(CommissionService.getLedger());
  }, []);

  if (!mounted) return null;

  const totalPending = ledger.filter(e => e.status === 'PENDING').reduce((sum, e) => sum + e.amount, 0);
  const totalPaid = ledger.filter(e => e.status === 'PAID').reduce((sum, e) => sum + e.amount, 0);

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Commission Engine
                <small>ABA ERP Admin panel</small>
              </h3>
            </div>
          </div>
          <div className="col-lg-6">
            <ol className="breadcrumb pull-right">
              <li className="breadcrumb-item">
                <Link href="/admin"><i data-feather="home"></i></Link>
              </li>
              <li className="breadcrumb-item">Commission</li>
              <li className="breadcrumb-item active">Overview</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row">
        <MetricCard
          title="Pending Payouts"
          value={totalPending.toLocaleString(undefined, { minimumFractionDigits: 2 })}
          Icon={Clock}
          colorClass="warning"
          prefix="₦"
        />
        <MetricCard
          title="Total Paid Out"
          value={totalPaid.toLocaleString(undefined, { minimumFractionDigits: 2 })}
          Icon={CheckCircle}
          colorClass="secondary"
          prefix="₦"
        />
      </div>

      <div className="row">
        <div className="col-sm-12">
          <div className="card">
            <div className="card-header">
              <h5>Platform Commission Ledger</h5>
            </div>
            <div className="card-body">
              <CommissionLedgerTable entries={ledger} showRecipient={true} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
