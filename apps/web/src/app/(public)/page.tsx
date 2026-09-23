"use client";

import React, { useEffect, useState } from 'react';
import { PublicService, PublicProduct, PublicCategory, PublicBlogPost, PublicInstagramPost } from '@/services/mock/public.service';
import { TrendingProducts } from '@/components/public/home/TrendingProducts';
import { CategoryButtons } from '@/components/public/home/CategoryButtons';
import { ProductSliders } from '@/components/public/home/ProductSliders';
import { ServicesSection } from '@/components/public/home/ServicesSection';
import { CategoryBanners } from '@/components/public/home/CategoryBanners';
import { ExclusiveTrend } from '@/components/public/home/ExclusiveTrend';
import { BlogSection } from '@/components/public/home/BlogSection';
import { InstagramSection } from '@/components/public/home/InstagramSection';

export default function HomePage() {
  const [products, setProducts] = useState<PublicProduct[]>([]);
  const [categories, setCategories] = useState<PublicCategory[]>([]);
  const [blogPosts, setBlogPosts] = useState<PublicBlogPost[]>([]);
  const [instagramPosts, setInstagramPosts] = useState<PublicInstagramPost[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [fetchedProducts, fetchedCategories, fetchedBlogs, fetchedInstagram] = await Promise.all([
          PublicService.getProducts(),
          PublicService.getCategories(),
          PublicService.getBlogPosts(),
          PublicService.getInstagramPosts(),
        ]);
        setProducts(fetchedProducts);
        setCategories(fetchedCategories);
        setBlogPosts(fetchedBlogs);
        setInstagramPosts(fetchedInstagram);
        setMounted(true);
      } catch (error) {
        console.error("Failed to load homepage data", error);
        setMounted(true);
      }
    };
    fetchData();
  }, []);

  if (!mounted) {
    return (
      <div style={{ height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <div className="spinner-border text-primary" role="status" style={{ width: '3rem', height: '3rem' }}>
          <span className="visually-hidden">Loading...</span>
        </div>
      </div>
    );
  }

  return (
    <>
      {/* Home Slider */}
      <section className="p-0">
        <a href="#!">
          <img alt="" className="img-fluid lazyload" src="/images/bags/full-banner/1.png"/>
        </a>
      </section>

      <TrendingProducts products={products} categories={categories} />
      <CategoryButtons categories={categories} />

      {/* Parallax banner */}
      <section className="p-0">
        <a href="#!">
          <img alt="" className="img-fluid lazyload" src="/images/bags/full-banner/2.png"/>
        </a>
      </section>

      <ProductSliders products={products} />
      <ServicesSection />
      <CategoryBanners />
      <ExclusiveTrend products={products} />
      <BlogSection blogPosts={blogPosts} />
      <InstagramSection instagramPosts={instagramPosts} />
    </>
  );
}
