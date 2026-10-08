import { mockShopCategories } from '../category/mocks';
import type { Category } from '../category/types';
import type { Merchant, MerchantStatus, MerchantType } from './types';

/**
 * Deterministic directory fixtures (Doc 06 §6, mock seeding: 40+ rows, every status, edge cases).
 * No randomness: the same input always yields the same merchants.
 */

const hash = (s: string): number => {
  let h = 7;
  for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
  return h;
};

const LOGOS = [
  'photo-1472851294608-062f824d29cc',
  'photo-1542838132-92c53300491e',
  'photo-1445205170230-053b83016050',
  'photo-1441986300917-64674bd600d8',
  'photo-1556742049-0cfed4f6a45d',
  'photo-1604719312566-8912e9227c6a',
];
const BANNERS = [
  'photo-1519389950473-47ba0277781c',
  'photo-1578916171728-46686eac8d58',
  'photo-1441986300917-64674bd600d8',
  'photo-1604719312566-8912e9227c6a',
  'photo-1556742049-0cfed4f6a45d',
  'photo-1472851294608-062f824d29cc',
];
const img = (id: string, w: number) => `https://images.unsplash.com/${id}?auto=format&fit=crop&w=${w}&q=80`;

/** [name, city, state, description] */
const SEEDS: [string, string, string, string][] = [
  ['Aba Leather Works', 'Aba', 'Abia', 'Handmade leather shoes and bags from Aba craftsmen.'],
  ['Kano Textile Hub', 'Kano', 'Kano', 'Premium fabrics, lace and traditional wear.'],
  ['Enugu Fresh Farms', 'Enugu', 'Enugu', 'Farm-fresh produce delivered straight from the farm.'],
  ['Port Harcourt Tech Mart', 'Port Harcourt', 'Rivers', 'Phones, laptops and accessories with warranty.'],
  ['Ibadan Home Essentials', 'Ibadan', 'Oyo', 'Furniture and home decor for every room.'],
  ['Abuja Beauty Bar', 'Abuja', 'FCT', 'Skincare, makeup and fragrances from trusted brands.'],
  ['Onitsha Building Supplies', 'Onitsha', 'Anambra', 'Cement, roofing sheets and plumbing materials.'],
  ['Jos Organic Foods', 'Jos', 'Plateau', 'Grains, spices and packaged foods.'],
  ['Lagos Sneaker Lab', 'Yaba', 'Lagos', 'Authentic sneakers and streetwear.'],
  ['Calabar Spice Market', 'Calabar', 'Cross River', 'Local spices, sauces and dried goods.'],
  ['Benin Craft Gallery', 'Benin City', 'Edo', 'Bronze art, carvings and gifts.'],
  ['Owerri Gadget World', 'Owerri', 'Imo', 'Audio, TVs and smart home devices.'],
  ['Kaduna Farm Inputs', 'Kaduna', 'Kaduna', 'Seeds, fertilizers and farm equipment.'],
  ['Warri Auto Parts', 'Warri', 'Delta', 'Genuine car parts and accessories.'],
  ['Uyo Kids Corner', 'Uyo', 'Akwa Ibom', 'Baby clothing, toys and school supplies.'],
  ['Abeokuta Adire House', 'Abeokuta', 'Ogun', 'Hand-dyed adire fabrics and ready-to-wear.'],
  ['Ilorin Fitness Gear', 'Ilorin', 'Kwara', 'Sports equipment and fitness wear.'],
  ['Maiduguri Fabrics', 'Maiduguri', 'Borno', 'Quality fabrics and tailoring materials.'],
  ['Asaba Wellness Store', 'Asaba', 'Delta', 'Vitamins, herbal care and wellness products.'],
  ['Lekki Home Studio', 'Lekki', 'Lagos', 'Modern living room and bedroom pieces.'],
  ['Sokoto Leather Co', 'Sokoto', 'Sokoto', 'Traditional leather goods and footwear.'],
  ['Akure Office Mart', 'Akure', 'Ondo', 'Office furniture, stationery and school supplies.'],
  ['Yenagoa Beverages', 'Yenagoa', 'Bayelsa', 'Juices, drinks and bottled water.'],
  ['Makurdi Grains & More', 'Makurdi', 'Benue', 'Yam, rice, beans and fresh produce.'],
  ['Ikorodu Tools & Hardware', 'Ikorodu', 'Lagos', 'Power tools, hand tools and electricals.'],
  ['Nnewi Auto Centre', 'Nnewi', 'Anambra', 'Vehicle spares and servicing accessories.'],
  ['Bauchi Perfume House', 'Bauchi', 'Bauchi', 'Oud, attars and designer fragrances.'],
  ['Awka Fashion Studio', 'Awka', 'Anambra', 'Contemporary womens and mens fashion.'],
  ['Gombe Crafts', 'Gombe', 'Gombe', 'Woven baskets, pottery and gifts.'],
  ['Lokoja Electronics', 'Lokoja', 'Kogi', 'Everyday electronics at fair prices.'],
  ['Minna Farm Fresh', 'Minna', 'Niger', 'Vegetables, fruits and farm tools.'],
  ['Osogbo Textile Gallery', 'Osogbo', 'Osun', 'Traditional and modern textiles.'],
  ['Umuahia Home Goods', 'Umuahia', 'Abia', 'Kitchen, dining and home decor.'],
  ['Ado-Ekiti Books & Stationery', 'Ado-Ekiti', 'Ekiti', 'Books, notebooks and art supplies.'],
  ['Katsina Wellness Hub', 'Katsina', 'Katsina', 'Natural wellness and personal care.'],
  ['Abakaliki Rice Mill', 'Abakaliki', 'Ebonyi', 'Locally milled rice and packaged foods.'],
];

const STATUS_BY_INDEX: Record<number, MerchantStatus> = {
  3: 'Pending', 11: 'Pending', 19: 'Pending',
  7: 'Suspended', 23: 'Suspended',
  15: 'Inactive', 29: 'Rejected',
};

const leafPath = (cat: Category, all: Category[]): string => {
  const parts: string[] = [cat.slug];
  let cursor: Category | undefined = cat;
  while (cursor?.parentId) {
    cursor = all.find(c => c.id === cursor!.parentId);
    if (cursor) parts.unshift(cursor.slug);
  }
  return parts.join('/');
};

/** Deterministic 1–3 category paths drawn from the 3-level taxonomy. */
export function pickCategoryPaths(seed: string, all: Category[] = mockShopCategories): string[] {
  const sellable = all.filter(c => c.parentId);
  const h = hash(seed);
  const count = 1 + (h % 3);
  const paths = new Set<string>();
  for (let i = 0; i < count; i++) {
    paths.add(leafPath(sellable[(h + i * 17) % sellable.length], all));
  }
  return [...paths];
}

/** Fills public-profile fields (rating, reviews, verified, categories) when a merchant lacks them. */
export function withDirectoryProfile(m: Merchant): Merchant {
  const h = hash(m.id);
  return {
    ...m,
    rating: m.rating ?? Math.min(5, 3.6 + (h % 15) / 10),
    reviewCount: m.reviewCount ?? 8 + (h % 240),
    isVerified: m.isVerified ?? h % 3 !== 0,
    categoryPaths: m.categoryPaths ?? pickCategoryPaths(m.id),
  };
}

const TYPES: MerchantType[] = ['Own outlet', 'Franchise', 'Partner'];

export const generatedDirectoryMerchants: Merchant[] = SEEDS.map(([name, city, state, description], i) => {
  const n = i + 13; // continues after mer-12
  const h = hash(name);
  const month = 1 + (h % 9);
  const day = 1 + (h % 27);
  return {
    id: `mer-${n}`,
    merchantNo: `MER-${1000 + n}`,
    name,
    legalName: `${name} Ltd`,
    logoUrl: img(LOGOS[h % LOGOS.length], 400),
    bannerImage: img(BANNERS[(h >> 3) % BANNERS.length], 800),
    type: TYPES[h % TYPES.length],
    description,
    ownerName: `Owner ${n}`,
    phone: `+23480${String(10000000 + (h % 89999999))}`,
    email: `hello@merchant${n}.example.com`,
    address: `${1 + (h % 80)} Market Road`,
    city,
    state,
    settlementBank: { bankName: 'GTBank', accountNumber: String(1000000000 + (h % 899999999)), accountName: `${name} Ltd` },
    settlementFrequency: 'Weekly',
    priceList: 'Default',
    discountLimit: 5,
    creditLimit: 0,
    status: STATUS_BY_INDEX[i] ?? 'Active',
    onboardedAt: `2026-0${month}-${String(day).padStart(2, '0')}T09:00:00Z`,
    salesPeriod: (h % 900) * 1_000_000,
    ordersCount: i % 9 === 0 ? 0 : h % 700,
    stockValue: (h % 500) * 1_000_000,
    outstandingBalance: 0,
  };
});
