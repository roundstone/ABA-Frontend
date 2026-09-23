import { ReferralService } from './referral.service';

export type CommissionStatus = 'PENDING' | 'APPROVED' | 'PAID' | 'REVERSED';
export type CommissionType = 'FLAT_DIRECT' | 'MULTI_LEVEL' | 'TIERED_BY_VOLUME';

export interface CommissionPolicy {
  id: string;
  type: CommissionType;
  levels: number;
  percentages: number[]; // e.g., [10, 5, 2] for 3 levels
  isActive: boolean;
}

export interface CommissionLedgerEntry {
  id: string;
  orderId: string;
  productId: string;
  recipientId: string;
  purchaserId: string;
  amount: number;
  level: number;
  status: CommissionStatus;
  createdAt: string;
}

let mockPolicy: CommissionPolicy = {
  id: 'policy_1',
  type: 'MULTI_LEVEL',
  levels: 3,
  percentages: [10, 5, 2], // 10% for level 1, 5% for level 2, 2% for level 3
  isActive: true,
};

let mockLedger: CommissionLedgerEntry[] = [
  { id: 'com_1', orderId: 'ord_123', productId: 'prd_shoe_1', recipientId: 'usr_tunde123', purchaserId: 'usr_ifeoma456', amount: 1500, level: 1, status: 'APPROVED', createdAt: '2026-09-01T10:00:00Z' },
  { id: 'com_2', orderId: 'ord_123', productId: 'prd_shoe_1', recipientId: 'usr_bola123', purchaserId: 'usr_ifeoma456', amount: 750, level: 2, status: 'APPROVED', createdAt: '2026-09-01T10:00:00Z' },
  { id: 'com_3', orderId: 'ord_123', productId: 'prd_shoe_1', recipientId: 'usr_amaka123', purchaserId: 'usr_ifeoma456', amount: 300, level: 3, status: 'APPROVED', createdAt: '2026-09-01T10:00:00Z' },
];

export const CommissionService = {
  getPolicy: (): CommissionPolicy => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('aba_mock_commission_policy');
      if (stored) return JSON.parse(stored);
      localStorage.setItem('aba_mock_commission_policy', JSON.stringify(mockPolicy));
    }
    return mockPolicy;
  },

  updatePolicy: (policy: CommissionPolicy) => {
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_commission_policy', JSON.stringify(policy));
    }
    mockPolicy = policy;
    return policy;
  },

  getLedger: (): CommissionLedgerEntry[] => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('aba_mock_commission_ledger');
      if (stored) return JSON.parse(stored);
      localStorage.setItem('aba_mock_commission_ledger', JSON.stringify(mockLedger));
    }
    return mockLedger;
  },

  getUserEarnings: (userId: string): CommissionLedgerEntry[] => {
    const ledger = CommissionService.getLedger();
    return ledger.filter(entry => entry.recipientId === userId);
  },

  calculateCommission: (orderId: string, purchaserId: string, productId: string, orderTotal: number) => {
    const policy = CommissionService.getPolicy();
    if (!policy.isActive) return [];

    const upline = ReferralService.getUplineChain(purchaserId);
    if (upline.length === 0) return [];

    const newEntries: CommissionLedgerEntry[] = [];
    
    // Calculate for each eligible level
    for (const up of upline) {
      if (up.level <= policy.levels) {
        const percentage = policy.percentages[up.level - 1] || 0;
        if (percentage > 0) {
          const amount = (orderTotal * percentage) / 100;
          newEntries.push({
            id: `com_${Math.random().toString(36).substr(2, 9)}`,
            orderId,
            productId,
            recipientId: up.referrerId,
            purchaserId,
            amount,
            level: up.level,
            status: 'PENDING',
            createdAt: new Date().toISOString(),
          });
        }
      }
    }

    const currentLedger = CommissionService.getLedger();
    const updatedLedger = [...currentLedger, ...newEntries];
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_commission_ledger', JSON.stringify(updatedLedger));
    }
    mockLedger = updatedLedger;

    return newEntries;
  },

  updateCommissionStatus: (orderId: string, newStatus: CommissionStatus) => {
    const ledger = CommissionService.getLedger();
    const updatedLedger = ledger.map(entry => 
      entry.orderId === orderId ? { ...entry, status: newStatus } : entry
    );
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_commission_ledger', JSON.stringify(updatedLedger));
    }
    mockLedger = updatedLedger;
    return updatedLedger;
  },

  updateCommissionStatusById: (commissionId: string, newStatus: CommissionStatus) => {
    const ledger = CommissionService.getLedger();
    const updatedLedger = ledger.map(entry => 
      entry.id === commissionId ? { ...entry, status: newStatus } : entry
    );
    
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_commission_ledger', JSON.stringify(updatedLedger));
    }
    mockLedger = updatedLedger;
    return updatedLedger;
  }
};
