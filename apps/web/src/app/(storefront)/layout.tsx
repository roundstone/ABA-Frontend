import React from 'react';
import { StorefrontHeader } from '@/components/patterns/StorefrontHeader';
import { StorefrontFooter } from '@/components/patterns/StorefrontFooter';

export default function StorefrontLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex flex-col min-h-screen bg[#fdfaf1]">
      <StorefrontHeader />
      <main className="flex-1 w-full mt-20 bgbg">
        {children}
      </main>
      <StorefrontFooter />
    </div>
  );
}
