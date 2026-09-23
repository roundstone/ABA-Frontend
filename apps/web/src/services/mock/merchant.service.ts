export interface Merchant {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  avatar: string;
  products: number;
  storeName: string;
  createDate: string;
  walletBalance: number;
  revenue: number;
}

// Mock Data
let mockVendors: Merchant[] = [
  {
    id: 'vnd_1',
    firstName: 'Petey',
    lastName: 'Cruiser',
    email: 'petey.cruiser@warephase.com',
    avatar: '/images/team/2.jpg',
    products: 1670,
    storeName: 'Warephase',
    createDate: '8/10/18',
    walletBalance: 576132,
    revenue: 9761266
  },
  {
    id: 'vnd_2',
    firstName: 'Rowan',
    lastName: 'Torres',
    email: 'rowan.torres@sunnamplex.com',
    avatar: '/images/dashboard/user5.jpg',
    products: 790,
    storeName: 'Sunnamplex',
    createDate: '5/6/18',
    walletBalance: 87610,
    revenue: 631479
  },
  {
    id: 'vnd_3',
    firstName: 'Gray',
    lastName: 'Brody',
    email: 'gray.brody@qoodo.com',
    avatar: '/images/dashboard/boy-2.png',
    products: 974,
    storeName: 'Qoodo',
    createDate: '12/5/18',
    walletBalance: 32615,
    revenue: 2311479
  }
];

export const VendorService = {
  getVendors: (): Merchant[] => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem('aba_mock_vendors');
      if (stored) return JSON.parse(stored);
      localStorage.setItem('aba_mock_vendors', JSON.stringify(mockVendors));
    }
    return mockVendors;
  },

  createVendor: (vendorData: Omit<Merchant, 'id' | 'createDate' | 'avatar' | 'products' | 'walletBalance' | 'revenue'>): Merchant => {
    const newVendor: Merchant = {
      ...vendorData,
      id: `vnd_${Math.random().toString(36).substr(2, 9)}`,
      createDate: new Date().toLocaleDateString(),
      avatar: '/images/dashboard/user.jpg', // Default avatar
      products: 0,
      walletBalance: 0,
      revenue: 0
    };

    const merchants = VendorService.getVendors();
    const updatedVendors = [newVendor, ...merchants];
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_vendors', JSON.stringify(updatedVendors));
    }
    mockVendors = updatedVendors;
    
    return newVendor;
  },

  deleteVendor: (vendorId: string): void => {
    const merchants = VendorService.getVendors();
    const updatedVendors = merchants.filter(v => v.id !== vendorId);
    if (typeof window !== 'undefined') {
      localStorage.setItem('aba_mock_vendors', JSON.stringify(updatedVendors));
    }
    mockVendors = updatedVendors;
  }
};
