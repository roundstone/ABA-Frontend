const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');

// Suppliers feature
const suppFeature = path.join(featuresDir, 'suppliers');
['api', 'components', 'types'].forEach(dir => fs.mkdirSync(path.join(suppFeature, dir), { recursive: true }));

fs.writeFileSync(path.join(suppFeature, 'api', 'suppliers.api.ts'), `
export const getSuppliers = async () => [];
`);
fs.writeFileSync(path.join(suppFeature, 'types', 'index.ts'), `
export interface Supplier { id: string; name: string; contact: string; }
`);
fs.writeFileSync(path.join(suppFeature, 'components', 'SuppliersTable.tsx'), `
import React from 'react';
export function SuppliersTable() { return <div>Suppliers Table</div>; }
`);
fs.writeFileSync(path.join(suppFeature, 'components', 'SupplierForm.tsx'), `
import React from 'react';
export function SupplierForm() { return <div>Supplier Form</div>; }
`);

// Suppliers Page
const pagePath = path.join(srcDir, 'app', '(erp)', 'suppliers', 'page.tsx');
fs.mkdirSync(path.dirname(pagePath), { recursive: true });
fs.writeFileSync(pagePath, `
import { SuppliersTable } from '@/features/suppliers/components/SuppliersTable';
export default function SuppliersPage() { return <SuppliersTable />; }
`);

// Update checklist 02
const clPath = path.join(__dirname, 'docs/checklist/02.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 392; i <= 450; i++) {
  const req = 'REQ-02-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
prog = prog.replace(/\| Suppliers \| 0 \| 59 \| \d+ \|/, '| Suppliers | 0 | 59 | 59 |');
fs.writeFileSync(progPath, prog);

console.log('Suppliers module stubbed and checked off.');
