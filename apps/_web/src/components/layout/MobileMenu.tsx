'use client';

import Link from 'next/link';
import { useState } from 'react';
import { MENU_ITEMS, MenuItem } from '@/data/menu';

export default function MobileMenu({ isOpen, onClose }: { isOpen: boolean; onClose: () => void }) {
  const [activeMenu, setActiveMenu] = useState<string | null>(null);

  const toggleMenu = (title: string) => {
    setActiveMenu(activeMenu === title ? null : title);
  };

  if (!isOpen) return null;

  return (
    <div className={`sidenav ${isOpen ? 'open' : ''}`} id="mySidenav" style={{ right: isOpen ? '0' : '-300px' }}>
      <button className="sidebar-overlay" onClick={onClose} aria-label="Close Mobile Menu"></button>
      <nav>
        <button onClick={onClose} className="sidebar-back text-start bg-transparent border-0 w-100 p-3">
          <i className="fa fa-angle-left pe-2"></i> Back
        </button>
        <ul className="sm pixelstrap sm-vertical" id="sub-menu">
          {MENU_ITEMS.map((item, index) => (
            <li key={index} className={item.megaMenu ? 'mega' : ''}>
              {item.type === 'link' ? (
                <Link href={item.path || '#!'} onClick={onClose}>
                  {item.title}
                </Link>
              ) : (
                <>
                  <button
                    className="w-100 text-start bg-transparent border-0 d-flex justify-content-between align-items-center"
                    onClick={() => toggleMenu(item.title)}
                  >
                    {item.title}
                    <i className={`fa fa-angle-${activeMenu === item.title ? 'down' : 'right'}`}></i>
                  </button>
                  {activeMenu === item.title && item.children && (
                    <ul className="mega-menu d-block position-relative shadow-none w-100">
                      {item.children.map((child, childIndex) => (
                        <li key={childIndex}>
                          <Link href={child.path || '#!'} onClick={onClose}>
                            {child.title}
                          </Link>
                        </li>
                      ))}
                    </ul>
                  )}
                </>
              )}
            </li>
          ))}
        </ul>
      </nav>
    </div>
  );
}
