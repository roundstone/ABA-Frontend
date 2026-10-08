import { mockShopCategories } from '../category/mocks';
import { MOCK_MERCHANTS } from '../merchant/mocks';
import { Merchant } from '../merchants/types';
import { Product } from '../products/types';

import { generatedDirectoryMerchants, withDirectoryProfile } from '../merchants/directoryMocks';

export const mockShopMerchants: Merchant[] = [
  ...MOCK_MERCHANTS,
  // ...generatedDirectoryMerchants,
].map(withDirectoryProfile);


export const mockShopProducts: Product[] = [
  // ============================================================
  // FINISHED GOODS
  // ============================================================

  {
    id: 'prod-1',
    slug: 'apple-watch-series-9',
    name: 'Apple Watch Series 9 GPS 45mm',
    sku: 'APL-WAT-S9-45',
    type: 'Finished good',
    description:
      'The latest Apple Watch with advanced health tracking and a brighter always-on display.',
    category: mockShopCategories[0],
    categoryName: 'Electronics',
    brand: 'Apple',
    unitOfMeasure: 'piece',
    barcode: '194253948521',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=800&q=80',
    ],

    price: 420000,
    sellingPrice: 420000,
    originalPrice: 450000,
    wholesalePrice: 400000,
    priceIncludesTax: true,

    hasVariants: true,
    variants: [
      {
        id: 'var-1',
        name: 'Apple Watch Series 9 45mm Midnight',
        sku: 'APL-WAT-S9-45-MID',
        barcode: '194253948521',
        cost: 320000,
        price: 420000,
        reorderLevel: 5,
        images: ['https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=800&q=80'],
        isActive: true,
        stockCount: 18,
      },
    ],

    trackInventory: true,
    reorderLevel: 5,
    reorderQuantity: 10,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 18,
    inStock: true,
    updatedAt: '2026-10-01T10:00:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.9,
    reviewCount: 342,

    attributes: [
      { name: 'Color', value: 'Midnight' },
      { name: 'Size', value: '45mm' },
      { name: 'Connectivity', value: 'GPS' },
    ],
  },

  {
    id: 'prod-2',
    slug: 'premium-laptop-sleeve',
    name: 'Premium Laptop Sleeve',
    sku: 'ACC-LAP-SLV-001',
    type: 'Finished good',
    description:
      'Water-resistant protective sleeve for 13-14 inch laptops.',
    category: mockShopCategories[2],
    categoryName: 'Accessories',
    brand: 'TechGuard',
    unitOfMeasure: 'piece',
    barcode: '8901234567890',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1789754600788-286220119dec?q=80&w=1287&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1789758612553-5e6044ac2ff1?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1790207504527-0dd91be5d7f5?q=80&w=1528&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1789955482566-c48c048ac905?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    ],

    price: 32000,
    sellingPrice: 32000,
    originalPrice: 38000,
    wholesalePrice: 28000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 10,
    reorderQuantity: 25,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 45,
    inStock: true,
    updatedAt: '2026-10-01T10:30:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.6,
    reviewCount: 128,

    attributes: [
      { name: 'Color', value: 'Space Gray' },
      { name: 'Size', value: '13-14 inch' },
      { name: 'Material', value: 'Water-resistant fabric' },
    ],
  },

  {
    id: 'prod-3',
    slug: 'sony-wireless-headphones',
    name: 'Sony WH-1000XM5 Wireless Headphones',
    sku: 'SON-WH1000XM5',
    type: 'Finished good',
    description:
      'Premium wireless headphones with industry-leading noise cancellation and immersive sound.',
    category: mockShopCategories[0],
    categoryName: 'Electronics',
    brand: 'Sony',
    unitOfMeasure: 'piece',
    barcode: '4548736132618',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
    ],

    price: 65000,
    sellingPrice: 65000,
    originalPrice: 72000,
    wholesalePrice: 61000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 8,
    reorderQuantity: 15,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 24,
    inStock: true,
    updatedAt: '2026-10-01T11:00:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.8,
    reviewCount: 256,

    attributes: [
      { name: 'Color', value: 'Black' },
      { name: 'Type', value: 'Wireless' },
      { name: 'Noise Cancellation', value: 'Active' },
    ],
  },

  {
    id: 'prod-4',
    slug: 'premium-running-sneakers',
    name: 'Premium Running Sneakers',
    sku: 'SHO-RUN-PRM-001',
    type: 'Finished good',
    description:
      'Lightweight and comfortable running shoes designed for everyday training and long-distance runs.',
    category: mockShopCategories[1],
    categoryName: 'Fashion',
    brand: 'RunPro',
    unitOfMeasure: 'pair',
    barcode: '8909876543210',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=800&q=80',
    ],

    price: 18500,
    sellingPrice: 18500,
    originalPrice: 22000,
    wholesalePrice: 16000,
    priceIncludesTax: true,

    hasVariants: true,
    variants: [
      {
        id: 'var-4-1',
        name: 'Red/White - Size 42',
        sku: 'SHO-RUN-42-RW',
        cost: 11000,
        price: 18500,
        reorderLevel: 5,
        images: [],
        isActive: true,
        stockCount: 12,
      },
      {
        id: 'var-4-2',
        name: 'Red/White - Size 43',
        sku: 'SHO-RUN-43-RW',
        cost: 11000,
        price: 18500,
        reorderLevel: 5,
        images: [],
        isActive: true,
        stockCount: 9,
      },
    ],

    trackInventory: true,
    reorderLevel: 10,
    reorderQuantity: 20,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 21,
    inStock: true,
    updatedAt: '2026-10-01T11:30:00.000Z',

    merchant: mockShopMerchants[1],

    rating: 4.7,
    reviewCount: 189,

    attributes: [
      { name: 'Color', value: 'Red/White' },
      { name: 'Size', value: '42-43' },
      { name: 'Type', value: 'Running' },
    ],
  },

  {
    id: 'prod-5',
    slug: 'minimalist-leather-backpack',
    name: 'Minimalist Leather Backpack',
    sku: 'BAG-LTH-MIN-001',
    type: 'Finished good',
    description:
      'Premium everyday backpack made from durable leather with dedicated laptop storage.',
    category: mockShopCategories[1],
    categoryName: 'Fashion',
    brand: 'UrbanCarry',
    unitOfMeasure: 'piece',
    barcode: '8901122334455',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?auto=format&fit=crop&w=800&q=80',
    ],

    price: 27500,
    sellingPrice: 27500,
    originalPrice: 32000,
    wholesalePrice: 24000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 8,
    reorderQuantity: 15,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 32,
    inStock: true,
    updatedAt: '2026-10-01T12:00:00.000Z',

    merchant: mockShopMerchants[1],

    rating: 4.6,
    reviewCount: 94,

    attributes: [
      { name: 'Color', value: 'Brown' },
      { name: 'Material', value: 'Leather' },
      { name: 'Laptop Size', value: 'Up to 15.6 inch' },
    ],
  },

  {
    id: 'prod-6',
    slug: 'iphone-15-pro',
    name: 'iPhone 15 Pro',
    sku: 'APL-IP15P-256',
    type: 'Finished good',
    description:
      'Powerful smartphone featuring a titanium design, advanced camera system and A17 Pro chip.',
    category: mockShopCategories[0],
    categoryName: 'Electronics',
    brand: 'Apple',
    unitOfMeasure: 'piece',
    barcode: '194253902084',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=800&q=80',
    ],

    price: 1250000,
    sellingPrice: 1250000,
    originalPrice: 1400000,
    wholesalePrice: 1190000,
    priceIncludesTax: true,

    hasVariants: true,
    variants: [
      {
        id: 'var-6-1',
        name: 'Natural Titanium - 256GB',
        sku: 'APL-IP15P-NT-256',
        cost: 1050000,
        price: 1250000,
        reorderLevel: 3,
        images: [],
        isActive: true,
        stockCount: 7,
      },
    ],

    trackInventory: true,
    reorderLevel: 3,
    reorderQuantity: 10,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 7,
    inStock: true,
    updatedAt: '2026-10-01T12:10:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.9,
    reviewCount: 521,

    attributes: [
      { name: 'Color', value: 'Natural Titanium' },
      { name: 'Storage', value: '256GB' },
      { name: 'Chip', value: 'A17 Pro' },
    ],
  },

  {
    id: 'prod-7',
    slug: 'mechanical-keyboard',
    name: 'RGB Mechanical Gaming Keyboard',
    sku: 'KEY-RGB-MECH-001',
    type: 'Finished good',
    description:
      'Responsive mechanical keyboard with RGB lighting and customizable keys for gaming and productivity.',
    category: mockShopCategories[2],
    categoryName: 'Accessories',
    brand: 'KeyMaster',
    unitOfMeasure: 'piece',
    barcode: '8901234567001',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1595225476474-87563907a212?auto=format&fit=crop&w=800&q=80',
    ],

    price: 14500,
    sellingPrice: 14500,
    originalPrice: 17500,
    wholesalePrice: 12500,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 10,
    reorderQuantity: 20,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 38,
    inStock: true,
    updatedAt: '2026-10-01T12:15:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.5,
    reviewCount: 117,

    attributes: [
      { name: 'Color', value: 'Black' },
      { name: 'Switch', value: 'Mechanical' },
      { name: 'Lighting', value: 'RGB' },
    ],
  },

  {
    id: 'prod-8',
    slug: 'smart-home-speaker',
    name: 'Smart Home Speaker',
    sku: 'SPK-SMART-001',
    type: 'Finished good',
    description:
      'Compact smart speaker with rich sound, voice control and seamless smart-home integration.',
    category: mockShopCategories[0],
    categoryName: 'Electronics',
    brand: 'HomeSound',
    unitOfMeasure: 'piece',
    barcode: '8901234567018',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=800&q=80',
    ],

    price: 18500,
    sellingPrice: 18500,
    originalPrice: 22000,
    wholesalePrice: 16000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 8,
    reorderQuantity: 15,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 26,
    inStock: true,
    updatedAt: '2026-10-01T12:20:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.4,
    reviewCount: 86,

    attributes: [
      { name: 'Color', value: 'White' },
      { name: 'Connectivity', value: 'Wi-Fi / Bluetooth' },
    ],
  },

  {
    id: 'prod-9',
    slug: 'classic-sunglasses',
    name: 'Classic Polarized Sunglasses',
    sku: 'SUN-POL-CLS-001',
    type: 'Finished good',
    description:
      'Stylish polarized sunglasses offering UV protection and comfortable everyday wear.',
    category: mockShopCategories[1],
    categoryName: 'Fashion',
    brand: 'VisionWear',
    unitOfMeasure: 'piece',
    barcode: '8901234567025',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&w=800&q=80',
    ],

    price: 8500,
    sellingPrice: 8500,
    originalPrice: 11000,
    wholesalePrice: 7000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 10,
    reorderQuantity: 25,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 41,
    inStock: true,
    updatedAt: '2026-10-01T12:25:00.000Z',

    merchant: mockShopMerchants[1],

    rating: 4.6,
    reviewCount: 73,

    attributes: [
      { name: 'Color', value: 'Black' },
      { name: 'Lens', value: 'Polarized' },
      { name: 'UV Protection', value: 'UV400' },
    ],
  },

  {
    id: 'prod-10',
    slug: 'ceramic-coffee-set',
    name: 'Modern Ceramic Coffee Set',
    sku: 'KIT-COFFEE-CER-001',
    type: 'Finished good',
    description:
      'Elegant ceramic coffee set perfect for home, office and entertaining guests.',
    category: mockShopCategories[2],
    categoryName: 'Home & Kitchen',
    brand: 'HomeCraft',
    unitOfMeasure: 'set',
    barcode: '8901234567032',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
    ],

    price: 9500,
    sellingPrice: 9500,
    originalPrice: 12500,
    wholesalePrice: 8000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 6,
    reorderQuantity: 15,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 19,
    inStock: true,
    updatedAt: '2026-10-01T12:30:00.000Z',

    merchant: mockShopMerchants[1],

    rating: 4.8,
    reviewCount: 61,

    attributes: [
      { name: 'Color', value: 'White' },
      { name: 'Material', value: 'Ceramic' },
      { name: 'Pieces', value: '6-piece set' },
    ],
  },

  {
    id: 'prod-11',
    slug: 'portable-bluetooth-speaker',
    name: 'Portable Bluetooth Speaker',
    sku: 'SPK-BT-PORT-001',
    type: 'Finished good',
    description:
      'Compact portable speaker with powerful sound, deep bass and long-lasting battery life.',
    category: mockShopCategories[0],
    categoryName: 'Electronics',
    brand: 'SoundMax',
    unitOfMeasure: 'piece',
    barcode: '8901234567049',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1589003077984-894e133dabab?auto=format&fit=crop&w=800&q=80',
    ],

    price: 12000,
    sellingPrice: 12000,
    originalPrice: 15000,
    wholesalePrice: 10500,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 8,
    reorderQuantity: 20,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 33,
    inStock: true,
    updatedAt: '2026-10-01T12:35:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.7,
    reviewCount: 143,

    attributes: [
      { name: 'Color', value: 'Black' },
      { name: 'Battery', value: '12 hours' },
      { name: 'Connectivity', value: 'Bluetooth' },
    ],
  },

  {
    id: 'prod-12',
    slug: 'premium-cotton-tshirt',
    name: 'Premium Cotton T-Shirt',
    sku: 'TSH-COT-PRE-001',
    type: 'Finished good',
    description:
      'Soft premium cotton t-shirt with a comfortable fit for everyday casual wear.',
    category: mockShopCategories[1],
    categoryName: 'Fashion',
    brand: 'UrbanWear',
    unitOfMeasure: 'piece',
    barcode: '8901234567056',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=800&q=80',
    ],

    price: 4500,
    sellingPrice: 4500,
    originalPrice: 6000,
    wholesalePrice: 3800,
    priceIncludesTax: true,

    hasVariants: true,
    variants: [
      {
        id: 'var-12-1',
        name: 'White - Large',
        sku: 'TSH-COT-WHT-L',
        cost: 2800,
        price: 4500,
        reorderLevel: 10,
        images: [],
        isActive: true,
        stockCount: 25,
      },
    ],

    trackInventory: true,
    reorderLevel: 10,
    reorderQuantity: 30,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 25,
    inStock: true,
    updatedAt: '2026-10-01T12:40:00.000Z',

    merchant: mockShopMerchants[1],

    rating: 4.5,
    reviewCount: 208,

    attributes: [
      { name: 'Color', value: 'White' },
      { name: 'Size', value: 'L' },
      { name: 'Material', value: '100% Cotton' },
    ],
  },

  // ============================================================
  // RAW MATERIAL
  // ============================================================

  {
    id: 'prod-13',
    slug: 'premium-cotton-fabric',
    name: 'Premium Cotton Fabric',
    sku: 'RAW-COT-FAB-001',
    type: 'Raw material',
    description:
      'High-quality cotton fabric suitable for clothing and textile production.',
    category: mockShopCategories[1],
    categoryName: 'Raw Materials',
    brand: 'TextilePro',
    unitOfMeasure: 'meter',
    barcode: '8901234567063',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=800&q=80',
    ],

    price: 2500,
    sellingPrice: 2500,
    originalPrice: 2800,
    wholesalePrice: 2200,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 50,
    reorderQuantity: 200,
    allowBackorder: false,

    isCommissionable: false,

    totalStock: 340,
    inStock: true,
    updatedAt: '2026-10-01T12:45:00.000Z',

    merchant: mockShopMerchants[1],

    rating: 4.3,
    reviewCount: 18,

    attributes: [
      { name: 'Material', value: 'Cotton' },
      { name: 'Width', value: '60 inches' },
      { name: 'Color', value: 'White' },
    ],
  },

  // ============================================================
  // SERVICE
  // ============================================================

  {
    id: 'prod-14',
    slug: 'laptop-repair-service',
    name: 'Laptop Repair Service',
    sku: 'SRV-LAP-REPAIR',
    type: 'Service',
    description:
      'Professional laptop diagnostics and repair service for hardware and software issues.',
    category: mockShopCategories[2],
    categoryName: 'Computer Services',
    brand: 'TechCare',
    unitOfMeasure: 'service',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80',
    ],

    price: 25000,
    sellingPrice: 25000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    // Services don't consume physical stock.
    trackInventory: false,
    reorderLevel: 0,
    reorderQuantity: 0,
    allowBackorder: true,

    isCommissionable: true,

    totalStock: 0,
    inStock: true,
    updatedAt: '2026-10-01T12:50:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.8,
    reviewCount: 47,

    attributes: [
      { name: 'Service Type', value: 'Laptop Repair' },
      { name: 'Duration', value: '1-3 business days' },
      { name: 'Warranty', value: '30 days' },
    ],
  },

  // ============================================================
  // BUNDLE
  // ============================================================

  {
    id: 'prod-15',
    slug: 'work-from-home-bundle',
    name: 'Work From Home Starter Bundle',
    sku: 'BND-WFH-STARTER',
    type: 'Bundle',
    description:
      'Complete starter bundle containing a wireless keyboard, laptop sleeve and portable Bluetooth speaker.',
    category: mockShopCategories[2],
    categoryName: 'Bundles',
    brand: 'TechBundle',
    unitOfMeasure: 'bundle',
    status: 'Active',

    images: [
      'https://images.unsplash.com/photo-1497215728101-856f4ea42174?auto=format&fit=crop&w=800&q=80',
    ],

    price: 55000,
    sellingPrice: 55000,
    originalPrice: 62000,
    wholesalePrice: 49000,
    priceIncludesTax: true,

    hasVariants: false,
    variants: [],

    trackInventory: true,
    reorderLevel: 3,
    reorderQuantity: 10,
    allowBackorder: false,

    isCommissionable: true,

    totalStock: 8,
    inStock: true,
    updatedAt: '2026-10-01T12:55:00.000Z',

    merchant: mockShopMerchants[0],

    rating: 4.7,
    reviewCount: 32,

    attributes: [
      { name: 'Bundle Type', value: 'Work From Home' },
      { name: 'Items', value: 'Keyboard, Laptop Sleeve, Speaker' },
      { name: 'Bundle Discount', value: '10%' },
    ],
  },
];
