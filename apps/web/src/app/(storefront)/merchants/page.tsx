import React, { Suspense } from 'react';
import type { Metadata } from 'next';
import { brand } from '@/config/brand';
import { MerchantDirectory } from './_components/MerchantDirectory';

export const metadata: Metadata = {
  title: `Businesses | ${brand.name}`,
  description: `Browse verified sellers on ${brand.name}. Search, filter by category, state and rating.`,
};

export default function MerchantDirectoryPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-bg" aria-busy="true" />}>
      <MerchantDirectory />
    </Suspense>
  );
}
