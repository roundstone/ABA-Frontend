import { z } from 'zod';

export const updateSectionSchema = z.object({
  content: z.string().min(1, 'Content cannot be empty'),
});

export type UpdateSectionInput = z.infer<typeof updateSectionSchema>;
