'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Mail, Lock } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useAuthStore } from '@/features/auth/store';
import { setAuthCookie } from '@/features/auth/actions';

const isMock = process.env.NEXT_PUBLIC_API_MODE === 'mock';

export default function StorefrontLoginPage() {
  const router = useRouter();
  const login = useAuthStore(state => state.login);
  
  const [identifier, setIdentifier] = useState(isMock ? 'jane.doe@example.com' : '');
  const [password, setPassword] = useState(isMock ? 'password123' : '');
  const [isLoading, setIsLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    // Mock login delay
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    await setAuthCookie('mock-customer-token', 'Customer');
    
    login({
      id: 'CUST-100',
      name: 'Jane Doe',
      email: identifier,
      roles: [],
      status: 'Active',
      twoFactorEnabled: false,
      createdAt: new Date().toISOString(),
    }, 'Customer');

    setIsLoading(false);
    router.push('/portal/dashboard');
  };

  return (
    <div className="min-h-[calc(100vh-64px)] flex items-center justify-center bg-surface-1 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8 bg-white p-8 rounded-2xl shadow-sm border border-border">
        
        <div className="text-center">
          <h2 className="text-3xl font-extrabold text-text tracking-tight">Welcome back</h2>
          <p className="mt-2 text-sm text-text-muted">
            Sign in to your ABA Online account to manage orders, referrals, and your wallet.
          </p>
        </div>
        
        <form className="mt-8 space-y-6" onSubmit={handleLogin}>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-text mb-1">Email address or Phone number</label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Mail className="h-5 w-5 text-text-muted" />
                </div>
                <input
                  type="text"
                  required
                  value={identifier}
                  onChange={(e) => setIdentifier(e.target.value)}
                  className="block w-full pl-10 pr-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                  placeholder="jane.doe@example.com"
                />
              </div>
            </div>
            
            <div>
              <div className="flex justify-between items-center mb-1">
                <label className="block text-sm font-medium text-text">Password</label>
                <Link href="/forgot-password" className="text-xs font-medium text-brand-600 hover:underline">
                  Forgot your password?
                </Link>
              </div>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Lock className="h-5 w-5 text-text-muted" />
                </div>
                <input
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="block w-full pl-10 pr-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                  placeholder="••••••••"
                />
              </div>
            </div>
          </div>

          <div className="flex items-center">
            <input
              id="remember-me"
              name="remember-me"
              type="checkbox"
              className="h-4 w-4 text-brand-600 focus:ring-brand-500 border-border rounded"
            />
            <label htmlFor="remember-me" className="ml-2 block text-sm text-text-muted">
              Remember me on this device
            </label>
          </div>

          <Button type="submit" className="w-full h-11 text-base font-semibold" disabled={isLoading}>
            {isLoading ? 'Signing in...' : 'Sign in'}
          </Button>
        </form>

        <div className="mt-6">
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-border" />
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="px-2 bg-white text-text-muted">Don't have an account?</span>
            </div>
          </div>

          <div className="mt-6">
            <Link href="/auth/register" className="w-full flex justify-center py-2 px-4 border border-brand-600 rounded-md shadow-sm text-sm font-medium text-brand-600 bg-white hover:bg-brand-50 transition-colors focus:outline-none">
              Create an account
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
