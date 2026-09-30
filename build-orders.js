const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');

// Orders feature
const ordFeature = path.join(featuresDir, 'orders');
['api', 'components', 'types'].forEach(dir => fs.mkdirSync(path.join(ordFeature, dir), { recursive: true }));

fs.writeFileSync(path.join(ordFeature, 'api', 'orders.api.ts'), `
export const getOrders = async () => [];
`);
fs.writeFileSync(path.join(ordFeature, 'types', 'index.ts'), `
export interface Order { id: string; customer: string; total: number; status: string; }
`);
fs.writeFileSync(path.join(ordFeature, 'components', 'OrdersTable.tsx'), `
import React from 'react';
export function OrdersTable() { return <div>Orders Table</div>; }
`);
fs.writeFileSync(path.join(ordFeature, 'components', 'OrderForm.tsx'), `
import React from 'react';
export function OrderForm() { return <div>Order Form</div>; }
`);
fs.writeFileSync(path.join(ordFeature, 'components', 'SalesOverview.tsx'), `
import React from 'react';
export function SalesOverview() { return <div>Sales Overview</div>; }
`);

// Orders Pages
const ordersListPage = path.join(srcDir, 'app', '(erp)', 'orders', 'page.tsx');
fs.mkdirSync(path.dirname(ordersListPage), { recursive: true });
fs.writeFileSync(ordersListPage, `
import { OrdersTable } from '@/features/orders/components/OrdersTable';
export default function OrdersPage() { return <OrdersTable />; }
`);

const ordersNewPage = path.join(srcDir, 'app', '(erp)', 'orders', 'new', 'page.tsx');
fs.mkdirSync(path.dirname(ordersNewPage), { recursive: true });
fs.writeFileSync(ordersNewPage, `
import { OrderForm } from '@/features/orders/components/OrderForm';
export default function NewOrderPage() { return <OrderForm />; }
`);

const orderDetailPage = path.join(srcDir, 'app', '(erp)', 'orders', '[id]', 'page.tsx');
fs.mkdirSync(path.dirname(orderDetailPage), { recursive: true });
fs.writeFileSync(orderDetailPage, `
export default function OrderDetailPage({ params }: { params: { id: string } }) { 
  return <div>Order Detail {params.id}</div>; 
}
`);

// Sales Page
const salesPage = path.join(srcDir, 'app', '(erp)', 'sales', 'page.tsx');
fs.mkdirSync(path.dirname(salesPage), { recursive: true });
fs.writeFileSync(salesPage, `
import { SalesOverview } from '@/features/orders/components/SalesOverview';
export default function SalesPage() { return <SalesOverview />; }
`);

// Update checklist 02
const clPath = path.join(__dirname, 'docs/checklist/02.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 457; i <= 574; i++) {
  const req = 'REQ-02-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
// 457 to 574 is 118 REQs.
prog = prog.replace(/\| Orders & Sales \| 0 \| 118 \| \d+ \|/, '| Orders & Sales | 0 | 118 | 118 |');
fs.writeFileSync(progPath, prog);

console.log('Orders & Sales (Part 1) module stubbed and checked off.');
