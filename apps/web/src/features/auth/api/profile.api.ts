import { UpdateProfileInput, ChangePasswordInput } from '../schemas';
import { User, Session } from '../types';

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export const updateProfile = async (data: UpdateProfileInput): Promise<User> => {
  await delay(800);
  return {
    id: 'usr-1',
    name: data.name,
    email: data.email,
    phone: data.phone,
    roles: ['Admin'],
    status: 'Active',
    twoFactorEnabled: false,
    createdAt: new Date().toISOString(),
  };
};

export const changePassword = async (data: ChangePasswordInput): Promise<void> => {
  await delay(800);
  if (data.currentPassword === 'wrong') {
    throw new Error('Current password is incorrect');
  }
};

export const getLoginHistory = async () => {
  await delay(500);
  return [
    { id: '1', time: new Date().toISOString(), device: 'MacBook Pro', ip: '192.168.1.1', location: 'Lagos, NG', result: 'Success' },
    { id: '2', time: new Date(Date.now() - 86400000).toISOString(), device: 'iPhone 13', ip: '10.0.0.1', location: 'Abuja, NG', result: 'Success' },
    { id: '3', time: new Date(Date.now() - 172800000).toISOString(), device: 'Unknown Device', ip: '8.8.8.8', location: 'London, UK', result: 'Failed' },
  ];
};

export const getSessions = async (): Promise<Session[]> => {
  await delay(500);
  return [
    { id: 'sess-1', userId: 'usr-1', device: 'Mac OS - Safari', browser: 'Safari 16.0', ip: '192.168.1.1', lastActive: new Date().toISOString(), isCurrentDevice: true },
    { id: 'sess-2', userId: 'usr-1', device: 'iOS - Chrome', browser: 'Chrome Mobile', ip: '10.0.0.1', lastActive: new Date(Date.now() - 3600000).toISOString(), isCurrentDevice: false },
  ];
};

export const revokeSession = async (sessionId: string): Promise<void> => {
  await delay(500);
};

export const revokeAllOtherSessions = async (): Promise<void> => {
  await delay(800);
};
