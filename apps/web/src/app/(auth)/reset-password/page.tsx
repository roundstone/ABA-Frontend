'use client';

import { useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { resetPasswordSchema, ResetPasswordInput } from '@/features/auth/schemas';
import { resetPassword } from '@/features/auth/api/auth.api';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/alert';
import { toast } from 'sonner';

import { Suspense } from 'react';

function ResetPasswordContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams.get('token') || '';
  
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const { register, handleSubmit, formState: { errors }, watch } = useForm<ResetPasswordInput>({
    resolver: zodResolver(resetPasswordSchema),
  });

  const watchPassword = watch('password', '');
  
  // Basic strength meter
  const calculateStrength = (pwd: string) => {
    let strength = 0;
    if (pwd.length >= 10) strength += 25;
    if (/[A-Z]/.test(pwd)) strength += 25;
    if (/[a-z]/.test(pwd)) strength += 25;
    if (/[0-9]/.test(pwd)) strength += 25;
    return strength;
  };
  const strength = calculateStrength(watchPassword);
  
  const getStrengthColor = (strength: number) => {
    if (strength === 0) return 'bg-border';
    if (strength < 50) return 'bg-error';
    if (strength < 100) return 'bg-warning';
    return 'bg-success';
  };

  const onSubmit = async (data: ResetPasswordInput) => {
    setIsLoading(true);
    setError(null);
    try {
      await resetPassword(data, token);
      toast.success('Password reset successfully');
      router.push('/login');
    } catch (err: any) {
      setError(err.message || 'An error occurred during password reset');
    } finally {
      setIsLoading(false);
    }
  };

  if (error === 'Token is expired or invalid') {
    return (
      <div className="w-full flex flex-col space-y-6 text-center">
        <div className="mx-auto w-12 h-12 rounded-full bg-error-bg flex items-center justify-center text-error mb-2">
          {/* Using a simple X or icon placeholder */}
          <span className="text-xl font-bold">!</span>
        </div>
        <div className="space-y-2">
          <h1 className="text-h2 text-error">Link expired</h1>
          <p className="text-body text-text-muted">
            This password reset link has expired or is invalid.
          </p>
        </div>
        <div className="pt-4">
          <Link href="/forgot-password">
            <Button className="w-full">Request new link</Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full flex flex-col space-y-6">
      <div className="text-center space-y-2">
        <h1 className="text-h1">Reset password</h1>
        <p className="text-body text-text-muted">Enter your new password below</p>
      </div>

      {error && (
        <Alert variant="destructive">
          {error}
        </Alert>
      )}

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div className="space-y-1">
          <Input
            label="New password"
            type="password"
            {...register('password')}
            error={errors.password?.message}
          />
          {watchPassword && (
            <div className="pt-1 space-y-1">
              <div className="h-1.5 w-full bg-surface-2 rounded-full overflow-hidden">
                <div 
                  className={`h-full transition-all duration-300 ${getStrengthColor(strength)}`} 
                  style={{ width: `${strength}%` }}
                />
              </div>
              <p className="text-helper">
                {strength < 100 ? 'Password needs to be stronger' : 'Strong password'}
              </p>
            </div>
          )}
        </div>

        <Input
          label="Confirm password"
          type="password"
          {...register('confirmPassword')}
          error={errors.confirmPassword?.message}
        />

        <Button type="submit" className="w-full pt-2" disabled={isLoading || !token}>
          {isLoading ? 'Resetting...' : 'Reset password'}
        </Button>
      </form>
    </div>
  );
}

export default function ResetPasswordPage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <ResetPasswordContent />
    </Suspense>
  );
}
