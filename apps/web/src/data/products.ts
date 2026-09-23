export interface Product {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  discountPercentage?: number;
  image: string;
  images?: string[];
  rating?: number;
  reviews?: number;
  isTrending?: boolean;
  isNew?: boolean;
}

export const PRODUCTS: Product[] = [
  {
    id: '1',
    name: 'Wander Pack Heaven Backpack',
    price: 20.39,
    originalPrice: 24.0,
    discountPercentage: 7,
    image: '/images/bags/product/1.jpg',
    rating: 5,
    reviews: 10,
    isTrending: true,
  },
  {
    id: '2',
    name: 'Dressberry Backpack',
    price: 18.36,
    image: '/images/bags/product/2.jpg',
    rating: 4.5,
    reviews: 8,
    isTrending: true,
  },
  {
    id: '3',
    name: 'Auralux Training Backpack',
    price: 19.68,
    originalPrice: 22.0,
    discountPercentage: 9,
    image: '/images/bags/product/3.jpg',
    rating: 5,
    reviews: 12,
  },
  {
    id: '4',
    name: 'Couture Edge Versatile Shacket',
    price: 3.0,
    image: '/images/fashion-1/product/16.jpg',
    rating: 4.8,
    reviews: 20,
    isNew: true,
  }
];
