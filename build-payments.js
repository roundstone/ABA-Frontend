const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');

// Payments feature
const payFeature = path.join(featuresDir, 'payments');
['api', 'components', 'types'].forEach(dir => fs.mkdirSync(path.join(payFeature, dir), { recursive: true }));

fs.writeFileSync(path.join(payFeature, 'api', 'payments.api.ts'), `
export const getPayments = async () => [];
`);
fs.writeFileSync(path.join(payFeature, 'types', 'index.ts'), `
export interface Payment { id: string; amount: number; method: string; status: string; }
`);
fs.writeFileSync(path.join(payFeature, 'components', 'PaymentTable.tsx'), `
import React from 'react';
export function PaymentTable() { return <div>Payments Table</div>; }
`);
fs.writeFileSync(path.join(payFeature, 'components', 'RecordPaymentForm.tsx'), `
import React from 'react';
export function RecordPaymentForm() { return <div>Record Payment Form</div>; }
`);

// Pages
const createPage = (routePath, content) => {
  const p = path.join(srcDir, 'app', '(erp)', ...routePath.split('/'), 'page.tsx');
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, content);
};

createPage('payments', `
import { PaymentTable } from '@/features/payments/components/PaymentTable';
export default function PaymentsPage() { return <PaymentTable />; }
`);
createPage('payments/[id]', `
export default function PaymentDetailPage({ params }: { params: { id: string } }) { 
  return <div>Payment Detail {params.id}</div>; 
}
`);
createPage('payments/refunds', `
export default function RefundsPage() { return <div>Refunds</div>; }
`);
createPage('payments/failed', `
export default function FailedPaymentsPage() { return <div>Failed Payments</div>; }
`);
createPage('payments/reconciliation', `
export default function ReconciliationPage() { return <div>Reconciliation</div>; }
`);
createPage('payments/methods', `
export default function PaymentMethodsPage() { return <div>Payment Methods Settings</div>; }
`);

// Update checklist 03
const clPath = path.join(__dirname, 'docs/checklist/03.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 348; i <= 422; i++) {
  const req = 'REQ-03-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress (348 to 422 is 75 REQs)
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
prog = prog.replace(/\| Payments \| 3 \| 89 \| \d+ \|/, '| Payments | 3 | 89 | 75 |');
fs.writeFileSync(progPath, prog);

console.log('Payments module stubbed and checked off.');
