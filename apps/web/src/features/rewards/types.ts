export type RewardRule = {
  id: string;
  key: string;
  triggeringEvent: string;
  points: number;
  dailyCap?: number;
  lifetimeCap?: number;
  needsVerifiedPurchase: boolean;
  active: boolean;
};

export type RewardLedgerEntryType = 'earn' | 'redeem' | 'adjust' | 'expire' | 'reverse';
export type RewardLedgerEntryStatus = 'pending' | 'available';

export type RewardLedgerEntry = {
  id: string;
  userId: string;
  type: RewardLedgerEntryType;
  points: number;
  sourceEvent?: string;
  reference?: string;
  balanceAfter: number;
  status: RewardLedgerEntryStatus;
  optionalExpiry?: string;
  createdAt: string;
};

export type RewardSummary = {
  available: number;
  pending: number;
  lifetime: number;
};
