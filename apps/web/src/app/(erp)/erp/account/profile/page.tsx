'use client';
import { brand } from '@/config/brand';


import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { updateProfileSchema, UpdateProfileInput } from '@/features/auth/schemas';
import { updateProfile } from '@/features/auth/api/profile.api';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { toast } from 'sonner';

export default function ProfilePage() {
  const [isLoading, setIsLoading] = useState(false);

  const { register, handleSubmit, formState: { errors, isDirty }, setValue } = useForm<UpdateProfileInput>({
    resolver: zodResolver(updateProfileSchema) as any,
    defaultValues: {
      name: 'Admin User',
      email: 'admin@${brand.domain}',
      phone: '+2348000000000',
      language: 'English',
      timezone: 'Africa/Lagos',
    },
  });

  const onSubmit = async (data: UpdateProfileInput) => {
    setIsLoading(true);
    try {
      await updateProfile(data);
      toast.success('Profile updated successfully');
      // If email changed, we would normally notify about re-verification here
    } catch (err: any) {
      toast.error(err.message || 'Failed to update profile');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row sm:items-start gap-8">
        {/* Avatar Section - placeholder for ImageUploader */}
        <div className="flex-shrink-0 flex flex-col items-center gap-4">
          <div className="w-24 h-24 rounded-full bg-surface-2 border border-border flex items-center justify-center text-text-muted text-3xl font-medium">
            AU
          </div>
          <Button variant="outline" size="sm">Change photo</Button>
        </div>

        {/* Form Section */}
        <div className="flex-1 max-w-2xl">
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <Input
                label="Full name"
                {...register('name')}
                error={errors.name?.message}
              />
              <Input
                label="Phone number"
                type="phone"
                {...register('phone')}
                error={errors.phone?.message}
              />
              <div className="sm:col-span-2">
                <Input
                  label="Email address"
                  type="email"
                  {...register('email')}
                  error={errors.email?.message}
                  helperText="Changing your email will require re-verification."
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-sm font-medium leading-none text-text">Language</label>
                <Select defaultValue="English" onValueChange={(val) => setValue('language', val!, { shouldDirty: true })}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select language" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="English">English</SelectItem>
                    <SelectItem value="French">French</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <label className="text-sm font-medium leading-none text-text">Timezone</label>
                <Select defaultValue="Africa/Lagos" onValueChange={(val) => setValue('timezone', val!, { shouldDirty: true })}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select timezone" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Africa/Lagos">Africa/Lagos (GMT+1)</SelectItem>
                    <SelectItem value="UTC">UTC</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="pt-4 flex justify-end">
              <Button type="submit" disabled={!isDirty || isLoading}>
                {isLoading ? 'Saving...' : 'Save changes'}
              </Button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
