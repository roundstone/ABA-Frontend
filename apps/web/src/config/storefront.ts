/**
 * Storefront configuration (Doc 06 §6, §4.2, Doc 05 §18).
 * Business rules that the spec marks as configurable live here, never inline in components.
 * TODO(REQ-06 §4): the Spotlight admin screen (`/admin/spotlight`) will own the spotlight values.
 */
export const storefrontConfig = {
  merchantDirectory: {
    /** Pagination size on `/merchants` (REQ-06-263). */
    pageSize: 24,
    /** `spotlight` = order by spotlight score, `newest` = order by onboarding date (REQ-06-267/268). */
    defaultOrder: 'spotlight' as 'spotlight' | 'newest',
  },
  meetBusinesses: {
    /** Autoplay is off by default (REQ-06-250). */
    autoplay: false,
    autoplayIntervalMs: 6000,
    /** Max merchants loaded into the carousel. */
    limit: 12,
  },
  spotlight: {
    /** Number of merchants carrying the Featured badge. */
    slots: 6,
    weights: { sales: 0.4, rating: 0.3, orders: 0.2, verified: 0.1 },
    eligibility: { minOrders: 20, minRating: 4.0 },
  },
} as const;
