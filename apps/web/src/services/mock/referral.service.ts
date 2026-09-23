import { TreeNode } from "@/components/NetworkTree";

export interface ReferralRecord {
  id: string;
  referrerId: string;
  referredId: string;
  referralCode: string;
  channel: string;
  createdAt: string;
  status: 'ACTIVE' | 'INACTIVE';
}

// In a real app, this would be a database table.
// For the mock, we'll store it in localStorage or memory.
let mockReferrals: ReferralRecord[] = [
  // Seed some realistic Nigerian names/data
  { id: 'ref_1', referrerId: 'usr_tunde123', referredId: 'usr_ifeoma456', referralCode: 'ABA-1234-SHOE', channel: 'LINK', createdAt: '2026-08-01T10:00:00Z', status: 'ACTIVE' },
  { id: 'ref_2', referrerId: 'usr_bola123', referredId: 'usr_tunde123', referralCode: 'ABA-5678-SHOE', channel: 'LINK', createdAt: '2026-07-15T09:00:00Z', status: 'ACTIVE' },
  { id: 'ref_3', referrerId: 'usr_amaka123', referredId: 'usr_bola123', referralCode: 'ABA-9012-SHOE', channel: 'LINK', createdAt: '2026-06-10T14:00:00Z', status: 'ACTIVE' },
  { id: 'ref_4', referrerId: 'usr_chidi123', referredId: 'usr_ngozi456', referralCode: 'ABA-3456-SHOE', channel: 'LINK', createdAt: '2026-08-05T11:00:00Z', status: 'ACTIVE' },
  { id: 'ref_5', referrerId: 'usr_chidi123', referredId: 'usr_femi789', referralCode: 'ABA-3456-SHOE', channel: 'LINK', createdAt: '2026-08-06T12:00:00Z', status: 'ACTIVE' },
  { id: 'ref_6', referrerId: 'usr_amaka123', referredId: 'usr_chidi123', referralCode: 'ABA-9012-SHOE', channel: 'LINK', createdAt: '2026-06-10T14:30:00Z', status: 'ACTIVE' },
];

export const ReferralService = {
  getReferrals: (): ReferralRecord[] => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('aba_mock_referrals');
      if (stored) return JSON.parse(stored);
      // Initialize with seed data
      localStorage.setItem('aba_mock_referrals', JSON.stringify(mockReferrals));
    }
    return mockReferrals;
  },

  addReferral: (record: Omit<ReferralRecord, 'id' | 'createdAt' | 'status'>) => {
    const newRecord: ReferralRecord = {
      ...record,
      id: `ref_${Math.random().toString(36).substr(2, 9)}`,
      createdAt: new Date().toISOString(),
      status: 'ACTIVE',
    };
    const current = ReferralService.getReferrals();
    const updated = [...current, newRecord];
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_referrals', JSON.stringify(updated));
    }
    mockReferrals = updated;
    return newRecord;
  },

  getUplineChain: (userId: string): { level: number, referrerId: string }[] => {
    const referrals = ReferralService.getReferrals();
    const upline: { level: number, referrerId: string }[] = [];
    
    let currentUserId = userId;
    let level = 1;

    // Traverse upwards
    // To prevent infinite loops in mock data, set a max level (e.g., 20)
    while (level <= 20) {
      const ref = referrals.find(r => r.referredId === currentUserId && r.status === 'ACTIVE');
      if (!ref) break;
      
      upline.push({ level, referrerId: ref.referrerId });
      currentUserId = ref.referrerId;
      level++;
    }

    return upline;
  },

  getDownlineTree: (userId: string): any => { // using any or import the new TreeNode type
    const referrals = ReferralService.getReferrals();
    
    // Helper to generate mock user details from an ID
    const getMockUser = (id: string) => ({
      id,
      name: id.replace('usr_', '').replace(/[0-9]/g, '').replace(/^./, str => str.toUpperCase()) + ' (Mock)',
      role: id === 'usr_amaka123' || id === 'usr_tunde123' ? 'MERCHANT' : 'CUSTOMER',
      commissionsEarned: Math.floor(Math.random() * 50000)
    });

    const buildTree = (currentId: string): any[] => {
      const directDownline = referrals.filter(r => r.referrerId === currentId && r.status === 'ACTIVE');
      return directDownline.map((ref: ReferralRecord) => ({
        user: getMockUser(ref.referredId),
        children: buildTree(ref.referredId)
      }));
    };

    return {
      user: getMockUser(userId),
      children: buildTree(userId)
    };
  }
};
