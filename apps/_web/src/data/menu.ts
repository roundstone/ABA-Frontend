export interface MenuItem {
  title: string;
  path?: string;
  type?: 'link' | 'sub';
  children?: MenuItem[];
  megaMenu?: boolean;
}

export const MENU_ITEMS: MenuItem[] = [
  {
    title: 'Home',
    path: '/',
    type: 'link',
  },
  {
    title: 'Shop',
    path: '/shop',
    type: 'link',
  },
  {
    title: 'About Us',
    path: '/about',
    type: 'link',
  },
  {
    title: 'Contact',
    path: '/contact',
    type: 'link',
  },
  {
    title: 'FAQ',
    path: '/faq',
    type: 'link',
  },
];
