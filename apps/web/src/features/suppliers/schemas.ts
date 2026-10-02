import { z } from 'zod';

export const createSupplierSchema = z.object({
  companyName: z.string().min(2, 'Company name must be at least 2 characters'),
  type: z.enum(['Local', 'International']),
  taxId: z.string().optional(),
  
  // Contact (Require at least phone or email, handled via superRefine or partial requirement, simplifying here)
  contactPerson: z.string().min(2, 'Contact person is required'),
  phone: z.string().min(8, 'Phone number is required'),
  email: z.string().email('Invalid email address').or(z.literal('')),
  
  // Location
  address: z.string().min(5, 'Address is required'),
  city: z.string().min(2, 'City is required'),
  state: z.string().min(2, 'State is required'),
  country: z.string().min(2, 'Country is required'),
  
  // Commercial
  paymentTerms: z.enum(['Immediate', 'Net 7', 'Net 14', 'Net 30', 'Net 60', 'Custom']).default('Net 30'),
  currency: z.string().default('NGN'),
  incoterms: z.string().optional(),
  leadTimeDays: z.coerce.number().min(0).default(0),
  creditLimit: z.coerce.number().min(0).default(0),
  
  // Bank details (optional)
  bankName: z.string().optional(),
  accountNumber: z.string().optional(),
  accountName: z.string().optional(),
  
  notes: z.string().optional(),
});

export type CreateSupplierInput = z.infer<typeof createSupplierSchema>;
