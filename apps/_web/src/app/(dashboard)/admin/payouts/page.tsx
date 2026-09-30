'use client';

import { CommissionService, CommissionLedgerEntry, CommissionStatus } from '@/services/mock/commission.service';
import { useState, useEffect } from 'react';
import Link from 'next/link';

export default function AdminPayoutsPage() {
  const [ledger, setLedger] = useState<CommissionLedgerEntry[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setLedger(CommissionService.getLedger());
  }, []);

  const handleStatusChange = (id: string, newStatus: CommissionStatus) => {
    CommissionService.updateCommissionStatusById(id, newStatus);
    setLedger(CommissionService.getLedger());
  };

  const handleBulkPay = () => {
    const unpaid = ledger.filter(entry => entry.status === 'APPROVED' || entry.status === 'PENDING');
    unpaid.forEach(entry => {
      CommissionService.updateCommissionStatusById(entry.id, 'PAID');
    });
    setLedger(CommissionService.getLedger());
    alert(`${unpaid.length} commissions marked as PAID.`);
  };

  if (!mounted) return null;

  const unpaidCount = ledger.filter(entry => entry.status === 'APPROVED' || entry.status === 'PENDING').length;
  const unpaidTotal = ledger.filter(entry => entry.status === 'APPROVED' || entry.status === 'PENDING').reduce((sum, entry) => sum + entry.amount, 0);

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Payouts
                <small>ABA ERP Admin panel</small>
              </h3>
            </div>
          </div>
          <div className="col-lg-6">
            <ol className="breadcrumb pull-right">
              <li className="breadcrumb-item">
                <Link href="/admin"><i data-feather="home"></i></Link>
              </li>
              <li className="breadcrumb-item">Finance</li>
              <li className="breadcrumb-item active">Payouts</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row">
        <div className="col-sm-12">
          <div className="card">
            <div className="card-header d-flex justify-content-between align-items-center">
              <h5>Commission Payouts</h5>
              <button
                className="btn btn-primary"
                onClick={handleBulkPay}
                disabled={unpaidCount === 0}
              >
                Pay All Pending/Approved (${unpaidTotal.toFixed(2)})
              </button>
            </div>
            <div className="card-body">
              <div className="table-responsive">
                <table className="table table-bordered text-sm">
                  <thead className="bg-light">
                    <tr>
                      <th>ID</th>
                      <th>Date</th>
                      <th>Recipient ID</th>
                      <th>Order ID</th>
                      <th>Level</th>
                      <th>Amount</th>
                      <th>Status</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {ledger.length === 0 ? (
                      <tr>
                        <td colSpan={8} className="text-center py-4">No commissions found.</td>
                      </tr>
                    ) : (
                      ledger.map(entry => (
                        <tr key={entry.id}>
                          <td><small>{entry.id}</small></td>
                          <td><small>{new Date(entry.createdAt).toLocaleDateString()}</small></td>
                          <td><h6>{entry.recipientId}</h6></td>
                          <td><small>{entry.orderId}</small></td>
                          <td><h6>Lvl {entry.level}</h6></td>
                          <td><h6 className="fw-bold">${entry.amount.toFixed(2)}</h6></td>
                          <td>
                            <span className={`badge ${entry.status === 'PAID' ? 'badge-success' : entry.status === 'REVERSED' ? 'badge-danger' : entry.status === 'APPROVED' ? 'badge-info' : 'badge-warning'}`}>
                              {entry.status}
                            </span>
                          </td>
                          <td>
                            {entry.status !== 'PAID' && entry.status !== 'REVERSED' && (
                              <button
                                className="btn btn-sm btn-outline-success"
                                onClick={() => handleStatusChange(entry.id, 'PAID')}
                              >
                                Mark Paid
                              </button>
                            )}
                            {entry.status === 'PAID' && (
                              <span className="text-success"><i className="fa fa-check"></i> Paid</span>
                            )}
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
