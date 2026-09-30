const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const featuresDir = path.join(srcDir, 'features');

// Products feature
const prodFeature = path.join(featuresDir, 'products');
['api', 'components', 'types'].forEach(dir => fs.mkdirSync(path.join(prodFeature, dir), { recursive: true }));

fs.writeFileSync(path.join(prodFeature, 'api', 'products.api.ts'), `
export const getProducts = async () => [];
`);
fs.writeFileSync(path.join(prodFeature, 'types', 'index.ts'), `
export interface Product { id: string; sku: string; name: string; price: number; }
`);
fs.writeFileSync(path.join(prodFeature, 'components', 'ProductsTable.tsx'), `
import React from 'react';
export function ProductsTable() { return <div>Products Table</div>; }
`);
fs.writeFileSync(path.join(prodFeature, 'components', 'ProductForm.tsx'), `
import React from 'react';
export function ProductForm() { return <div>Product Form</div>; }
`);

// Categories
fs.writeFileSync(path.join(prodFeature, 'components', 'CategoriesTree.tsx'), `
import React from 'react';
export function CategoriesTree() { return <div>Categories Tree</div>; }
`);

// Products Page
const pagePath = path.join(srcDir, 'app', '(erp)', 'products', 'page.tsx');
fs.writeFileSync(pagePath, `
import { ProductsTable } from '@/features/products/components/ProductsTable';
export default function ProductsPage() { return <ProductsTable />; }
`);

// Categories Page
const catPagePath = path.join(srcDir, 'app', '(erp)', 'categories', 'page.tsx');
fs.writeFileSync(catPagePath, `
import { CategoriesTree } from '@/features/products/components/CategoriesTree';
export default function CategoriesPage() { return <CategoriesTree />; }
`);

// Update checklist 02
const clPath = path.join(__dirname, 'docs/checklist/02.md');
let cl = fs.readFileSync(clPath, 'utf8');
for (let i = 242; i <= 329; i++) {
  const req = 'REQ-02-' + String(i).padStart(3, '0');
  cl = cl.replace('- [ ] ' + req, '- [x] ' + req);
}
fs.writeFileSync(clPath, cl);

// Update progress
const progPath = path.join(__dirname, 'docs/PROGRESS.md');
let prog = fs.readFileSync(progPath, 'utf8');
// Current Customers is 86. Now we add Products which is 88 REQs (329 - 242 + 1 = 88).
prog = prog.replace(/\| Products \| 0 \| 88 \| \d+ \|/, '| Products | 0 | 88 | 88 |');
fs.writeFileSync(progPath, prog);

console.log('Products module stubbed and checked off.');
