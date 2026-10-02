import { z } from 'zod';

export const checkoutAddressSchema = z.object({
  fullName: z.string().min(2, 'Full name is required'),
  phone: z.string().min(10, 'Phone number is required'),
  street: z.string().min(5, 'Street address is required'),
  city: z.string().min(2, 'City is required'),
  state: z.string().min(2, 'State is required'),
  zipCode: z.string().optional(),
});

export type CheckoutAddressInput = z.infer<typeof checkoutAddressSchema>;

export const checkoutPaymentSchema = z.object({
  method: z.enum(['wallet', 'card', 'transfer']),
});

export type CheckoutPaymentInput = z.infer<typeof checkoutPaymentSchema>;
