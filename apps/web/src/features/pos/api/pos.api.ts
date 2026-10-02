import { PosRegister, PosSession } from '../types';

const delay = (ms: number) => new Promise(res => setTimeout(res, ms));

const MOCK_REGISTERS: PosRegister[] = [
  { id: 'reg-1', name: 'Front Counter 1', merchantId: 'mer-1', status: 'Online' },
  { id: 'reg-2', name: 'Front Counter 2', merchantId: 'mer-1', status: 'Offline' },
];

export const getRegisters = async (merchantId: string): Promise<PosRegister[]> => {
  await delay(500);
  return MOCK_REGISTERS.filter(r => r.merchantId === merchantId);
};

export const openSession = async (registerId: string, openingFloat: number, notes?: string): Promise<PosSession> => {
  await delay(800);
  return {
    id: `sess-${Date.now()}`,
    registerId,
    registerName: MOCK_REGISTERS.find(r => r.id === registerId)?.name || 'Register',
    cashierId: 'user-current',
    cashierName: 'Aisha Bello',
    merchantId: 'mer-1',
    openedAt: new Date().toISOString(),
    status: 'Open',
    openingFloat,
    notes
  };
};
