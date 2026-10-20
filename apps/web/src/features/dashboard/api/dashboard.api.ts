
import { API_MODE, fetchApi } from '@/lib/api';

export type DashboardData = {
  scope: 'vendor' | 'organization';
  products: {
    total: number;
    active: number;
    lowStock: number;
    outOfStock: number;
  };
  sales: {
    orderCount: number;
    revenue: number;
  };
};

export const getDashboardData = async (): Promise<DashboardData> => {
  if (API_MODE !== 'mock') {
    return fetchApi<DashboardData>('/api/v1/dashboard');
  }

  return {
    scope: 'organization',
    products: { total: 0, active: 0, lowStock: 0, outOfStock: 0 },
    sales: { orderCount: 0, revenue: 0 },
  };
};

export const getWidgetData = async () => ({});
