import z from 'zod';

export const priceCardVariantSchema = z.enum(['free', 'pro']);

export const productMetadataSchema = z
  .object({
    price_card_variant: priceCardVariantSchema,
    daily_sessions: z.string().optional(),
    content_families: z.string().optional(),
    support_level: z.enum(['community', 'email', 'priority']),
  })
  .transform((data) => ({
    priceCardVariant: data.price_card_variant,
    dailySessions: data.daily_sessions ? parseInt(data.daily_sessions) : Infinity,
    contentFamilies: data.content_families ? data.content_families.split(',') : ['all'],
    supportLevel: data.support_level,
  }));

export type ProductMetadata = z.infer<typeof productMetadataSchema>;
export type PriceCardVariant = z.infer<typeof priceCardVariantSchema>;
