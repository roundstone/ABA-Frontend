import type { DirectoryMerchant, DirectoryParams, DirectoryResult, Merchant } from './types';

export interface DirectoryConfig {
  pageSize: number;
  defaultOrder: 'spotlight' | 'newest';
  spotlight: {
    slots: number;
    weights: { sales: number; rating: number; orders: number; verified: number };
    eligibility: { minOrders: number; minRating: number };
  };
}

/** Merchant after public-profile defaults were applied (see mocks `withDirectoryProfile`). */
type ProfiledMerchant = Merchant & {
  rating: number;
  reviewCount: number;
  isVerified: boolean;
  categoryPaths: string[];
};

const isProfiled = (m: Merchant): m is ProfiledMerchant =>
  m.rating !== undefined && m.reviewCount !== undefined && m.isVerified !== undefined && m.categoryPaths !== undefined;

/** Weighted spotlight score 0–100 (Doc 06 §4.2 inputs available today: sales, rating, orders, verified). */
export function computeSpotlightScores(merchants: ProfiledMerchant[], cfg: DirectoryConfig): Map<string, number> {
  const maxSales = Math.max(1, ...merchants.map(m => m.salesPeriod));
  const maxOrders = Math.max(1, ...merchants.map(m => m.ordersCount));
  const w = cfg.spotlight.weights;
  const scores = new Map<string, number>();
  merchants.forEach(m => {
    const score =
      w.sales * (m.salesPeriod / maxSales) +
      w.rating * (m.rating / 5) +
      w.orders * (m.ordersCount / maxOrders) +
      w.verified * (m.isVerified ? 1 : 0);
    scores.set(m.id, Math.round(score * 1000) / 10);
  });
  return scores;
}

export function matchesCategory(m: ProfiledMerchant, category?: string): boolean {
  if (!category) return true;
  return m.categoryPaths.some(p => p === category || p.startsWith(`${category}/`));
}

const byName = (a: Merchant, b: Merchant) => a.name.localeCompare(b.name);

export function queryDirectory(all: Merchant[], params: DirectoryParams, cfg: DirectoryConfig): DirectoryResult {
  // Source is active merchants only (REQ-06-266).
  const active = all.filter(isProfiledActive);
  const scores = computeSpotlightScores(active, cfg);

  const featuredIds = new Set(
    active
      .filter(m => m.ordersCount >= cfg.spotlight.eligibility.minOrders && m.rating >= cfg.spotlight.eligibility.minRating)
      .sort((a, b) => (scores.get(b.id) ?? 0) - (scores.get(a.id) ?? 0) || byName(a, b))
      .slice(0, cfg.spotlight.slots)
      .map(m => m.id)
  );

  const term = params.q?.trim().toLowerCase();
  const filtered = active.filter(m => {
    if (term && ![m.name, m.description ?? '', m.city, m.state].some(v => v.toLowerCase().includes(term))) return false;
    if (!matchesCategory(m, params.category)) return false;
    if (params.state && m.state !== params.state) return false;
    if (params.minRating && m.rating < params.minRating) return false;
    if (params.verifiedOnly && !m.isVerified) return false;
    return true;
  });

  const sort = params.sort ?? 'recommended';
  const useNewest = sort === 'newest' || (sort === 'recommended' && cfg.defaultOrder === 'newest');
  const sorted = [...filtered].sort((a, b) => {
    if (useNewest) return b.onboardedAt.localeCompare(a.onboardedAt) || byName(a, b);
    if (sort === 'rating') return b.rating - a.rating || b.reviewCount - a.reviewCount || byName(a, b);
    if (sort === 'orders') return b.ordersCount - a.ordersCount || byName(a, b);
    return (scores.get(b.id) ?? 0) - (scores.get(a.id) ?? 0) || byName(a, b);
  });

  const pageSize = Math.max(1, params.pageSize ?? cfg.pageSize);
  const totalPages = Math.max(1, Math.ceil(sorted.length / pageSize));
  const page = Math.min(Math.max(1, params.page ?? 1), totalPages);
  const data: DirectoryMerchant[] = sorted.slice((page - 1) * pageSize, page * pageSize).map(m => ({
    ...m,
    spotlightScore: scores.get(m.id) ?? 0,
    isFeatured: featuredIds.has(m.id),
  }));

  return {
    data,
    meta: { page, total: sorted.length, totalPages },
    facets: { states: [...new Set(active.map(m => m.state))].sort() },
  };
}

function isProfiledActive(m: Merchant): m is ProfiledMerchant {
  return m.status === 'Active' && isProfiled(m);
}
