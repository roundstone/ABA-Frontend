'use client';

import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { ReferralService, ReferralRecord } from '@/services/mock/referral.service';

export default function AdminNetworkPage() {
  const [referrals, setReferrals] = useState<ReferralRecord[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setReferrals(ReferralService.getReferrals());
  }, []);

  if (!mounted) return null;

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Network Overview
                <small>ABA ERP Admin panel</small>
              </h3>
            </div>
          </div>
          <div className="col-lg-6">
            <ol className="breadcrumb pull-right">
              <li className="breadcrumb-item">
                <Link href="/admin"><i data-feather="home"></i></Link>
              </li>
              <li className="breadcrumb-item">Network</li>
              <li className="breadcrumb-item active">Overview</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row">
        <div className="col-sm-12">
          <div className="card">
            <div className="card-header">
              <h5>Platform Network Overview</h5>
            </div>
            <div className="card-body">
              <div className="table-responsive">
                <table className="table table-bordered text-sm">
                  <thead className="bg-light">
                    <tr>
                      <th>ID</th>
                      <th>Referrer ID</th>
                      <th>Referred User ID</th>
                      <th>Referral Code Used</th>
                      <th>Channel</th>
                      <th>Date Created</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {referrals.map((ref) => (
                      <tr key={ref.id}>
                        <td>{ref.id}</td>
                        <td className="font-bold text-primary">{ref.referrerId}</td>
                        <td>{ref.referredId}</td>
                        <td><code className="bg-light px-2 py-1 rounded">{ref.referralCode}</code></td>
                        <td>{ref.channel}</td>
                        <td>{new Date(ref.createdAt).toLocaleDateString()}</td>
                        <td>
                          <span className={`badge ${ref.status === 'ACTIVE' ? 'badge-success' : 'badge-secondary'}`}>
                            {ref.status}
                          </span>
                        </td>
                      </tr>
                    ))}
                    {referrals.length === 0 && (
                      <tr>
                        <td colSpan={7} className="text-center py-4">No referral relationships found.</td>
                      </tr>
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
