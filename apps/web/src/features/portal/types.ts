export interface PortalOrder {
  id: string;
  date: string;
  status: 'Pending' | 'Processing' | 'Shipped' | 'Delivered' | 'Cancelled';
  total: number;
  items: any[];
  shippingAddress: any;
  paymentMethod: string;
}

export interface PortalWalletTransaction {
  id: string;
  type: 'commission' | 'purchase' | 'withdrawal' | 'funding';
  title: string;
  date: string;
  amount: number;
  status: 'Pending' | 'Completed' | 'Failed';
}

export interface PortalReferralStat {
  referredUserId: string;
  referredUserName: string;
  joinedDate: string;
  status: 'Active' | 'Pending Purchase';
  earnings: number;
}
