import { z } from 'zod';

export const categorySchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  slug: z.string().min(2, 'Slug must be at least 2 characters').regex(/^[a-z0-9-]+$/, 'Slug must be lowercase alphanumeric and dashes only'),
  parentId: z.string().optional().nullable(),
  image: z.string().url('Must be a valid URL').optional().or(z.literal('')),
  icon: z.string().optional().or(z.literal('')),
  sortOrder: z.number().int().optional().default(0),
  status: z.enum(['active', 'inactive']).optional().default('active'),
  showInMenu: z.boolean().optional().default(true),
  featuredMerchantIds: z.array(z.string()).max(4, 'Maximum 4 featured merchants').optional().default([]),
});

export type CategoryFormValues = z.input<typeof categorySchema>;
