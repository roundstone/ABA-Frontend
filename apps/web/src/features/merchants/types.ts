export type MerchantStatus = 'Pending' | 'Active' | 'Suspended' | 'Rejected' | 'Inactive';
export type MerchantType = 'Own outlet' | 'Franchise' | 'Partner';

export interface BankDetails {
  bankName: string;
  accountNumber: string;
  accountName: string;
}

export interface Merchant {
  id: string;
  merchantNo: string;
  name: string;
  legalName: string;
  type: MerchantType;
  rcNumber?: string;
  logoUrl?: string;
  bannerImage?: string;
  category?: string;
  description?: string;
  isVerified?: boolean;
  
  // Contact
  ownerName: string;
  phone: string;
  email: string;
  website?: string;
  
  // Location
  address: string;
  city: string;
  state: string;
  lga?: string;
  
  // Settlement
  settlementBank: BankDetails;
  settlementFrequency: 'Daily' | 'Weekly' | 'On request';
  
  // Commercial
  priceList: 'Default' | 'Wholesale';
  discountLimit: number;
  creditLimit: number;
  
  status: MerchantStatus;
  onboardedAt: string;
  
  // KPIs
  salesPeriod: number; // 30d sales in Kobo
  ordersCount: number;
  stockValue: number;
  outstandingBalance: number;

  // Ratings
  rating?: number;
  reviewCount?: number;
}
