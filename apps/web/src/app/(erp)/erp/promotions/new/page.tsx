import React from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { CreatePromotionForm } from '@/features/promotions/components/CreatePromotionForm';

export default function CreatePromotionPage() {
  return (
    <div className="space-y-6">
      <PageHeader 
        title="Create Promotion" 
        description="Schedule a new product promotion on behalf of a merchant."
        backHref="/erp/promotions"
      />
      
      <CreatePromotionForm />
    </div>
  );
}
