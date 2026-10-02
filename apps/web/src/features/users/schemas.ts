import { z } from 'zod';

export const inviteUserSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Enter a valid email address'),
  roles: z.array(z.string()).min(1, 'Select at least one role'),
  merchantId: z.string().optional(), // If assigning to a specific merchant
});

export type InviteUserInput = z.infer<typeof inviteUserSchema>;

export const updateUserRolesSchema = z.object({
  roles: z.array(z.string()).min(1, 'Select at least one role'),
});

export type UpdateUserRolesInput = z.infer<typeof updateUserRolesSchema>;
