import { LoginInput, ForgotPasswordInput, ResetPasswordInput } from '../schemas';
import { LoginResponse } from '../types';

// Mock delays
const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

export const login = async (data: LoginInput): Promise<LoginResponse> => {
  await delay(800);
  if (data.identifier === 'locked@aba.com') {
    throw new Error('Account locked. Try again in 15 minutes or reset your password');
  }
  if (data.identifier === 'suspended@aba.com') {
    throw new Error('Your account is suspended. Contact your administrator');
  }
  if (data.identifier === 'wrong@aba.com') {
    throw new Error('Email/phone or password is incorrect');
  }

  return {
    token: 'mock-jwt-token-123',
    user: {
      id: 'usr-1',
      name: 'Admin User',
      email: data.identifier.includes('@') ? data.identifier : 'admin@aba.com',
      roles: ['Admin'],
      status: 'Active',
      twoFactorEnabled: false,
      createdAt: new Date().toISOString(),
    },
    requires2FA: data.identifier === '2fa@aba.com',
  };
};

export const forgotPassword = async (data: ForgotPasswordInput): Promise<void> => {
  await delay(800);
  // Always resolves successfully as per specs
};

export const resetPassword = async (data: ResetPasswordInput, token: string): Promise<void> => {
  await delay(800);
  if (token === 'expired') {
    throw new Error('Token is expired or invalid');
  }
};
