'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

export default function UserSidebar() {
  const pathname = usePathname();

  const links = [
    { href: '/account/dashboard', label: 'Account Dashboard' },
    { href: '/account/profile', label: 'Profile' },
    { href: '/account/wishlist', label: 'My Wishlist' },
    { href: '/account/order-tracking', label: 'Track Order' },
  ];

  return (
    <div className="dashboard-left">
      <div className="collection-mobile-back">
        <span className="filter-back"><i className="fa fa-angle-left" aria-hidden="true"></i> back</span>
      </div>
      <div className="block-content">
        <ul>
          {links.map((link) => (
            <li key={link.href} className={pathname === link.href ? 'active' : ''}>
              <Link href={link.href}>{link.label}</Link>
            </li>
          ))}
          <li className="last"><a href="#">Log Out</a></li>
        </ul>
      </div>
    </div>
  );
}
