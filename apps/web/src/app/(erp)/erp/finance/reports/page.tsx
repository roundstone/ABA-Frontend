import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';

export default function FinanceReportsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Financial Statements" 
        description="Generate standard accounting reports and statements."
        backHref="/erp/finance"
      />
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        {['Profit & Loss', 'Balance Sheet', 'Cash Flow', 'Trial Balance', 'AR Ageing', 'AP Ageing'].map(report => (
          <div key={report} className="p-6 border rounded-lg bg-surface hover:border-brand-500 cursor-pointer transition-colors">
            <h3 className="font-bold mb-2">{report}</h3>
            <p className="text-sm text-text-muted mb-4">Generate statement</p>
            <Button variant="outline" size="sm">Run Report</Button>
          </div>
        ))}
      </div>
    </div>
  );
}
