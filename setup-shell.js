const fs = require('fs');
const path = require('path');

const srcDir = path.join(__dirname, 'apps/web/src');
const appDir = path.join(srcDir, 'app');
const erpDir = path.join(appDir, '(erp)');

// Layout for ERP
fs.writeFileSync(path.join(erpDir, 'layout.tsx'), `
import { AppShell } from '@/components/patterns/AppShell';

export default function ErpLayout({ children }: { children: React.ReactNode }) {
  return <AppShell>{children}</AppShell>;
}
`);

// Routes
const routes = [
  'dashboard',
  'orders', 'customers', 'referrals',
  'products', 'categories', 'merchants', 'suppliers',
  'procurement/purchase-requests', 'procurement/purchase-orders', 'procurement/receiving', 'procurement/supplier-invoices',
  'inventory', 'production',
  'payments', 'commissions', 'payouts', 'finance',
  'reports',
  'admin/users', 'admin/roles', 'admin/audit-logs', 'admin/settings'
];

routes.forEach(route => {
  const p = path.join(erpDir, route);
  fs.mkdirSync(p, { recursive: true });
  fs.writeFileSync(path.join(p, 'page.tsx'), `
export default function StubPage() {
  return <div className="p-8"><h1 className="text-h1">STUB — Phase N</h1><p>Route: /${route}</p></div>;
}
`);
});

// Layout for POS
const posDir = path.join(appDir, '(pos)');
fs.writeFileSync(path.join(posDir, 'layout.tsx'), `
export default function PosLayout({ children }: { children: React.ReactNode }) {
  return <div className="pos-shell">{children}</div>;
}
`);
fs.mkdirSync(path.join(posDir, 'pos'), { recursive: true });
fs.writeFileSync(path.join(posDir, 'pos', 'page.tsx'), `
export default function PosStub() {
  return <div>POS STUB</div>;
}
`);

// Layout for Auth
const authDir = path.join(appDir, '(auth)');
fs.writeFileSync(path.join(authDir, 'layout.tsx'), `
export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return <div className="auth-shell">{children}</div>;
}
`);

// Shell component
const compDir = path.join(srcDir, 'components/patterns');
fs.writeFileSync(path.join(compDir, 'AppShell.tsx'), `
import React from 'react';

export function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex h-screen w-full bg-bg">
      <aside className="w-64 flex-shrink-0 bg-sidebar-bg text-sidebar-text flex flex-col">
        <div className="p-4 font-bold text-white">ABA ERP</div>
        <nav className="flex-1 p-4 space-y-2">
          {/* Stub Sidebar Navigation */}
          <div className="text-sm font-semibold uppercase opacity-60">Sales</div>
          <a href="/dashboard" className="block p-2 hover:bg-white/10 rounded">Dashboard</a>
          <a href="/orders" className="block p-2 hover:bg-white/10 rounded">Orders</a>
          <a href="/customers" className="block p-2 hover:bg-white/10 rounded">Customers</a>
          <div className="text-sm font-semibold uppercase opacity-60 mt-4">Catalog</div>
          <a href="/products" className="block p-2 hover:bg-white/10 rounded">Products</a>
          <a href="/merchants" className="block p-2 hover:bg-white/10 rounded">Merchants</a>
        </nav>
      </aside>
      <div className="flex-1 flex flex-col min-w-0">
        <header className="h-16 flex-shrink-0 bg-white border-b border-border flex items-center px-4 justify-between">
          <div>Breadcrumbs</div>
          <div>Global Search / Profile</div>
        </header>
        <main className="flex-1 overflow-auto">
          {children}
        </main>
      </div>
    </div>
  );
}
`);

console.log('App shell created.');
