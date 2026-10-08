import { Category } from './types';

const MERCHANT_IDS = [
  'mer-1',
  'mer-2',
  'mer-3',
  'mer-4',
  'mer-5',
  'mer-6',
  'mer-7',
  'mer-8',
  'mer-9',
  'mer-10',
  'mer-11',
  'mer-12',
];

/**
 * Returns a random selection of merchants.
 * Used only for mock/demo data.
 */
const randomMerchantIds = (count = 3): string[] => {
  return [...MERCHANT_IDS]
    .sort(() => Math.random() - 0.5)
    .slice(0, count);
};

export const mockShopCategories: Category[] = [
  // ============================================================
  // TOP LEVEL CATEGORIES
  // ============================================================

  {
    id: 'cat-1',
    name: 'Fashion & Apparel',
    slug: 'fashion-apparel',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&q=80&w=800',
    icon: 'shirt',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 342,
  },

  {
    id: 'cat-2',
    name: 'Beauty & Personal Care',
    slug: 'beauty-personal-care',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&q=80&w=800',
    icon: 'sparkles',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 412,
  },

  {
    id: 'cat-3',
    name: 'Home & Furniture',
    slug: 'home-furniture',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=800',
    icon: 'home',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 286,
  },

  {
    id: 'cat-4',
    name: 'Electronics',
    slug: 'electronics',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&q=80&w=800',
    icon: 'smartphone',
    sortOrder: 4,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 198,
  },

  {
    id: 'cat-5',
    name: 'Phones & Accessories',
    slug: 'phones-accessories',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&q=80&w=800',
    icon: 'smartphone',
    sortOrder: 5,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 245,
  },

  {
    id: 'cat-6',
    name: 'Food & Groceries',
    slug: 'food-groceries',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&q=80&w=800',
    icon: 'shopping-basket',
    sortOrder: 6,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 521,
  },

  {
    id: 'cat-7',
    name: 'Health & Wellness',
    slug: 'health-wellness',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=800',
    icon: 'heart-pulse',
    sortOrder: 7,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 176,
  },

  {
    id: 'cat-8',
    name: 'Building & Construction',
    slug: 'building-construction',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&q=80&w=800',
    icon: 'hammer',
    sortOrder: 8,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 315,
  },

  {
    id: 'cat-9',
    name: 'Office & School Supplies',
    slug: 'office-school-supplies',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&q=80&w=800',
    icon: 'briefcase',
    sortOrder: 9,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 164,
  },

  {
    id: 'cat-10',
    name: 'Agriculture & Farming',
    slug: 'agriculture-farming',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&q=80&w=800',
    icon: 'sprout',
    sortOrder: 10,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 132,
  },

  {
    id: 'cat-11',
    name: 'Automotive',
    slug: 'automotive',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&q=80&w=800',
    icon: 'car',
    sortOrder: 11,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 143,
  },

  {
    id: 'cat-12',
    name: 'Sports & Fitness',
    slug: 'sports-fitness',
    parentId: null,
    image:
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&q=80&w=800',
    icon: 'dumbbell',
    sortOrder: 12,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(4),
    productCount: 98,
  },

  // ============================================================
  // FASHION
  // ============================================================

  {
    id: 'cat-1-1',
    name: "Men's Fashion",
    slug: 'mens-fashion',
    parentId: 'cat-1',
    image:
      'https://images.unsplash.com/photo-1617137968427-85924c800a22?auto=format&fit=crop&q=80&w=800',
    icon: 'shirt',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 150,
  },

  {
    id: 'cat-1-2',
    name: "Women's Fashion",
    slug: 'womens-fashion',
    parentId: 'cat-1',
    image:
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&q=80&w=800',
    icon: 'shirt',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 192,
  },

  {
    id: 'cat-1-3',
    name: 'Kids & Baby',
    slug: 'kids-baby',
    parentId: 'cat-1',
    image:
      'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?auto=format&fit=crop&q=80&w=800',
    icon: 'baby',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 87,
  },

  {
    id: 'cat-1-4',
    name: 'Shoes & Footwear',
    slug: 'shoes-footwear',
    parentId: 'cat-1',
    image:
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=800',
    icon: 'footprints',
    sortOrder: 4,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 124,
  },

  {
    id: 'cat-1-5',
    name: 'Bags & Accessories',
    slug: 'bags-accessories',
    parentId: 'cat-1',
    image:
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&q=80&w=800',
    icon: 'shopping-bag',
    sortOrder: 5,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 76,
  },

  // ============================================================
  // MEN'S FASHION
  // ============================================================

  {
    id: 'cat-1-1-1',
    name: 'Shirts',
    slug: 'shirts',
    parentId: 'cat-1-1',
    image:
      'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&q=80&w=800',
    icon: 'shirt',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 100,
  },

  {
    id: 'cat-1-1-2',
    name: 'Trousers & Jeans',
    slug: 'trousers-jeans',
    parentId: 'cat-1-1',
    image:
      'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&q=80&w=800',
    icon: 'shirt',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 82,
  },

  {
    id: 'cat-1-1-3',
    name: 'Shoes',
    slug: 'mens-shoes',
    parentId: 'cat-1-1',
    image:
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=800',
    icon: 'footprints',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 50,
  },

  {
    id: 'cat-1-1-4',
    name: 'Watches',
    slug: 'watches',
    parentId: 'cat-1-1',
    image:
      'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&q=80&w=800',
    icon: 'watch',
    sortOrder: 4,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 38,
  },

  // ============================================================
  // WOMEN'S FASHION
  // ============================================================

  {
    id: 'cat-1-2-1',
    name: 'Dresses',
    slug: 'dresses',
    parentId: 'cat-1-2',
    image:
      'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&q=80&w=800',
    icon: 'shirt',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 91,
  },

  {
    id: 'cat-1-2-2',
    name: 'Tops & Blouses',
    slug: 'tops-blouses',
    parentId: 'cat-1-2',
    image:
      'https://images.unsplash.com/photo-1564257577054-2e7f9c2d7a3b?auto=format&fit=crop&q=80&w=800',
    icon: 'shirt',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 64,
  },

  {
    id: 'cat-1-2-3',
    name: 'Women’s Shoes',
    slug: 'womens-shoes',
    parentId: 'cat-1-2',
    image:
      'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&q=80&w=800',
    icon: 'footprints',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 72,
  },

  // ============================================================
  // BEAUTY
  // ============================================================

  {
    id: 'cat-2-1',
    name: 'Skincare',
    slug: 'skincare',
    parentId: 'cat-2',
    image:
      'https://images.unsplash.com/photo-1556229010-6c3f2c9ca5f8?auto=format&fit=crop&q=80&w=800',
    icon: 'sparkles',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 138,
  },

  {
    id: 'cat-2-2',
    name: 'Hair Care',
    slug: 'hair-care',
    parentId: 'cat-2',
    image:
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&q=80&w=800',
    icon: 'scissors',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 104,
  },

  {
    id: 'cat-2-3',
    name: 'Makeup',
    slug: 'makeup',
    parentId: 'cat-2',
    image:
      'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=800',
    icon: 'palette',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 92,
  },

  {
    id: 'cat-2-4',
    name: 'Fragrances',
    slug: 'fragrances',
    parentId: 'cat-2',
    image:
      'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&q=80&w=800',
    icon: 'flower-2',
    sortOrder: 4,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 78,
  },

  // ============================================================
  // HOME & FURNITURE
  // ============================================================

  {
    id: 'cat-3-1',
    name: 'Living Room',
    slug: 'living-room',
    parentId: 'cat-3',
    image:
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=800',
    icon: 'sofa',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 65,
  },

  {
    id: 'cat-3-2',
    name: 'Bedroom',
    slug: 'bedroom',
    parentId: 'cat-3',
    image:
      'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&q=80&w=800',
    icon: 'bed',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 58,
  },

  {
    id: 'cat-3-3',
    name: 'Kitchen & Dining',
    slug: 'kitchen-dining',
    parentId: 'cat-3',
    image:
      'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&q=80&w=800',
    icon: 'utensils',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 83,
  },

  {
    id: 'cat-3-4',
    name: 'Home Decor',
    slug: 'home-decor',
    parentId: 'cat-3',
    image:
      'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&q=80&w=800',
    icon: 'lamp',
    sortOrder: 4,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 80,
  },

  // ============================================================
  // ELECTRONICS
  // ============================================================

  {
    id: 'cat-4-1',
    name: 'Computers & Laptops',
    slug: 'computers-laptops',
    parentId: 'cat-4',
    image:
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&q=80&w=800',
    icon: 'laptop',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 76,
  },

  {
    id: 'cat-4-2',
    name: 'TV & Entertainment',
    slug: 'tv-entertainment',
    parentId: 'cat-4',
    image:
      'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&q=80&w=800',
    icon: 'tv',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 51,
  },

  {
    id: 'cat-4-3',
    name: 'Audio',
    slug: 'audio',
    parentId: 'cat-4',
    image:
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80&w=800',
    icon: 'headphones',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 71,
  },

  // ============================================================
  // FOOD & GROCERIES
  // ============================================================

  {
    id: 'cat-6-1',
    name: 'Fresh Produce',
    slug: 'fresh-produce',
    parentId: 'cat-6',
    image:
      'https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&q=80&w=800',
    icon: 'apple',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 102,
  },

  {
    id: 'cat-6-2',
    name: 'Packaged Foods',
    slug: 'packaged-foods',
    parentId: 'cat-6',
    image:
      'https://images.unsplash.com/photo-1606787366850-de6330128bfc?auto=format&fit=crop&q=80&w=800',
    icon: 'package',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 148,
  },

  {
    id: 'cat-6-3',
    name: 'Beverages',
    slug: 'beverages',
    parentId: 'cat-6',
    image:
      'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&q=80&w=800',
    icon: 'cup-soda',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 86,
  },

  // ============================================================
  // BUILDING & CONSTRUCTION
  // ============================================================

  {
    id: 'cat-8-1',
    name: 'Building Materials',
    slug: 'building-materials',
    parentId: 'cat-8',
    image:
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&q=80&w=800',
    icon: 'brick-wall',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 126,
  },

  {
    id: 'cat-8-2',
    name: 'Tools & Hardware',
    slug: 'tools-hardware',
    parentId: 'cat-8',
    image:
      'https://images.unsplash.com/photo-1581147036324-c17ac41c0b7b?auto=format&fit=crop&q=80&w=800',
    icon: 'wrench',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 94,
  },

  {
    id: 'cat-8-3',
    name: 'Electrical & Plumbing',
    slug: 'electrical-plumbing',
    parentId: 'cat-8',
    image:
      'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&q=80&w=800',
    icon: 'plug',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 95,
  },

  // ============================================================
  // AGRICULTURE
  // ============================================================

  {
    id: 'cat-10-1',
    name: 'Seeds & Seedlings',
    slug: 'seeds-seedlings',
    parentId: 'cat-10',
    image:
      'https://images.unsplash.com/photo-1492496913980-501348b61469?auto=format&fit=crop&q=80&w=800',
    icon: 'sprout',
    sortOrder: 1,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 42,
  },

  {
    id: 'cat-10-2',
    name: 'Farm Equipment',
    slug: 'farm-equipment',
    parentId: 'cat-10',
    image:
      'https://images.unsplash.com/photo-1592982537447-6f9b3e1b5d7b?auto=format&fit=crop&q=80&w=800',
    icon: 'tractor',
    sortOrder: 2,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 48,
  },

  {
    id: 'cat-10-3',
    name: 'Fertilizers & Farm Inputs',
    slug: 'fertilizers-farm-inputs',
    parentId: 'cat-10',
    image:
      'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&q=80&w=800',
    icon: 'leaf',
    sortOrder: 3,
    status: 'active',
    showInMenu: true,
    featuredMerchantIds: randomMerchantIds(3),
    productCount: 42,
  },
];