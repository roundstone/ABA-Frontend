import { Archive, Box, DollarSign, Home, Network, Percent, Users, ShoppingCart, Layers, Phone, BarChart, Settings } from 'lucide-react';
import React from 'react';

export type SubMenuItem = {
  title: string;
  href: string;
};

export type MenuItem = {
  id: string;
  title: string;
  icon?: React.ReactNode;
  featherIcon?: string;
  href?: string;
  submenu?: SubMenuItem[];
};

export const ADMIN_SIDEBAR_MENU: MenuItem[] = [
  {
    id: 'dashboard',
    title: 'Dashboard',
    icon: <Home />,
    href: '/admin',
  },
  {
    id: 'products',
    title: 'Products',
    icon: <Box />,
    submenu: [
      { title: 'Category', href: '/admin/products/category' },
      { title: 'Product', href: '/admin/products' },
    ],
  },
  {
    id: 'orders',
    title: 'Orders',
    icon: <Archive />,
    href: '/admin/orders',
  },
  {
    id: 'network',
    title: 'Network',
    icon: <Network />,
    href: '/admin/network',
  },
  {
    id: 'commission',
    title: 'Commission',
    icon: <Percent />,
    href: '/admin/commission',
  },
  {
    id: 'finance',
    title: 'Finance',
    icon: <DollarSign />,
    submenu: [
      { title: 'Overview', href: '/admin/finance' },
      { title: 'Payouts', href: '/admin/payouts' },
    ],
  },
  {
    id: 'users',
    title: 'Users',
    icon: <Users />,
    href: '/admin/users',
  },
  {
    id: 'merchants',
    title: 'Merchants',
    icon: <Users />,
    href: '/admin/merchants',
  },
  {
    id: 'support-tickets',
    title: 'Support Ticket',
    icon: <Phone />,
    href: '/admin/support-tickets',
  },
  {
    id: 'reports',
    title: 'Reports',
    icon: <BarChart />,
    href: '/admin/reports',
  },
  {
    id: 'invoice',
    title: 'Invoice',
    icon: <Archive />,
    href: '/admin/invoice',
  },
  {
    id: 'procurement',
    title: 'Procurement (ERP)',
    icon: <ShoppingCart />,
    submenu: [
      { title: 'Dashboard', href: '/admin/procurement/dashboard' },
      { title: 'Suppliers', href: '/admin/procurement/suppliers' },
      { title: 'Requisitions', href: '/admin/procurement/requisitions' },
      { title: 'Purchase Orders', href: '/admin/procurement/orders' },
      { title: 'Goods Received', href: '/admin/procurement/receiving' },
      { title: 'Invoices', href: '/admin/procurement/invoices' },
    ],
  },
  {
    id: 'inventory',
    title: 'Inventory (ERP)',
    icon: <Archive />,
    submenu: [
      { title: 'Dashboard', href: '/admin/inventory/dashboard' },
      { title: 'Raw Materials', href: '/admin/inventory/materials' },
      { title: 'Finished Goods', href: '/admin/inventory/finished-goods' },
      { title: 'Stock Movements', href: '/admin/inventory/movements' },
      { title: 'Adjustments', href: '/admin/inventory/adjustments' },
      { title: 'Allocations', href: '/admin/inventory/allocations' },
    ],
  },
  {
    id: 'production',
    title: 'Production (ERP)',
    icon: <Layers />,
    submenu: [
      { title: 'Dashboard', href: '/admin/production/dashboard' },
      { title: 'Production Orders', href: '/admin/production/orders' },
      { title: 'Planning', href: '/admin/production/planning' },
      { title: 'Materials', href: '/admin/production/materials' },
      { title: 'WIP Stages', href: '/admin/production/stages' },
      { title: 'Costs', href: '/admin/production/costs' },
      { title: 'Settings', href: '/admin/production/settings' },
    ],
  },
  {
    id: 'settings',
    title: 'Settings',
    icon: <Settings />,
    submenu: [
      { title: 'Profile', href: '/admin/settings' },
    ],
  },
];
