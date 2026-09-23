import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export type UserRole = 'CUSTOMER' | 'DISTRIBUTOR' | 'MERCHANT' | 'SALES' | 'PROCUREMENT' | 'PRODUCTION' | 'STORE' | 'FINANCE' | 'ADMIN' | 'MANAGEMENT' | 'SUPPORT';

export interface User {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  role: UserRole;
  referralCode?: string;
  isVerified: boolean;
}

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  login: (user: User) => void;
  logout: () => void;
  updateUser: (data: Partial<User>) => void;
  switchRole: (role: UserRole) => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null, 
      isAuthenticated: false,
      
      login: (user) => set({ user, isAuthenticated: true }),
      
      logout: () => set({ user: null, isAuthenticated: false }),
      
      updateUser: (data) => set((state) => ({ 
        user: state.user ? { ...state.user, ...data } : null 
      })),

      switchRole: (role) => set((state) => {
        if (!state.user) {
          // If not logged in, create a mock user for that role
          return {
            user: {
              id: `usr_mock_${role.toLowerCase()}`,
              firstName: 'Mock',
              lastName: role.charAt(0) + role.slice(1).toLowerCase(),
              email: `mock${role.toLowerCase()}@aba.com`,
              role,
              isVerified: true,
              referralCode: ['CUSTOMER', 'DISTRIBUTOR'].includes(role) ? `ABA-${Math.floor(Math.random() * 10000)}-SHOE` : undefined,
            },
            isAuthenticated: true,
          };
        }
        return { user: { ...state.user, role } };
      }),
    }),
    {
      name: 'aba-auth-storage',
    }
  )
);
