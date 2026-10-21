'use client';

import React from 'react';
import { PageHeader } from '@/components/patterns/PageHeader';
import { GeneralLedgerTable } from '@/features/finance/components/GeneralLedgerTable';
import { Button } from '@/components/ui/button';
import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';

export default function JournalsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader
        title="Journal Entries"
        description="Chronological record of all double-entry debit and credit postings."
        backHref="/erp/finance/ledger"
        action={
          <div className="flex items-center gap-2">
            <Link href="/erp/finance/ledger">
              <Button variant="outline" size="sm" className="gap-1.5">
                <ArrowLeft className="w-3.5 h-3.5" />
                Commission Flow Ledger
              </Button>
            </Link>
          </div>
        }
      />
      <GeneralLedgerTable />
    </div>
  );
}
