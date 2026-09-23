"use client";
import React from 'react';
import { PublicCategory } from '@/services/mock/public.service';

interface CategoryButtonsProps {
  categories: PublicCategory[];
}

export function CategoryButtons({ categories }: CategoryButtonsProps) {
  return (
    <div className="container category-button">
      <section className="section-b-space border-section border-bottom-0">
        <div className="row partition1">
          {categories.map((cat) => (
            <div className="col" key={cat.id}>
              <a className="btn btn-outline btn-block" href={cat.href}>{cat.name}</a>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
