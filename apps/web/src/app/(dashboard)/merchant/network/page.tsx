"use client";

import React, { useEffect, useState } from 'react';
import { useAuthStore } from '@/store/useAuthStore';
import { ReferralService } from '@/services/mock/referral.service';
import NetworkTree from '@/components/NetworkTree';

export default function MerchantNetworkPage() {
  const { user } = useAuthStore();
  const [downlineTree, setDownlineTree] = useState<any>(null);
  const [upline, setUpline] = useState<{ level: number, referrerId: string }[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (user) {
      setDownlineTree(ReferralService.getDownlineTree(user.id));
      setUpline(ReferralService.getUplineChain(user.id));
    }
  }, [user]);

  if (!mounted) return null;
  if (!user) return <div className="p-5 text-center">Loading...</div>;

  return (
    <div className="tab-pane fade show active">
      <div className="dashboard-right">
        <div className="dashboard">
          <div className="page-title">
            <h2>My Referral Network</h2>
          </div>
          
          <div className="welcome-msg border-0 mb-4 p-0 bg-transparent">
            <p>Track your upline relationships and the downline network you have built.</p>
          </div>

          <div className="box-account box-info mt-4">
            <div className="row">
              <div className="col-md-6 mb-4">
                <div className="card shadow-sm p-4 h-100 border-0">
                  <h4 className="mb-3 text-primary">Your Upline</h4>
                  {upline.length === 0 ? (
                    <p className="text-muted">You have no upline (you were not referred by anyone).</p>
                  ) : (
                    <ul className="list-group list-group-flush">
                      {upline.map((up) => (
                        <li key={up.level} className="list-group-item px-0 d-flex justify-content-between align-items-center">
                          <span>Level {up.level}</span>
                          <span className="font-bold">{up.referrerId}</span>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              </div>
              
              <div className="col-md-12">
                <div className="card shadow-sm p-4 border-0">
                  <h4 className="mb-4 text-primary">Your Downline Tree</h4>
                  {downlineTree ? (
                    <NetworkTree data={downlineTree} />
                  ) : (
                    <p className="text-muted">Loading network...</p>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
