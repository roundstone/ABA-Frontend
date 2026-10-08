/**
 * Unit tests for the merchants directory rules (Doc 06 §6, REQ-06-242..268, 677..682).
 * Run:  npx tsx src/features/merchants/directory.test.ts
 */
import assert from 'node:assert/strict';
import { queryDirectory, type DirectoryConfig } from './directory';
import { generatedDirectoryMerchants, withDirectoryProfile } from './directoryMocks';
import { MOCK_MERCHANTS } from '../merchant/mocks';

const all = [...MOCK_MERCHANTS, ...generatedDirectoryMerchants].map(withDirectoryProfile);
const cfg: DirectoryConfig = {
  pageSize: 24,
  defaultOrder: 'spotlight',
  spotlight: { slots: 6, weights: { sales: 0.4, rating: 0.3, orders: 0.2, verified: 0.1 }, eligibility: { minOrders: 20, minRating: 4 } },
};
const run = (name: string, fn: () => void) => { fn(); console.log(`ok  ${name}`); };

run('seed has 40+ merchants with every status', () => {
  assert.ok(all.length >= 40);
  for (const s of ['Active', 'Pending', 'Suspended', 'Inactive', 'Rejected']) assert.ok(all.some(m => m.status === s), s);
});

run('source is active merchants only', () => {
  const r = queryDirectory(all, { pageSize: 500 }, cfg);
  assert.ok(r.data.every(m => m.status === 'Active'));
  assert.equal(r.meta.total, all.filter(m => m.status === 'Active').length);
});

run('paginates by 24 and clamps page', () => {
  const r1 = queryDirectory(all, { page: 1 }, cfg);
  assert.equal(r1.data.length, Math.min(24, r1.meta.total ?? 0));
  assert.ok(r1.meta.totalPages >= 2);
  const far = queryDirectory(all, { page: 999 }, cfg);
  assert.equal(far.meta.page, far.meta.totalPages);
});

run('recommended = spotlight score desc; setting switches to newest', () => {
  const r = queryDirectory(all, { pageSize: 500 }, cfg);
  for (let i = 1; i < r.data.length; i++) assert.ok(r.data[i - 1].spotlightScore >= r.data[i].spotlightScore);
  const n = queryDirectory(all, { pageSize: 500 }, { ...cfg, defaultOrder: 'newest' });
  for (let i = 1; i < n.data.length; i++) assert.ok(n.data[i - 1].onboardedAt >= n.data[i].onboardedAt);
});

run('sorts: newest, rating, orders', () => {
  const rating = queryDirectory(all, { sort: 'rating', pageSize: 500 }, cfg).data;
  for (let i = 1; i < rating.length; i++) assert.ok(rating[i - 1].rating >= rating[i].rating);
  const orders = queryDirectory(all, { sort: 'orders', pageSize: 500 }, cfg).data;
  for (let i = 1; i < orders.length; i++) assert.ok(orders[i - 1].ordersCount >= orders[i].ordersCount);
  const newest = queryDirectory(all, { sort: 'newest', pageSize: 500 }, cfg).data;
  for (let i = 1; i < newest.length; i++) assert.ok(newest[i - 1].onboardedAt >= newest[i].onboardedAt);
});

run('filters: search, state, rating, verified, category (incl. sub-category prefix)', () => {
  const s = queryDirectory(all, { q: 'aba leather', pageSize: 500 }, cfg).data;
  assert.ok(s.length >= 1 && s.every(m => /aba leather/i.test(m.name + m.description)));
  const st = queryDirectory(all, { state: 'Lagos', pageSize: 500 }, cfg).data;
  assert.ok(st.length > 0 && st.every(m => m.state === 'Lagos'));
  const rt = queryDirectory(all, { minRating: 4.5, pageSize: 500 }, cfg).data;
  assert.ok(rt.every(m => m.rating >= 4.5));
  const v = queryDirectory(all, { verifiedOnly: true, pageSize: 500 }, cfg).data;
  assert.ok(v.length > 0 && v.every(m => m.isVerified));
  const sample = queryDirectory(all, { pageSize: 500 }, cfg).data[0].categoryPaths[0];
  const root = sample.split('/')[0];
  const c = queryDirectory(all, { category: root, pageSize: 500 }, cfg).data;
  assert.ok(c.length > 0 && c.every(m => m.categoryPaths.some(p => p === root || p.startsWith(`${root}/`))));
});

run('Featured badge: at most `slots`, eligible only', () => {
  const featured = queryDirectory(all, { pageSize: 500 }, cfg).data.filter(m => m.isFeatured);
  assert.ok(featured.length > 0 && featured.length <= 6);
  assert.ok(featured.every(m => m.ordersCount >= 20 && m.rating >= 4));
});

run('filtered-empty returns zero rows and one page', () => {
  const r = queryDirectory(all, { q: 'zzzz-not-a-business' }, cfg);
  assert.equal(r.data.length, 0);
  assert.equal(r.meta.totalPages, 1);
});

run('deterministic', () => {
  assert.deepEqual(queryDirectory(all, {}, cfg), queryDirectory(all, {}, cfg));
});
