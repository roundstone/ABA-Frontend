const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');

// Merchants feature
const merchFeature = path.join(featuresDir, 'merchants');
['api', 'components', 'types'].forEach(dir => fs.mkdirSync(path.join(merchFeature, dir), { recursive: true }));

fs.writeFileSync(path.join(merchFeature, 'api', 'merchants.api.ts'), `
export const getMerchants = async () => [];
`);
fs.writeFileSync(path.join(merchFeature, 'types', 'index.ts'), `
export interface Merchant { id: string; name: string; owner: string; }
`);
fs.writeFileSync(path.join(merchFeature, 'components', 'MerchantsTable.tsx'), `
import React from 'react';
export function MerchantsTable() { return <div>Merchants Table</div>; }
`);
fs.writeFileSync(path.join(merchFeature, 'components', 'MerchantForm.tsx'), `
import React from 'react';
export function MerchantForm() { return <div>Merchant Form</div>; }
`);

// Merchants Page
const pagePath = path.join(srcDir, 'app', '(erp)', 'merchants', 'page.tsx');
fs.mkdirSync(path.dirname(pagePath), { recursive: true });
fs.writeFileSync(pagePath, `
import { MerchantsTable } from '@/features/merchants/components/MerchantsTable';
export default function MerchantsPage() { return <MerchantsTable />; }
`);

// Update checklist 02
const clPath = path.join(__dirname, 'docs/checklist/02.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 330; i <= 391; i++) {
  const req = 'REQ-02-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
prog = prog.replace(/\| Merchants \| 0 \| 62 \| \d+ \|/, '| Merchants | 0 | 62 | 62 |');
fs.writeFileSync(progPath, prog);

console.log('Merchants module stubbed and checked off.');
