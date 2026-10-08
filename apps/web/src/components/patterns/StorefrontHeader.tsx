'use client';

import React, { useState, useEffect } from 'react';
import { brand } from '@/config/brand';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Search, ShoppingCart, Menu, X, User, ArrowRight, Store, TrendingUp } from 'lucide-react';
import { Button } from '@/components/ui/button';
import Image from 'next/image';
import { useCartStore } from '@/features/cart/store';
import { useAuthStore } from '@/features/auth/store';
import { MegaMenu } from './MegaMenu';
import { CategorySearchSelect } from './CategorySearchSelect';
import { MobileMenu } from './MobileMenu';
import { SellEarnCtas } from './SellEarnCtas';
import { PointsChip } from '@/features/rewards/components/PointsChip';

export function StorefrontHeader() {
  const pathname = usePathname();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const isAuthenticated = useAuthStore(state => state.isAuthenticated);
  const user = useAuthStore(state => state.user);
  const [scrolled, setScrolled] = useState(false);
  const [isVisible, setIsVisible] = useState(true);
  const [isHovered, setIsHovered] = useState(false);

  // Get cart item count from store
  const totalItems = useCartStore(state => state.getTotalItems());
  // Hydration safety for Zustand persist
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  const isLoggedIn = mounted && isAuthenticated;

  useEffect(() => {
    let timeout: NodeJS.Timeout;

    const handleScroll = () => {
      const isScrolled = window.scrollY > 20;
      setScrolled(isScrolled);

      if (isScrolled) {
        setIsVisible(true);
        clearTimeout(timeout);
        timeout = setTimeout(() => {
          setIsVisible(false);
        }, 2500); // Hide after 2.5 seconds of scroll inactivity
      } else {
        setIsVisible(true);
        clearTimeout(timeout);
      }
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => {
      window.removeEventListener('scroll', handleScroll);
      clearTimeout(timeout);
    };
  }, []);

  const shouldShow = !scrolled || isVisible || isHovered;

  const navLinks = [
    { name: 'Shop', href: '/shop' },
    { name: 'Merchants', href: '/merchants' },
    { name: 'Community', href: '/community' },
    { name: 'About', href: '/about' },
  ];

  const toggleMobileMenu = () => setMobileMenuOpen(!mobileMenuOpen);

  return (
    <>
      <header
        onMouseEnter={() => setIsHovered(true)}
        onMouseLeave={() => setIsHovered(false)}
        className={`fixed left-0 right-0 z-50 flex flex-col items-center px-2 w-full transition-all duration-500 ${scrolled ? 'top-0' : 'top-2'} ${!shouldShow ? 'lg:-translate-y-full lg:opacity-0' : 'translate-y-0 opacity-100'}`}
      >
        {/* Utility Strip */}
        <div className="w-full max-w-7xl bg-brand-50 border border-brand-100 rounded-t-xl md:rounded-t-2xl p-2 flex flex-col md:flex-row justify-between items-center gap-2">
          {/* Block 1: Search */}
          <div className="relative w-full md:w-auto flex flex-1 max-w-md">
            <CategorySearchSelect />
            <input
              type="text"
              placeholder="Search for anything"
              className="w-full h-9 pl-[120px] pr-10 rounded-full border border-border bg-white text-sm focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 transition-all placeholder:text-text-muted/70"
            />
            <Search className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" />
          </div>

          {/* Block 2: Sell & Earn */}
          <SellEarnCtas />
        </div>

        {/* Main Header */}
        <div className="bg-white/95 max-w-7xl backdrop-blur-md shadow-[0_8px_30px_rgb(0,0,0,0.08)] border border-border/50 p-2 flex items-center justify-between w-full transition-all rounded-b-xl md:rounded-b-2xl">

          {/* Left Side: Logo & Links */}
          <div className="flex items-center gap-8 pl-4 lg:pl-6">
            {/* Logo */}
            <Link href="/" className="shrink-0 flex items-center">
              <Image
                src={brand.logo.full}
                alt={brand.name}
                width={120}
                height={40}
                className="h-8 w-auto object-contain"
                priority
              />
            </Link>

            {/* Desktop Navigation */}
            <nav className="hidden lg:flex items-center space-x-1">
              {navLinks.map((link) => (
                <Link
                  key={link.name}
                  href={link.href}
                  className={`px-4 py-2 rounded-full text-[13px] font-bold tracking-[0.08em] uppercase transition-colors ${pathname === link.href ? 'text-brand-700 bg-brand-50' : 'text-text-muted hover:text-brand-600 hover:bg-surface-1'
                    }`}
                >
                  {link.name}
                </Link>
              ))}
            </nav>
          </div>

          {/* Right Side: Actions */}
          <div className="flex items-center gap-2">
            {/* Search, Cart, Account (Desktop) */}
            <div className="hidden md:flex items-center space-x-2">

              <Link href="/cart" className="relative p-3 text-text-muted hover:text-brand-600 transition-colors bg-surface-1 hover:bg-brand-50 rounded-full">
                <ShoppingCart className="w-5 h-5" />
                {mounted && totalItems > 0 && (
                  <span className="absolute top-1.5 right-1.5 flex items-center justify-center w-4 h-4 text-[10px] font-bold text-white bg-brand-600 rounded-full shadow-sm">
                    {totalItems}
                  </span>
                )}
              </Link>
            </div>

            <div className="hidden md:block h-6 w-px bg-border mx-1"></div>

            {isLoggedIn ? (
              <div className="hidden md:flex items-center gap-2 pr-4 border-r border-border mr-2">
                <PointsChip />
              </div>
            ) : null}

            {isLoggedIn ? (
              <Link href="/portal/dashboard" className="hidden md:flex items-center gap-2 p-1.5 pr-4 border border-border hover:border-brand-500 transition-colors hover:shadow-sm">
                <div className="w-8 h-8 rounded-full bg-brand-100 flex items-center justify-center text-brand-700 text-xs font-bold">
                  {user?.name?.[0] || 'J'}{user?.name?.[1] || 'D'}
                </div>
                <span className="text-sm font-bold text-text uppercase tracking-wide">{user?.name || 'User'}</span>
              </Link>
            ) : (
              <div className="hidden md:flex items-center gap-2 pl-2">
                <Link href="/auth/login" className="px-3 text-[13px] font-bold text-text-muted hover:text-brand-600 uppercase tracking-wide">
                  Log in
                </Link>
                <Link href="/auth/register">
                  <Button className="h-11 px-6 text-white shadow-md font-bold uppercase tracking-wide text-[13px] flex items-center gap-2">
                    <User className="w-4 h-4" /> Register
                  </Button>
                </Link>
              </div>
            )}

            {/* Mobile Menu Button */}
            <div className="flex items-center gap-2 lg:hidden pl-2">
              <Link href="/cart" className="relative p-2 text-text-muted bg-surface-1 rounded-full md:hidden">
                <ShoppingCart className="w-5 h-5" />
                {mounted && totalItems > 0 && (
                  <span className="absolute top-0 right-0 flex items-center justify-center w-4 h-4 text-[10px] font-bold text-white bg-brand-600 rounded-full shadow-sm">
                    {totalItems}
                  </span>
                )}
              </Link>
              <button onClick={toggleMobileMenu} className="text-text p-3 bg-surface-2 hover:bg-surface-3 rounded-full transition-colors">
                {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
              </button>
            </div>
          </div>
        </div>

        <div className={` max-w-7xl hidden lg:block transition-all duration-500 ${scrolled ? '  pointer-events-none' : '  '}`}>
          <MegaMenu />
        </div>

      </header>


      {/* Mobile Navigation Menu */}
      {/* Mobile Navigation Menu */}
      {mobileMenuOpen && (
        <MobileMenu
          isOpen={mobileMenuOpen}
          onClose={() => setMobileMenuOpen(false)}
          navLinks={navLinks}
        />
      )}
    </>
  );
}
