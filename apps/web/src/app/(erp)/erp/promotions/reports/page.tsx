import React from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { MerchantPromotionsReport } from '@/features/promotions/components/MerchantPromotionsReport';

export default function MerchantPromotionsPage() {
  // In a real app, this comes from the authenticated user's session
  const merchantId = 'mch_1'; 

  return (
    <div className="space-y-6">
      <PageHeader 
        title="My Promotions" 
        description="View the performance and ROI of your promoted products."
      />
      
      <MerchantPromotionsReport merchantId={merchantId} />
    </div>
  );
}
