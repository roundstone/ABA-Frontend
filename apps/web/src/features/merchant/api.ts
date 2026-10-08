import { ApiError } from '@/lib/api';
import { MerchantProfile, MerchantReview } from './types';
import { MOCK_MERCHANTS, mockMerchantReviews } from './mocks';
import { Merchant } from '../merchants/types';
import { CreateMerchantInput } from '../merchants/schemas';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export const getMerchants = async (): Promise<{ data: Merchant[] }> => {
  await delay(800);
  return { data: MOCK_MERCHANTS };
};

export const getMerchantById = async (id: string): Promise<{ data: MerchantProfile }> => {
  await delay(500);
  const merchant = MOCK_MERCHANTS.find(m => m.id === id || m.merchantNo === id);
  if (!merchant) throw new Error('Merchant not found');
  
  // Extend with profile properties for the storefront
  const profile: MerchantProfile = {
    ...merchant,
    description: merchant.description || '',
    rating: merchant.rating || 4.5,
    reviewCount: merchant.reviewCount || 10,
    joinedDate: merchant.onboardedAt,
    isVerified: !!merchant.isVerified,
    totalProducts: 45, // Mock data
    location: `${merchant.city}, ${merchant.state}`,
    followerCount: 1540,
    onTimeDispatch: 98,
    returnRate: 2,
    avgResponseTime: 'Under 2 hours',
    monthlyOrderCounts: [
      { month: 'Jan', count: 120 },
      { month: 'Feb', count: 150 },
      { month: 'Mar', count: 200 },
      { month: 'Apr', count: 180 },
    ],
    isSaved: false // Could be dynamic from a saved set
  };
  
  return { data: profile };
};

export const createMerchant = async (data: CreateMerchantInput): Promise<{ data: Merchant }> => {
  await delay(1000);

  const newMerchant: Merchant = {
    id: `mer-${Date.now()}`,
    merchantNo: `MER-${Math.floor(Math.random() * 9000) + 1000}`,
    ...data,
    settlementBank: {
      bankName: data.bankName,
      accountNumber: data.accountNumber,
      accountName: data.legalName, // Mocked resolution
    },
    status: 'Pending',
    onboardedAt: new Date().toISOString(),
    salesPeriod: 0,
    ordersCount: 0,
    stockValue: 0,
    outstandingBalance: 0,
  };

  MOCK_MERCHANTS.unshift(newMerchant);
  return { data: newMerchant };
};


// export async function getMerchantBySlug(slug: string): Promise<{ data: MerchantProfile }> {
//   await delay(400);
//   const merchant = MOCK_MERCHANTS.find(m => m.slug === slug);
//   if (!merchant) {
//     throw new ApiError(404, 'Merchant not found', 'NOT_FOUND');
//   }
//   return { data: merchant };
// }

export async function getMerchantReviews(merchantId: string): Promise<{ data: MerchantReview[] }> {
  await delay(300);
  return { data: mockMerchantReviews[merchantId] || [] };
}

// Storefront Follow/Saved Sellers mock data
let mockSavedSellerIds: string[] = [];

export async function saveSeller(merchantId: string): Promise<{ data: { success: boolean } }> {
  await delay(400);
  if (!mockSavedSellerIds.includes(merchantId)) {
    mockSavedSellerIds.push(merchantId);
  }
  return { data: { success: true } };
}

export async function unsaveSeller(merchantId: string): Promise<{ data: { success: boolean } }> {
  await delay(400);
  mockSavedSellerIds = mockSavedSellerIds.filter(id => id !== merchantId);
  return { data: { success: true } };
}

export async function getSavedSellers(): Promise<{ data: MerchantProfile[] }> {
  await delay(500);
  // Just map from mock merchants
  const saved = MOCK_MERCHANTS.filter(m => mockSavedSellerIds.includes(m.id)).map(merchant => ({
    ...merchant,
    description: merchant.description || '',
    rating: merchant.rating || 4.5,
    reviewCount: merchant.reviewCount || 10,
    joinedDate: merchant.onboardedAt,
    isVerified: !!merchant.isVerified,
    totalProducts: 45,
    location: `${merchant.city}, ${merchant.state}`,
    followerCount: 1541,
    onTimeDispatch: 98,
    returnRate: 2,
    avgResponseTime: 'Under 2 hours',
    monthlyOrderCounts: [],
    isSaved: true
  }));
  return { data: saved };
}

export async function sendMessageToSeller(merchantId: string, payload: { subject: string; message: string }): Promise<{ data: { success: boolean } }> {
  await delay(600);
  // In a real app this would trigger notifications/emails
  return { data: { success: true } };
}
