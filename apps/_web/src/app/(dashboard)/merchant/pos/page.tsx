"use client";

import React from 'react';
import POSInterface from '@/components/merchant/POSInterface';

export default function MerchantPOSPage() {
  return (
    <div className="tab-pane fade show active">
      <div className="dashboard-right">
        <div className="dashboard">
          <div className="page-title">
            <h2>Point of Sale (POS)</h2>
          </div>
          <div className="welcome-msg border-0 mb-4 p-0 bg-transparent">
            <p>Process offline sales and walk-in customers quickly. Applies referral codes instantly.</p>
          </div>
          
          <div className="box-account box-info">
            <POSInterface />
          </div>
        </div>
      </div>
    </div>
  );
}
