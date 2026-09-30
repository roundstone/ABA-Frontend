'use client';

import { useAdminStore } from '@/store/useAdminStore';
import { ChevronRight, ChevronDown } from 'lucide-react';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { usePathname } from 'next/navigation';
import { ADMIN_SIDEBAR_MENU } from './sidebarConfig';

export default function AdminSidebar() {
  const { toggleSidebar, isSidebarOpen } = useAdminStore();
  const [activeMenu, setActiveMenu] = useState<string>('');
  const pathname = usePathname();

  useEffect(() => {
    if (!pathname) return;
    
    // Find which menu item should be active based on current path
    const currentActiveItem = ADMIN_SIDEBAR_MENU.find((item) => {
      if (item.submenu) {
        return item.submenu.some((sub) => pathname.startsWith(sub.href));
      }
      if (item.href) {
        if (item.href === '/admin') {
          return pathname === '/admin'; // Exact match for root dashboard
        }
        return pathname.startsWith(item.href);
      }
      return false;
    });

    if (currentActiveItem) {
      setActiveMenu(currentActiveItem.id);
    }
  }, [pathname]);

  const handleMenuClick = (menu: string) => {
    setActiveMenu(activeMenu === menu ? '' : menu);
  };

  return (
    <div className={`page-sidebar ${!isSidebarOpen ? 'open' : ''}`}>
      <div className="main-header-left d-none d-lg-block">
        <div className="logo-wrapper">
          <Link href="/admin">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img className="d-none d-lg-block blur-up lazyloaded" src="/admin-assets/images/dashboard/multikart-logo.png" alt="logo" />
          </Link>
        </div>
      </div>
      <div className="sidebar custom-scrollbar">
        <a href="#!" className="sidebar-back d-lg-none d-block" onClick={(e) => { e.preventDefault(); toggleSidebar(); }}>
          <i className="fa fa-times" aria-hidden="true"></i>
        </a>
        <ul className="sidebar-menu">
          {ADMIN_SIDEBAR_MENU.map((item) => {
            const isActive = activeMenu === item.id;
            
            if (!item.submenu) {
              return (
                <li key={item.id} className={isActive ? 'active' : ''}>
                  <Link 
                    className={`sidebar-header ${isActive ? 'active' : ''}`} 
                    href={item.href || '#!'}
                    onClick={() => {
                      if (!item.href) handleMenuClick(item.id);
                    }}
                  >
                    {item.icon ? item.icon : item.featherIcon ? <i data-feather={item.featherIcon}></i> : null}
                    <span>{item.title}</span>
                  </Link>
                </li>
              );
            }

            return (
              <li key={item.id} className={isActive ? 'active' : ''}>
                <a 
                  className={`sidebar-header ${isActive ? 'active' : ''}`} 
                  href="#!" 
                  onClick={(e) => { e.preventDefault(); handleMenuClick(item.id); }}
                >
                  {item.icon ? item.icon : item.featherIcon ? <i data-feather={item.featherIcon}></i> : null}
                  <span>{item.title}</span>
                  <div className="pull-right">
                    {isActive ? <ChevronDown size={18} /> : <ChevronRight size={18} />}
                  </div>
                </a>
                <ul className={`sidebar-submenu ${isActive ? 'menu-open' : ''}`} style={isActive ? { display: 'block' } : { display: 'none' }}>
                  {item.submenu.map((subItem, index) => {
                    const isSubActive = pathname?.startsWith(subItem.href);
                    return (
                      <li key={index} className={isSubActive ? 'active' : ''}>
                        <Link href={subItem.href} className={isSubActive ? 'active' : ''}>
                          <i className="fa fa-circle"></i>{subItem.title}
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              </li>
            );
          })}
        </ul>
      </div>
    </div>
  );
}
