export type SessionStatus = 'Open' | 'Closing' | 'Closed' | 'Force-closed';

export interface PosRegister {
  id: string;
  name: string;
  merchantId: string;
  status: 'Online' | 'Offline';
}

export interface PosSession {
  id: string;
  registerId: string;
  registerName: string;
  cashierId: string;
  cashierName: string;
  merchantId: string;
  
  openedAt: string;
  closedAt?: string;
  status: SessionStatus;
  
  openingFloat: number; // in minor units
  countedCash?: number; // in minor units
  expectedCash?: number; // computed
  
  notes?: string;
}
