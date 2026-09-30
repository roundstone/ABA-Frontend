export type StatusTone = 'neutral' | 'info' | 'success' | 'warning' | 'error';

export type StatusConfig = {
  label: string;
  tone: StatusTone;
};

// Based on Global Design System §2.5
export const statusMap: Record<string, Record<string, StatusConfig>> = {
  common: {
    draft: { label: 'Draft', tone: 'neutral' },
    inactive: { label: 'Inactive', tone: 'neutral' },
    archived: { label: 'Archived', tone: 'neutral' },
    closed: { label: 'Closed', tone: 'neutral' },
    pending: { label: 'Pending', tone: 'info' },
    submitted: { label: 'Submitted', tone: 'info' },
    open: { label: 'Open', tone: 'info' },
    in_review: { label: 'In Review', tone: 'info' },
    processing: { label: 'Processing', tone: 'info' },
    scheduled: { label: 'Scheduled', tone: 'info' },
    awaiting_approval: { label: 'Awaiting Approval', tone: 'warning' },
    on_hold: { label: 'On Hold', tone: 'warning' },
    approved: { label: 'Approved', tone: 'success' },
    completed: { label: 'Completed', tone: 'success' },
    active: { label: 'Active', tone: 'success' },
    rejected: { label: 'Rejected', tone: 'error' },
    cancelled: { label: 'Cancelled', tone: 'error' },
    failed: { label: 'Failed', tone: 'error' },
    suspended: { label: 'Suspended', tone: 'error' },
  },
  order: {
    pending: { label: 'Pending', tone: 'info' },
    processing: { label: 'Processing', tone: 'info' },
    completed: { label: 'Completed', tone: 'success' },
    cancelled: { label: 'Cancelled', tone: 'error' },
    delivered: { label: 'Delivered', tone: 'success' },
    partially_paid: { label: 'Partially Paid', tone: 'warning' },
    paid: { label: 'Paid', tone: 'success' },
  },
  payment: {
    pending: { label: 'Pending', tone: 'info' },
    partially_paid: { label: 'Partially Paid', tone: 'warning' },
    paid: { label: 'Paid', tone: 'success' },
    failed: { label: 'Failed', tone: 'error' },
    reversed: { label: 'Reversed', tone: 'error' },
  },
  inventory: {
    in_stock: { label: 'In Stock', tone: 'success' },
    low_stock: { label: 'Low Stock', tone: 'warning' },
    out_of_stock: { label: 'Out of Stock', tone: 'error' },
  },
  procurement: {
    draft: { label: 'Draft', tone: 'neutral' },
    awaiting_approval: { label: 'Awaiting Approval', tone: 'warning' },
    approved: { label: 'Approved', tone: 'success' },
    partially_received: { label: 'Partially Received', tone: 'warning' },
    received: { label: 'Received', tone: 'success' },
  },
  finance: {
    reconciled: { label: 'Reconciled', tone: 'success' },
    overdue_soon: { label: 'Overdue-soon', tone: 'warning' },
    overdue: { label: 'Overdue', tone: 'error' },
  }
};

export function getStatusConfig(domain: string, status: string): StatusConfig {
  return statusMap[domain]?.[status] || statusMap['common']?.[status] || { label: status, tone: 'neutral' };
}
