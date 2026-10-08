import { ReportMetadata, ReportCategory, ReportExportJob, ScheduledReport } from './types';

export const mockReportCategories: ReportCategory[] = [
  { id: 'sales', name: 'Sales', description: 'Revenue, orders, and sales performance.' },
  { id: 'inventory', name: 'Inventory', description: 'Stock levels, movements, and valuation.' },
  { id: 'finance', name: 'Finance', description: 'P&L, cash flow, payables and receivables.' },
  { id: 'referrals', name: 'Referrals & Commissions', description: 'Network growth, earnings, and payouts.' },
];

export const mockReportsList: ReportMetadata[] = [
  { id: 'sales-summary', title: 'Sales Summary', description: 'High-level sales KPIs and trends.', category: 'sales', isFavorite: true, lastViewed: '2026-10-08T05:00:00Z', allowedRoles: ['Super Admin', 'Admin', 'Sales Manager'] },
  { id: 'product-sales', title: 'Product Sales', description: 'Top performing products and margin analysis.', category: 'sales', isFavorite: false, allowedRoles: ['Super Admin', 'Admin', 'Sales Manager'] },
  { id: 'merchant-sales', title: 'Merchant Sales', description: 'Sales volume and ranking by merchant.', category: 'sales', isFavorite: true, allowedRoles: ['Super Admin', 'Admin'] },
  
  { id: 'stock-report', title: 'Stock Report', description: 'Current inventory levels and reorder points.', category: 'inventory', isFavorite: false, allowedRoles: ['Super Admin', 'Admin', 'Inventory Manager'] },
  { id: 'stock-movement', title: 'Stock Movement', description: 'Historical stock ins, outs, and adjustments.', category: 'inventory', isFavorite: false, allowedRoles: ['Super Admin', 'Admin', 'Inventory Manager'] },
  
  { id: 'profit-and-loss', title: 'Profit & Loss', description: 'Income statement summarizing revenues, costs, and expenses.', category: 'finance', isFavorite: true, lastViewed: '2026-10-07T12:00:00Z', allowedRoles: ['Super Admin', 'Admin', 'Finance Manager'] },
  { id: 'cash-flow', title: 'Cash Flow', description: 'Cash inflows and outflows.', category: 'finance', isFavorite: false, allowedRoles: ['Super Admin', 'Admin', 'Finance Manager'] },
  
  { id: 'commission-generated', title: 'Commission Generated', description: 'Trend of commissions earned by the network.', category: 'referrals', isFavorite: false, allowedRoles: ['Super Admin', 'Admin', 'Finance Manager'] },
];

export const mockExportJobs: ReportExportJob[] = [
  {
    id: 'exp-1',
    reportId: 'sales-summary',
    reportName: 'Sales Summary (Oct 2026)',
    format: 'Excel',
    status: 'Ready',
    requestedAt: '2026-10-08T06:10:00Z',
    requestedBy: 'Aisha Bello',
    downloadUrl: '/api/exports/exp-1/download',
    expiresAt: '2026-10-15T06:10:00Z'
  },
  {
    id: 'exp-2',
    reportId: 'stock-report',
    reportName: 'Stock Report (Current)',
    format: 'PDF',
    status: 'Generating',
    requestedAt: '2026-10-08T06:40:00Z',
    requestedBy: 'System',
  }
];

export const mockScheduledReports: ScheduledReport[] = [
  {
    id: 'sched-1',
    reportId: 'sales-summary',
    reportName: 'Weekly Sales Snapshot',
    frequency: 'Weekly',
    nextRun: '2026-10-12T08:00:00Z',
    recipients: ['finance@aba.com', 'admin@aba.com'],
    format: 'PDF',
    active: true,
  }
];
