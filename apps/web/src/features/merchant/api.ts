import { API_MODE, fetchApi } from '@/lib/api';
import { MerchantProfile, MerchantReview } from './types';
import { MOCK_MERCHANTS, mockMerchantReviews } from './mocks';
import { Merchant } from '../merchants/types';
import { CreateMerchantInput } from '../merchants/schemas';

const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

type BackendVendor = {
  id: number | string;
  business_name: string;
  business_owner_phone_number: string;
  business_address: string;
  business_owner_name: string;
  business_owner_email: string;
  website?: string | null;
  rc_tax_id?: string | null;
  merchant_type: 1 | 2 | 3;
  status: 1 | 2 | 3 | 4;
  bio?: string | null;
  verified_at?: string | null;
  createdAt?: string;
  created_at?: string;
};

type PaginatedVendors = { data: BackendVendor[] };

function toMerchantType(type: BackendVendor['merchant_type']): Merchant['type'] {
  return type === 1 ? 'Own outlet' : type === 2 ? 'Franchise' : 'Partner';
}

function toMerchantStatus(status: BackendVendor['status']): Merchant['status'] {
  return status === 2 ? 'Active' : status === 3 ? 'Rejected' : status === 4 ? 'Suspended' : 'Pending';
}

function toMerchant(vendor: BackendVendor): Merchant {
  return {
    id: String(vendor.id),
    merchantNo: `VEN-${vendor.id}`,
    name: vendor.business_name,
    legalName: vendor.business_name,
    type: toMerchantType(vendor.merchant_type),
    rcNumber: vendor.rc_tax_id ?? undefined,
    description: vendor.bio ?? undefined,
    isVerified: Boolean(vendor.verified_at),
    ownerName: vendor.business_owner_name,
    phone: vendor.business_owner_phone_number,
    email: vendor.business_owner_email,
    website: vendor.website ?? undefined,
    address: vendor.business_address,
    city: '',
    state: '',
    settlementBank: { bankName: '', accountNumber: '', accountName: vendor.business_owner_name },
    settlementFrequency: 'Weekly',
    priceList: 'Default',
    discountLimit: 0,
    creditLimit: 0,
    status: vendor.verified_at ? 'Active' : toMerchantStatus(vendor.status),
    onboardedAt: vendor.createdAt ?? vendor.created_at ?? new Date().toISOString(),
    salesPeriod: 0,
    ordersCount: 0,
    stockValue: 0,
    outstandingBalance: 0,
  };
}

function toMerchantProfile(vendor: BackendVendor): MerchantProfile {
  const merchant = toMerchant(vendor);

  return {
    ...merchant,
    description: vendor.bio ?? '',
    rating: 0,
    reviewCount: 0,
    joinedDate: merchant.onboardedAt,
    isVerified: Boolean(vendor.verified_at),
    totalProducts: 0,
    location: merchant.address,
    followerCount: 0,
    onTimeDispatch: 0,
    returnRate: 0,
    avgResponseTime: 'Not available',
    monthlyOrderCounts: [],
    isSaved: false,
  };
}

export const getMerchants = async (): Promise<{ data: Merchant[] }> => {
  if (API_MODE !== 'mock') {
    const response = await fetchApi<PaginatedVendors>('/api/v1/vendors?limit=100');
    return { data: response.data.map(toMerchant) };
  }

  await delay(800);
  return { data: MOCK_MERCHANTS };
};

export const getMerchantById = async (id: string): Promise<{ data: MerchantProfile }> => {
  if (API_MODE !== 'mock') {
    const vendor = await fetchApi<BackendVendor>(`/api/v1/vendors/${encodeURIComponent(id)}`);
    return { data: toMerchantProfile(vendor) };
  }

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
  if (API_MODE !== 'mock') {
    const vendor = await fetchApi<BackendVendor>('/api/v1/vendors', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        userId: data.userId,
        businessName: data.name,
        businessOwnerPhoneNumber: data.phone,
        businessAddress: [data.address, data.city, data.state, data.lga].filter(Boolean).join(', '),
        businessOwnerName: data.ownerName,
        businessOwnerEmail: data.email,
        website: data.website || undefined,
        rcTaxId: data.rcNumber || undefined,
        merchantType: data.type === 'Own outlet' ? 1 : data.type === 'Franchise' ? 2 : 3,
      }),
    });

    return { data: toMerchant(vendor) };
  }

  await delay(1000);

  const newMerchant: Merchant = {
    id: `mer-${Date.now()}`,
    merchantNo: `MER-${Math.floor(Math.random() * 9000) + 1000}`,
    ...data,
    settlementBank: { bankName: '', accountNumber: '', accountName: data.legalName },
    settlementFrequency: 'Weekly',
    priceList: 'Default',
    discountLimit: 0,
    creditLimit: 0,
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

export const approveMerchant = async (id: string): Promise<{ data: Merchant }> => {
  if (API_MODE !== 'mock') {
    const vendor = await fetchApi<BackendVendor>(`/api/v1/vendors/${encodeURIComponent(id)}/verify`, {
      method: 'PATCH',
    });
    return { data: toMerchant(vendor) };
  }

  await delay(500);
  const merchant = MOCK_MERCHANTS.find((item) => item.id === id || item.merchantNo === id);
  if (!merchant) throw new Error('Merchant not found');
  merchant.status = 'Active';
  merchant.isVerified = true;
  return { data: merchant };
};

export const suspendMerchant = async (id: string): Promise<{ data: Merchant }> => {
  if (API_MODE !== 'mock') {
    const vendor = await fetchApi<BackendVendor>(`/api/v1/vendors/${encodeURIComponent(id)}/suspend`, {
      method: 'PATCH',
    });
    return { data: toMerchant(vendor) };
  }

  await delay(500);
  const merchant = MOCK_MERCHANTS.find((item) => item.id === id || item.merchantNo === id);
  if (!merchant) throw new Error('Merchant not found');
  merchant.status = 'Suspended';
  return { data: merchant };
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
  void merchantId;
  void payload;
  await delay(600);
  // In a real app this would trigger notifications/emails
  return { data: { success: true } };
}
