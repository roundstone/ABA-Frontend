export interface PublicProduct {
  id: string;
  name: string;
  brand: string;
  category: string;
  price: number;
  originalPrice?: number;
  discountPercentage?: number;
  rating: number;
  reviewCount: number;
  imageUrl: string;
  isTrending?: boolean;
  sizes?: string[];
  colors?: string[];
}

export interface PublicCategory {
  id: string;
  name: string;
  href: string;
  imageUrl?: string;
  description?: string;
}

export interface PublicBlogPost {
  id: string;
  title: string;
  date: string;
  author: string;
  commentCount: number;
  imageUrl: string;
  href: string;
}

export interface PublicInstagramPost {
  id: string;
  imageUrl: string;
  href: string;
}

export interface PublicBanner {
  id: string;
  title: string;
  subtitle: string;
  buttonText: string;
  href: string;
  imageUrl: string;
}

// ABA Project Specific Data
export const ABA_PRODUCTS: PublicProduct[] = [
  {
    id: 'p1',
    name: 'Aba Leather Satchel',
    brand: 'Aba Crafts',
    category: 'Bags',
    price: 25000,
    originalPrice: 30000,
    discountPercentage: 15,
    rating: 5,
    reviewCount: 42,
    imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&q=80',
    isTrending: true,
    sizes: ['M', 'L'],
    colors: ['Brown', 'Black'],
  },
  {
    id: 'p2',
    name: 'Premium Leather Loafers',
    brand: 'Ariaria Shoes',
    category: 'Shoes',
    price: 35000,
    rating: 4,
    reviewCount: 28,
    imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&q=80',
    isTrending: true,
    sizes: ['40', '41', '42', '43'],
    colors: ['Black', 'Tan'],
  },
  {
    id: 'p3',
    name: 'Ankara Tote Bag',
    brand: 'Aba Crafts',
    category: 'Bags',
    price: 15000,
    originalPrice: 18000,
    discountPercentage: 10,
    rating: 5,
    reviewCount: 15,
    imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=600&q=80',
    sizes: ['One Size'],
    colors: ['Multicolor', 'Blue'],
  },
  {
    id: 'p4',
    name: 'Handcrafted Oxford Shoes',
    brand: 'Ariaria Shoes',
    category: 'Shoes',
    price: 42000,
    rating: 5,
    reviewCount: 56,
    imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=600&q=80',
    sizes: ['41', '42', '44'],
    colors: ['Brown'],
  },
  {
    id: 'p5',
    name: 'Classic Leather Backpack',
    brand: 'Aba Crafts',
    category: 'Bags',
    price: 28000,
    originalPrice: 35000,
    discountPercentage: 20,
    rating: 4,
    reviewCount: 31,
    imageUrl: 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?w=600&q=80',
    sizes: ['L', 'XL'],
    colors: ['Black', 'Grey'],
  },
  {
    id: 'p6',
    name: 'Native Senator Fabric',
    brand: 'Aba Textiles',
    category: 'Fabrics',
    price: 12000,
    rating: 5,
    reviewCount: 89,
    imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=600&q=80',
    isTrending: true,
    sizes: ['5 Yards', '10 Yards'],
    colors: ['Blue', 'White'],
  },
  {
    id: 'p7',
    name: 'Leather Weekend Duffel',
    brand: 'Aba Crafts',
    category: 'Bags',
    price: 45000,
    originalPrice: 50000,
    discountPercentage: 10,
    rating: 5,
    reviewCount: 11,
    imageUrl: 'https://images.unsplash.com/photo-1598532163257-ae3c6b2524b6?w=600&q=80',
    sizes: ['One Size'],
    colors: ['Brown', 'Olive'],
  },
  {
    id: 'p8',
    name: 'Aso-Oke Patterned Garment',
    brand: 'Aba Textiles',
    category: 'Fabrics',
    price: 18000,
    rating: 4,
    reviewCount: 19,
    imageUrl: 'https://images.unsplash.com/photo-1620799140188-3b2a02fd9a77?w=600&q=80',
    sizes: ['5 Yards'],
    colors: ['Red', 'Gold'],
  }
];

export const ABA_CATEGORIES: PublicCategory[] = [
  { id: 'c1', name: 'Leather Bags', href: '/category/bags' },
  { id: 'c2', name: 'Handcrafted Shoes', href: '/category/shoes' },
  { id: 'c3', name: 'Textiles & Fabrics', href: '/category/fabrics' },
  { id: 'c4', name: 'Men\'s Wear', href: '/category/mens-wear' },
  { id: 'c5', name: 'Women\'s Wear', href: '/category/womens-wear' },
  { id: 'c6', name: 'Belts & Accessories', href: '/category/accessories' },
];

export const ABA_BLOG_POSTS: PublicBlogPost[] = [
  {
    id: 'b1',
    title: 'The Rise of Aba Manufacturing in Global Markets',
    date: '25 August 2026',
    author: 'Chinedu Okoro',
    commentCount: 12,
    imageUrl: 'https://images.unsplash.com/photo-1591561954557-26941169b49e?w=600&q=80',
    href: '/blog/1'
  },
  {
    id: 'b2',
    title: 'Why Ariaria Leather Shoes Are Export Quality',
    date: '10 September 2026',
    author: 'Adaeze Nnamdi',
    commentCount: 8,
    imageUrl: 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=600&q=80',
    href: '/blog/2'
  },
  {
    id: 'b3',
    title: 'Sourcing Authentic African Textiles for Fashion',
    date: '15 September 2026',
    author: 'Emeka Uche',
    commentCount: 24,
    imageUrl: 'https://images.unsplash.com/photo-1520113412646-0683cb0703d1?w=600&q=80',
    href: '/blog/3'
  }
];

export const ABA_INSTAGRAM: PublicInstagramPost[] = [
  { id: 'i1', imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=300&q=80', href: '#!' },
  { id: 'i2', imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=300&q=80', href: '#!' },
  { id: 'i3', imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=300&q=80', href: '#!' },
  { id: 'i4', imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=300&q=80', href: '#!' },
  { id: 'i5', imageUrl: 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?w=300&q=80', href: '#!' },
  { id: 'i6', imageUrl: 'https://images.unsplash.com/photo-1515347619362-e670460c384e?w=300&q=80', href: '#!' },
  { id: 'i7', imageUrl: 'https://images.unsplash.com/photo-1598532163257-ae3c6b2524b6?w=300&q=80', href: '#!' },
  { id: 'i8', imageUrl: 'https://images.unsplash.com/photo-1620799140188-3b2a02fd9a77?w=300&q=80', href: '#!' },
];

export const PublicService = {
  getProducts: async (): Promise<PublicProduct[]> => {
    return new Promise((resolve) => setTimeout(() => resolve(ABA_PRODUCTS), 1000));
  },
  getCategories: async (): Promise<PublicCategory[]> => {
    return new Promise((resolve) => setTimeout(() => resolve(ABA_CATEGORIES), 1000));
  },
  getBlogPosts: async (): Promise<PublicBlogPost[]> => {
    return new Promise((resolve) => setTimeout(() => resolve(ABA_BLOG_POSTS), 1000));
  },
  getInstagramPosts: async (): Promise<PublicInstagramPost[]> => {
    return new Promise((resolve) => setTimeout(() => resolve(ABA_INSTAGRAM), 1000));
  }
};
