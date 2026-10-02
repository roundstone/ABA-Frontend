import { ApiError } from '@/lib/api';
import { PortalOrder, PortalWalletTransaction, PortalReferralStat } from './types';
import { mockPortalOrders, mockPortalTransactions, mockPortalReferrals } from './mocks';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function getCustomerOrders(): Promise<{ data: PortalOrder[] }> {
  await delay(500);
  return { data: mockPortalOrders };
}

export async function getCustomerOrderById(id: string): Promise<{ data: PortalOrder }> {
  await delay(500);
  const order = mockPortalOrders.find(o => o.id === id);
  if (!order) {
    throw new ApiError(404, 'Order not found', 'NOT_FOUND');
  }
  return { data: order };
}

export async function getWalletTransactions(): Promise<{ data: PortalWalletTransaction[] }> {
  await delay(400);
  return { data: mockPortalTransactions };
}

export async function getReferralStats(): Promise<{ 
  data: { 
    stats: PortalReferralStat[], 
    metrics: { totalNetwork: number, activeBuyers: number, totalEarned: number } 
  } 
}> {
  await delay(500);
  return { 
    data: {
      stats: mockPortalReferrals,
      metrics: {
        totalNetwork: 24,
        activeBuyers: 18,
        totalEarned: 4550000
      }
    } 
  };
}
