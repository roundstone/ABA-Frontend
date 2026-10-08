import React from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { CreatePackageForm } from '@/features/promotions/components/CreatePackageForm';

export default function NewPromotionPackagePage() {
  return (
    <div className="space-y-6">
      <PageHeader 
        title="New Promotion Package" 
        description="Define a new package that merchants can purchase to promote their products."
        backHref="/erp/settings/promotions"
      />
      
      <CreatePackageForm />
    </div>
  );
}
