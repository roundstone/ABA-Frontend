'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

export default function MerchantSidebar() {
  const pathname = usePathname();

  const links = [
    { href: '/merchant/dashboard', label: 'Merchant Dashboard' },
    { href: '/merchant/profile', label: 'Merchant Profile' },
    { href: '/merchant/become-merchant', label: 'Become a Merchant' },
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
