'use client';
import { brand } from '@/config/brand';


import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { Mail, Lock, Phone, User, Users } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { signup } from '@/features/auth/api/auth.api';
import { SignupInput, signupSchema } from '@/features/auth/schemas';

import { Suspense } from 'react';

function StorefrontRegisterContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const refCodeParam = searchParams.get('ref');
  
  const [formData, setFormData] = useState({
    first_name: '',
    middle_name: '',
    last_name: '',
    email: '',
    phone: '',
    password: '',
    confirm_password: '',
    referralCode: refCodeParam || '',
    acceptTerms: false
  });
  
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    const parsed = signupSchema.safeParse(formData);

    if (!parsed.success) {
      setError(parsed.error.issues[0]?.message ?? 'Please check the form and try again.');
      return;
    }

    setIsLoading(true);
    try {
      await signup(parsed.data satisfies SignupInput);
      router.push('/auth/login?registered=1');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unable to create your account.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-[calc(100vh-64px)] flex items-center justify-center bg-surface-1 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-xl w-full space-y-8 bg-white p-8 md:p-10 rounded-2xl shadow-sm border border-border">
        
        <div className="text-center">
          <h2 className="text-3xl font-extrabold text-text tracking-tight">Create your account</h2>
          <p className="mt-2 text-sm text-text-muted">
            Join the {brand.name} community. Shop, refer friends, and earn commissions.
          </p>
        </div>

        {error && <p className="rounded-md border border-destructive/30 bg-destructive/10 p-3 text-sm text-destructive">{error}</p>}
        
        <form className="mt-8 space-y-6" onSubmit={handleRegister}>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-text mb-1">First name</label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <User className="h-5 w-5 text-text-muted" />
                </div>
                <input
                  type="text"
                  name="first_name"
                  required
                  value={formData.first_name}
                  onChange={handleChange}
                  className="block w-full pl-10 pr-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                  placeholder="Jane"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-text mb-1">Middle name</label>
                <input
                  type="text"
                  name="middle_name"
                  required
                  value={formData.middle_name}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                  placeholder="Ada"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-text mb-1">Last name</label>
                <input
                  type="text"
                  name="last_name"
                  required
                  value={formData.last_name}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                  placeholder="Doe"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-text mb-1">Email address</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <Mail className="h-5 w-5 text-text-muted" />
                  </div>
                  <input
                    type="email"
                    name="email"
                    required
                    value={formData.email}
                    onChange={handleChange}
                    className="block w-full pl-10 pr-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                    placeholder="jane@example.com"
                  />
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-text mb-1">Phone number</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <Phone className="h-5 w-5 text-text-muted" />
                  </div>
                  <input
                    type="tel"
                    name="phone"
                    required
                    value={formData.phone}
                    onChange={handleChange}
                    className="block w-full pl-10 pr-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                    placeholder="+234 800 000 0000"
                  />
                </div>
              </div>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-text mb-1">Password</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <Lock className="h-5 w-5 text-text-muted" />
                  </div>
                  <input
                    type="password"
                    name="password"
                    required
                    value={formData.password}
                    onChange={handleChange}
                    className="block w-full pl-10 pr-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                    placeholder="••••••••"
                  />
                </div>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-text mb-1">Confirm Password</label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <Lock className="h-5 w-5 text-text-muted" />
                  </div>
                  <input
                    type="password"
                    name="confirm_password"
                    required
                    value={formData.confirm_password}
                    onChange={handleChange}
                    className="block w-full pl-10 pr-3 py-2 border border-border rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-surface-1 sm:text-sm"
                    placeholder="••••••••"
                  />
                </div>
              </div>
            </div>

            <div className="pt-2">
              <label className="block text-sm font-medium text-text mb-1">Referral Code (Optional)</label>
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Users className="h-5 w-5 text-brand-500" />
                </div>
                <input
                  type="text"
                  name="referralCode"
                  value={formData.referralCode}
                  onChange={handleChange}
                  className="block w-full pl-10 pr-3 py-2 border border-brand-200 rounded-md text-text focus:outline-none focus:ring-2 focus:ring-brand-500 bg-brand-50 sm:text-sm uppercase"
                  placeholder={`e.g., $${brand.referralCodePrefix}JANE-123`}
                />
              </div>
              {formData.referralCode && (
                <p className="mt-1 text-xs text-success-main font-medium">Referral code applied!</p>
              )}
            </div>
          </div>

          <div className="flex items-start mt-4">
            <div className="flex items-center h-5">
              <input
                id="acceptTerms"
                name="acceptTerms"
                type="checkbox"
                required
                checked={formData.acceptTerms}
                onChange={handleChange}
                className="h-4 w-4 text-brand-600 focus:ring-brand-500 border-border rounded"
              />
            </div>
            <div className="ml-2 text-sm">
              <label htmlFor="acceptTerms" className="text-text-muted">
                I agree to the <a href="#" className="font-medium text-brand-600 hover:underline">Terms of Service</a> and <a href="#" className="font-medium text-brand-600 hover:underline">Privacy Policy</a>.
              </label>
            </div>
          </div>

          <Button type="submit" className="w-full h-11 text-base font-semibold" disabled={isLoading || !formData.acceptTerms}>
            {isLoading ? 'Creating account...' : 'Create Account'}
          </Button>
        </form>

        <div className="mt-6 text-center text-sm text-text-muted">
          Already have an account?{' '}
          <Link href="/auth/login" className="font-medium text-brand-600 hover:underline">
            Log in instead
          </Link>
        </div>
      </div>
    </div>
  );
}

export default function StorefrontRegisterPage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <StorefrontRegisterContent />
    </Suspense>
  );
}
