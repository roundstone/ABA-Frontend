import { z } from 'zod';

export const addressSchema = z.object({
  label: z.string().min(1, 'Label is required'),
  street: z.string().min(1, 'Street is required'),
  city: z.string().min(1, 'City is required'),
  state: z.string().min(1, 'State is required'),
  lga: z.string().min(1, 'LGA is required'),
  landmark: z.string().optional(),
  isDefault: z.boolean().default(false),
});

export const createCustomerSchema = z.object({
  type: z.enum(['Individual', 'Business']),
  firstName: z.string().min(2, 'First name must be at least 2 characters'),
  lastName: z.string().min(2, 'Last name must be at least 2 characters'),
  companyName: z.string().optional(),
  rcNumber: z.string().optional(),
  phone: z.string().regex(/^\+?234\d{10}$/, 'Must be a valid Nigerian phone number starting with +234 or 234'),
  email: z.string().email('Invalid email address').optional().or(z.literal('')),
  gender: z.enum(['Male', 'Female', 'Other']).optional(),
  dob: z.string().optional(),
  customerGroup: z.string().default('Retail'),
  merchantId: z.string().optional(),
  referredBy: z.string().optional(),
  addresses: z.array(addressSchema).optional(),
  creditLimit: z.coerce.number().min(0).default(0),
  notes: z.string().max(500).optional(),
  createPortalLogin: z.boolean().default(false),
}).refine(data => {
  if (data.type === 'Business' && !data.companyName) return false;
  return true;
}, {
  message: "Company name is required for Business customers",
  path: ["companyName"]
});

export type CreateCustomerInput = z.infer<typeof createCustomerSchema>;
