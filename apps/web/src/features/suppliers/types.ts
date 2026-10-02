export type SupplierStatus = 'Active' | 'On hold' | 'Inactive' | 'Blacklisted';
export type SupplierType = 'Local' | 'International';
export type PaymentTerms = 'Immediate' | 'Net 7' | 'Net 14' | 'Net 30' | 'Net 60' | 'Custom';

export interface BankDetails {
  bankName: string;
  accountNumber: string;
  accountName: string;
}

export interface Supplier {
  id: string;
  supplierNo: string;
  companyName: string;
  type: SupplierType;
  taxId?: string;
  categories: string[]; // e.g., 'Fabric', 'Dyes', 'Packaging'
  
  // Contact
  contactPerson: string;
  phone: string;
  email: string;
  
  // Location
  address: string;
  city: string;
  state: string;
  country: string;
  
  // Commercial
  paymentTerms: PaymentTerms;
  currency: string;
  incoterms?: string; // e.g. FOB, CIF (for international)
  leadTimeDays: number;
  creditLimit: number;
  bankDetails?: BankDetails;
  
  notes?: string;
  status: SupplierStatus;
  
  // KPIs
  totalPurchases12m: number;
  outstandingBalance: number;
  overduePayable: number;
  rating: number; // 0.0 to 5.0
}
