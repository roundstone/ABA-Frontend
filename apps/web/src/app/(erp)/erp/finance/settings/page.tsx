import { PageHeader } from '@/components/patterns/PageHeader';
import { Button } from '@/components/ui/button';

export default function FinanceSettingsPage() {
  return (
    <div className="space-y-6 pb-20 mx-auto">
      <PageHeader 
        title="Finance Settings" 
        description="Configure posting rules, tax rates, and account mappings."
        backHref="/erp/finance"
        action={<Button>Save Changes</Button>}
      />
      <div className="p-12 text-center border border-dashed rounded-lg bg-surface text-text-muted">
        <p>Finance Configuration Panel is under construction.</p>
      </div>
    </div>
  );
}
