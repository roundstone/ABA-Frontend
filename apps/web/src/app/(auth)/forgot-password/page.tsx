'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { forgotPasswordSchema, ForgotPasswordInput } from '@/features/auth/schemas';
import { forgotPassword } from '@/features/auth/api/auth.api';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Alert } from '@/components/ui/alert';

export default function ForgotPasswordPage() {
  const [isSuccess, setIsSuccess] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const { register, handleSubmit, formState: { errors } } = useForm<ForgotPasswordInput>({
    resolver: zodResolver(forgotPasswordSchema),
  });

  const onSubmit = async (data: ForgotPasswordInput) => {
    setIsLoading(true);
    try {
      await forgotPassword(data);
      // REQ-02-068: Always show success state
      setIsSuccess(true);
    } catch (err) {
      setIsSuccess(true); // Always show success to prevent enumeration
    } finally {
      setIsLoading(false);
    }
  };

  if (isSuccess) {
    return (
      <div className="w-full flex flex-col space-y-6 text-center">
        <div className="space-y-2">
          <h1 className="text-h1">Check your email</h1>
          <p className="text-body text-text-muted">
            If an account exists, we've sent a reset link to your email address.
          </p>
        </div>
        <div className="pt-4">
          <Link href="/login" className="text-sm font-medium text-primary hover:underline">
            Back to login
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full flex flex-col space-y-6">
      <div className="text-center space-y-2">
        <h1 className="text-h1">Forgot password</h1>
        <p className="text-body text-text-muted">
          Enter your email address to reset your password.
        </p>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <Input
          label="Email address"
          type="email"
          {...register('email')}
          error={errors.email?.message}
          autoComplete="email"
          autoFocus
        />

        <Button type="submit" className="w-full pt-2" disabled={isLoading}>
          {isLoading ? 'Sending...' : 'Send reset link'}
        </Button>
      </form>

      <div className="text-center pt-2">
        <Link href="/login" className="text-sm font-medium text-text-muted hover:text-text">
          Back to login
        </Link>
      </div>
    </div>
  );
}
