import { z } from 'zod';

export const createMerchantSchema = z.object({
  // Business
  name: z.string().min(2, 'Name must be at least 2 characters'),
  legalName: z.string().min(2, 'Legal name is required'),
  type: z.enum(['Own outlet', 'Franchise', 'Partner']),
  rcNumber: z.string().optional(),
  category: z.string().optional(),
  
  // Contact
  ownerName: z.string().min(2, 'Owner name is required'),
  phone: z.string().regex(/^\+?234\d{10}$/, 'Must be a valid Nigerian phone number starting with +234 or 234'),
  email: z.string().email('Invalid email address'),
  website: z.string().url('Invalid URL').optional().or(z.literal('')),
  
  // Location
  address: z.string().min(5, 'Address is required'),
  city: z.string().min(2, 'City is required'),
  state: z.string().min(2, 'State is required'),
  lga: z.string().optional(),
  
  // Settlement
  bankName: z.string().min(1, 'Select a bank'),
  accountNumber: z.string().length(10, 'Account number must be exactly 10 digits'),
  settlementFrequency: z.enum(['Daily', 'Weekly', 'On request']).default('Weekly'),
  
  // Commercial
  priceList: z.enum(['Default', 'Wholesale']).default('Default'),
  discountLimit: z.coerce.number().min(0).max(100).default(0),
  creditLimit: z.coerce.number().min(0).default(0),
  
  // Access (Stub)
  createOwnerLogin: z.boolean().default(true),
});

export type CreateMerchantInput = z.infer<typeof createMerchantSchema>;
