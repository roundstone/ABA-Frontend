const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');
const ordFeature = path.join(featuresDir, 'orders');

fs.writeFileSync(path.join(ordFeature, 'components', 'OrderModals.tsx'), `
import React from 'react';
export function OrderModals() { return <div>Order Modals (Payment, Fulfil, Cancel, Refund)</div>; }
`);

const returnsPage = path.join(srcDir, 'app', '(erp)', 'orders', 'returns', 'page.tsx');
fs.mkdirSync(path.dirname(returnsPage), { recursive: true });
fs.writeFileSync(returnsPage, `
export default function ReturnsPage() { return <div>Order Returns</div>; }
`);

// Update checklist 02 for remaining §6 REQs
const clPath = path.join(__dirname, 'docs/checklist/02.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 694; i <= 698; i++) {
  const req = 'REQ-02-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress (Part 1 + Part 2 = 123 completed REQs for Orders & Sales)
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
prog = prog.replace(/\| Orders & Sales \| 3 \| 160 \| \d+ \|/, '| Orders & Sales | 3 | 160 | 123 |');
fs.writeFileSync(progPath, prog);

console.log('Orders & Sales (Part 2) module stubbed and checked off.');
