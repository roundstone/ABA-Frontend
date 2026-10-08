import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';

export default function ReconciliationPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Reconciliation Hub" 
        description="Verify system balances against external records and subledgers."
        backHref="/erp/finance"
        action={<Button>Start New Reconciliation</Button>}
      />
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div className="p-6 border rounded-lg bg-surface">
          <h3 className="font-bold mb-2">Bank & Gateway</h3>
          <p className="text-sm text-text-muted mb-4">Reconcile cash accounts with external statements.</p>
          <Button variant="outline" className="w-full">Review Bank Recon</Button>
        </div>
        <div className="p-6 border rounded-lg bg-surface">
          <h3 className="font-bold mb-2">Inventory vs GL</h3>
          <p className="text-sm text-text-muted mb-4">Ensure stock valuation matches the inventory ledger.</p>
          <Button variant="outline" className="w-full">Investigate Variance</Button>
        </div>
        <div className="p-6 border rounded-lg bg-surface">
          <h3 className="font-bold mb-2">AR Subledger</h3>
          <p className="text-sm text-text-muted mb-4">Match open customer invoices to AR total.</p>
          <Button variant="outline" className="w-full">View Breakdown</Button>
        </div>
        <div className="p-6 border rounded-lg bg-surface">
          <h3 className="font-bold mb-2">Commissions Payable</h3>
          <p className="text-sm text-text-muted mb-4">Match approved unpaid commissions to liability account.</p>
          <Button variant="outline" className="w-full">View Breakdown</Button>
        </div>
      </div>
    </div>
  );
}
