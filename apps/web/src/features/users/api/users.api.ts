import { brand } from '@/config/brand';
import { User } from '@/features/auth/types';
import { InviteUserInput, UpdateUserRolesInput } from '../schemas';

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

// Mock Data
const MOCK_USERS: User[] = [
  { id: 'usr-1', name: 'Admin User', email: 'admin@buynigeria.example.com', phone: '+2348000000000', roles: ['Super Admin'], status: 'Active', twoFactorEnabled: true, createdAt: '2026-09-01T10:00:00Z', lastActive: '2026-09-30T10:00:00Z' },
  { id: 'usr-2', name: 'John Auditor', email: 'john@buynigeria.example.com', roles: ['Auditor'], status: 'Active', twoFactorEnabled: false, createdAt: '2026-09-10T10:00:00Z' },
  { id: 'usr-3', name: 'Jane Merchant', email: 'jane@merchant.com', merchantId: 'mch-1', roles: ['Merchant user'], status: 'Invited', twoFactorEnabled: false, createdAt: '2026-09-20T10:00:00Z' },
  { id: 'usr-4', name: 'Suspended Staff', email: 'staff@buynigeria.example.com', roles: ['Staff'], status: 'Suspended', twoFactorEnabled: false, createdAt: '2026-08-01T10:00:00Z' },
];

export const getUsers = async (): Promise<User[]> => {
  await delay(800);
  return MOCK_USERS;
};

export const getUserById = async (id: string): Promise<User> => {
  await delay(500);
  const user = MOCK_USERS.find(u => u.id === id);
  if (!user) throw new Error('User not found');
  return user;
};

export const inviteUser = async (data: InviteUserInput): Promise<User> => {
  await delay(800);
  if (data.email === 'error@buynigeria.example.com') throw new Error('Email already in use');
  
  return {
    id: `usr-${Date.now()}`,
    name: data.name,
    email: data.email,
    roles: data.roles as any[],
    merchantId: data.merchantId,
    status: 'Invited',
    twoFactorEnabled: false,
    createdAt: new Date().toISOString(),
  };
};

export const updateUserRoles = async (id: string, data: UpdateUserRolesInput): Promise<void> => {
  await delay(500);
  // Mock success
};

export const suspendUser = async (id: string, reason: string): Promise<void> => {
  await delay(500);
};

export const activateUser = async (id: string): Promise<void> => {
  await delay(500);
};

export const resendInvite = async (id: string): Promise<void> => {
  await delay(500);
};
