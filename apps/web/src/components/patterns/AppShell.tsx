
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
