export type ReferralStatus = 'Registered' | 'Ordered' | 'Pending Qualification' | 'Qualified' | 'Expired' | 'Flagged' | 'Disqualified';
export type ReferralFlagSeverity = 'Low' | 'Med' | 'High';

export interface ReferralRecord {
  id: string;
  referralNumber: string;
  referrerName: string;
  referrerCode: string;
  referredCustomerName: string;
  referredCustomerId: string;
  level: number;
  sourceChannel: string;
  dateReferred: string;
  firstOrderDate?: string;
  firstOrderValue?: number;
  qualifiedDate?: string;
  commissionGenerated?: number;
  status: ReferralStatus;
  flags: number;
}

export interface ReferralCode {
  id: string;
  code: string;
  ownerName: string;
  clicks: number;
  signups: number;
  conversions: number;
  status: 'Active' | 'Disabled';
  createdDate: string;
}

export interface ReferralFlag {
  id: string;
  referralId: string;
  referralNumber: string;
  severity: ReferralFlagSeverity;
  reason: string;
  dateFlagged: string;
  status: 'Open' | 'Cleared' | 'Escalated';
}

export interface NetworkNodeData {
  id: string;
  name: string;
  alias?: string;
  avatar?: string;
  code: string;
  active: boolean;
  joinedDate?: string;
  sales: number; // in kobo (Team sales or total sales)
  personalSales?: number; // in kobo
  downlineCount: number;
  level: number; // calculated depth relative to query root
  performancePercentile?: number; // 0-100
  children?: NetworkNodeData[];
}
