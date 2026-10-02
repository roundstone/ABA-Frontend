'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Search, ShoppingCart, Menu, X, User, ArrowRight } from 'lucide-react';
import { Button } from '@/components/ui/button';
import Image from 'next/image';
import { useCartStore } from '@/features/cart/store';
import { useAuthStore } from '@/features/auth/store';

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
    { name: 'Home', href: '/' },
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
        className={`fixed left-0 right-0 z-50 flex justify-center px-4 w-full transition-all duration-500 ${scrolled ? 'top-2' : 'top-6'} ${!shouldShow ? 'lg:-translate-y-full lg:opacity-0' : 'translate-y-0 opacity-100'}`}
      >
        <div className="bg-white/95 backdrop-blur-md shadow-[0_8px_30px_rgb(0,0,0,0.08)] border border-border/50 p-2 flex items-center justify-between w-full max-w-7xl transition-all">

          {/* Left Side: Logo & Links */}
          <div className="flex items-center gap-8 pl-4 lg:pl-6">
            {/* Logo */}
            <Link href="/" className="shrink-0 flex items-center">
              <Image
                src="/aba-logo.png"
                alt="ABA Online"
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
              <div className="relative group">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 group-focus-within:text-brand-600 transition-colors" />
                <input
                  type="text"
                  placeholder="Search..."
                  className="w-32 lg:w-48 h-11 pl-9 pr-4 rounded-full border-none bg-surface-2 text-sm font-medium focus:outline-none focus:ring-2 focus:ring-brand-500 transition-all placeholder:text-text-muted/70"
                />
              </div>

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
      </header>

      {/* Mobile Navigation Menu */}
      {mobileMenuOpen && (
        <div className="fixed inset-0 z-40 bg-white pt-24 pb-6 px-4 overflow-y-auto animate-in slide-in-from-top-full duration-300">
          <div className="max-w-md mx-auto space-y-6">
            <div className="relative">
              <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-text-muted" />
              <input
                type="text"
                placeholder="Search products..."
                className="w-full h-14 pl-12 pr-4 rounded-full border bg-surface-1 text-base font-medium focus:outline-none focus:border-brand-500 focus:ring-1 focus:ring-brand-500 shadow-sm"
              />
            </div>

            <nav className="flex flex-col space-y-2">
              {navLinks.map((link) => (
                <Link
                  key={link.name}
                  href={link.href}
                  className="px-4 py-4 rounded-2xl text-lg font-bold text-text hover:bg-surface-2 flex items-center justify-between uppercase tracking-wide"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  {link.name}
                  <ArrowRight className="w-5 h-5 text-text-muted" />
                </Link>
              ))}
            </nav>

            <div className="pt-6 border-t border-border">
              {isLoggedIn ? (
                <Link
                  href="/portal/dashboard"
                  className="flex items-center justify-between px-4 py-4 rounded-2xl bg-brand-50 text-brand-900 hover:bg-brand-100 transition-colors uppercase tracking-wide font-bold"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-white flex items-center justify-center text-brand-700 shadow-sm">
                      {user?.name?.[0] || 'J'}{user?.name?.[1] || 'D'}
                    </div>
                    <span>My Portal</span>
                  </div>
                  <ArrowRight className="w-5 h-5" />
                </Link>
              ) : (
                <div className="flex flex-col gap-3">
                  <Link href="/auth/register" className="w-full" onClick={() => setMobileMenuOpen(false)}>
                    <Button size="lg" className="w-full rounded-full h-14 text-white font-bold uppercase tracking-wide text-base shadow-md">
                      Register
                    </Button>
                  </Link>
                  <Link href="/auth/login" className="w-full" onClick={() => setMobileMenuOpen(false)}>
                    <Button variant="outline" size="lg" className="w-full rounded-full h-14 font-bold uppercase tracking-wide text-base border-2">
                      Log in
                    </Button>
                  </Link>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
}
