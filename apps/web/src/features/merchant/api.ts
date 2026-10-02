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

export const getMerchantById = async (id: string): Promise<{ data: Merchant }> => {
  await delay(500);
  const merchant = MOCK_MERCHANTS.find(m => m.id === id);
  if (!merchant) throw new Error('Merchant not found');
  return { data: merchant };
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
