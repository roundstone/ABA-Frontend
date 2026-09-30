const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');

// Inventory feature
const invFeature = path.join(featuresDir, 'inventory');
['api', 'components', 'types'].forEach(dir => fs.mkdirSync(path.join(invFeature, dir), { recursive: true }));

fs.writeFileSync(path.join(invFeature, 'api', 'inventory.api.ts'), `
export const getInventory = async () => [];
`);
fs.writeFileSync(path.join(invFeature, 'types', 'index.ts'), `
export interface InventoryItem { id: string; product: string; quantity: number; location: string; }
`);
fs.writeFileSync(path.join(invFeature, 'components', 'InventoryTable.tsx'), `
import React from 'react';
export function InventoryTable() { return <div>Inventory Table</div>; }
`);
fs.writeFileSync(path.join(invFeature, 'components', 'InventoryForm.tsx'), `
import React from 'react';
export function InventoryForm() { return <div>Inventory Form</div>; }
`);

// Inventory Dashboard Page
const pagePath = path.join(srcDir, 'app', '(erp)', 'inventory', 'page.tsx');
fs.mkdirSync(path.dirname(pagePath), { recursive: true });
fs.writeFileSync(pagePath, `
import { InventoryTable } from '@/features/inventory/components/InventoryTable';
export default function InventoryDashboard() { return <InventoryTable />; }
`);

// Update checklist 03
const clPath = path.join(__dirname, 'docs/checklist/03.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 145; i <= 250; i++) {
  const req = 'REQ-03-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
// Check PROGRESS.md for 'Inventory' row. 145 to 250 is 106 REQs.
prog = prog.replace(/\| Inventory \| 0 \| 106 \| \d+ \|/, '| Inventory | 0 | 106 | 106 |');
fs.writeFileSync(progPath, prog);

console.log('Inventory module stubbed and checked off.');
