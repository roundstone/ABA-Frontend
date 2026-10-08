import { brand } from '@/config/brand';
import { NetworkNodeData, ReferralRecord, ReferralCode, ReferralFlag } from './types';

export const mockNetworkUsers: Record<string, NetworkNodeData> = {
  [`${brand.referralCodePrefix}492`]: {
    id: `${brand.referralCodePrefix}492`,
    name: 'Aisha Bello',
    alias: 'AB_Hustle',
    code: `${brand.referralCodePrefix}492`,
    active: true,
    joinedDate: '2025-06-12T10:00:00Z',
    sales: 450000000,
    personalSales: 10000000,
    downlineCount: 24,
    level: 0,
    performancePercentile: 95,
    children: [
      {
        id: `${brand.referralCodePrefix}881`,
        name: 'Michael Okon',
        alias: 'MikeO',
        code: `${brand.referralCodePrefix}881`,
        active: true,
        joinedDate: '2025-08-20T10:00:00Z',
        sales: 120500000,
        personalSales: 5000000,
        downlineCount: 8,
        level: 1,
        performancePercentile: 85,
        children: []
      }
    ]
  },
};

export const mockReferralRecords: ReferralRecord[] = [
  {
    id: 'ref-1',
    referralNumber: 'REF-2026-001',
    referrerName: 'Aisha Bello',
    referrerCode: `${brand.referralCodePrefix}492`,
    referredCustomerName: 'Sarah Jane',
    referredCustomerId: 'cust-1',
    level: 1,
    sourceChannel: 'Link',
    dateReferred: '2026-09-01T10:00:00Z',
    firstOrderDate: '2026-09-02T14:30:00Z',
    firstOrderValue: 4500000,
    qualifiedDate: '2026-09-02T14:30:00Z',
    commissionGenerated: 225000,
    status: 'Qualified',
    flags: 0
  },
  {
    id: 'ref-2',
    referralNumber: 'REF-2026-002',
    referrerName: 'Aisha Bello',
    referrerCode: `${brand.referralCodePrefix}492`,
    referredCustomerName: 'David Mark',
    referredCustomerId: 'cust-2',
    level: 1,
    sourceChannel: 'Code at Checkout',
    dateReferred: '2026-09-10T09:15:00Z',
    status: 'Registered',
    flags: 0
  },
  {
    id: 'ref-3',
    referralNumber: 'REF-2026-003',
    referrerName: 'Michael Okon',
    referrerCode: `${brand.referralCodePrefix}881`,
    referredCustomerName: 'Suspicious User',
    referredCustomerId: 'cust-3',
    level: 1,
    sourceChannel: 'QR Code',
    dateReferred: '2026-09-28T11:00:00Z',
    firstOrderDate: '2026-09-28T11:05:00Z',
    firstOrderValue: 15000000,
    status: 'Flagged',
    flags: 2
  }
];

export const mockReferralCodes: ReferralCode[] = [
  {
    id: 'code-1',
    code: `${brand.referralCodePrefix}492`,
    ownerName: 'Aisha Bello',
    clicks: 1450,
    signups: 42,
    conversions: 24,
    status: 'Active',
    createdDate: '2025-06-12T10:00:00Z'
  },
  {
    id: 'code-2',
    code: `${brand.referralCodePrefix}881`,
    ownerName: 'Michael Okon',
    clicks: 890,
    signups: 15,
    conversions: 8,
    status: 'Active',
    createdDate: '2025-08-20T10:00:00Z'
  }
];

export const mockReferralFlags: ReferralFlag[] = [
  {
    id: 'flag-1',
    referralId: 'ref-3',
    referralNumber: 'REF-2026-003',
    severity: 'High',
    reason: 'IP address matches referrer; rapid order placement',
    dateFlagged: '2026-09-28T11:10:00Z',
    status: 'Open'
  }
];
