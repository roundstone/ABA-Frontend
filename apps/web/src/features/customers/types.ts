export interface Address {
  id: string;
  label: string;
  street: string;
  city: string;
  state: string;
  lga: string;
  landmark?: string;
  isDefault: boolean;
}

export interface Customer {
  id: string;
  customerNo: string;
  type: 'Individual' | 'Business';
  firstName: string;
  lastName: string;
  companyName?: string;
  rcNumber?: string;
  phone: string;
  email?: string;
  gender?: 'Male' | 'Female' | 'Other';
  dob?: string;
  customerGroup: string;
  merchantId?: string;
  referredBy?: string;
  referralCode: string;
  addresses: Address[];
  creditLimit: number;
  notes?: string;
  status: 'Active' | 'Suspended';
  registeredAt: string;
  
  // Computed / Aggregated for lists
  ordersCount: number;
  totalSpent: number;
  walletBalance: number;
  referralsCount: number;
}
