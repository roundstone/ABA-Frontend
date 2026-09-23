"use client";
import React from 'react';
import { PublicCategory } from '@/services/mock/public.service';

export type FilterState = {
  categories: string[];
  brands: string[];
  colors: string[];
  ratings: number[];
  priceRange: [number, number];
};

interface ShopSidebarProps {
  filters: FilterState;
  setFilters: React.Dispatch<React.SetStateAction<FilterState>>;
  categories: PublicCategory[];
  availableBrands: string[];
  availableColors: string[];
}

export function ShopSidebar({ filters, setFilters, categories, availableBrands, availableColors }: ShopSidebarProps) {
  const toggleFilter = (type: keyof FilterState, value: any) => {
    setFilters((prev) => {
      const current = prev[type] as any[];
      if (current.includes(value)) {
        return { ...prev, [type]: current.filter((item) => item !== value) };
      } else {
        return { ...prev, [type]: [...current, value] };
      }
    });
  };

  const setPriceRange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const max = parseInt(e.target.value);
    setFilters((prev) => ({ ...prev, priceRange: [0, max] }));
  };

  return (
    <>
      <div className="collection-filter-block">
        <button className="collection-mobile-back filter-back">
          <i className="ri-arrow-left-s-line"></i>
          <span>back</span>
        </button>

        {/* Categories Filter */}
        <div className="collection-collapse-block open">
          <h3 className="collapse-block-title">Categories</h3>
          <div className="collection-collapse-block-content">
            <div className="collection-brand-filter">
              {categories.map((cat) => (
                <div className="form-check collection-filter-checkbox" key={cat.id}>
                  <input 
                    className="form-check-input" 
                    id={`cat-${cat.id}`} 
                    type="checkbox" 
                    checked={filters.categories.includes(cat.name)}
                    onChange={() => toggleFilter('categories', cat.name)}
                  />
                  <label className="form-check-label" htmlFor={`cat-${cat.id}`}>
                    {cat.name}
                  </label>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Brand Filter */}
        <div className="collection-collapse-block open">
          <h3 className="collapse-block-title">brand</h3>
          <div className="collection-collapse-block-content">
            <div className="collection-brand-filter">
              {availableBrands.map((brand) => (
                <div className="form-check collection-filter-checkbox" key={brand}>
                  <input 
                    className="form-check-input" 
                    id={`brand-${brand}`} 
                    type="checkbox" 
                    checked={filters.brands.includes(brand)}
                    onChange={() => toggleFilter('brands', brand)}
                  />
                  <label className="form-check-label" htmlFor={`brand-${brand}`}>
                    {brand}
                  </label>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Colors Filter */}
        <div className="collection-collapse-block open">
          <h3 className="collapse-block-title">colors</h3>
          <div className="collection-collapse-block-content">
            <div className="collection-brand-filter">
              {availableColors.map((color) => (
                <div className="form-check collection-filter-checkbox" key={color}>
                  <input 
                    className="form-check-input" 
                    id={`color-${color}`} 
                    type="checkbox" 
                    checked={filters.colors.includes(color)}
                    onChange={() => toggleFilter('colors', color)}
                  />
                  <label className="form-check-label" htmlFor={`color-${color}`}>
                    {color}
                  </label>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Rating Filter */}
        <div className="collection-collapse-block open">
          <h3 className="collapse-block-title">Rating</h3>
          <div className="collection-collapse-block-content">
            <div className="collection-brand-filter">
              {[5, 4, 3, 2, 1].map((rating) => (
                <div className="form-check collection-filter-checkbox" key={`rating-${rating}`}>
                  <input 
                    className="form-check-input" 
                    id={`rating-${rating}`} 
                    type="checkbox" 
                    checked={filters.ratings.includes(rating)}
                    onChange={() => toggleFilter('ratings', rating)}
                  />
                  <label className="form-check-label" htmlFor={`rating-${rating}`}>
                    <span className="star-rating">
                      {[...Array(5)].map((_, i) => (
                        <i key={`rstar-${rating}-${i}`} className={i < rating ? "ri-star-fill" : "ri-star-line"} style={{ color: '#ffb321', fontSize: '14px', marginRight: '2px' }}></i>
                      ))}
                    </span>
                    <span style={{ marginLeft: '5px' }}>({rating} Star)</span>
                  </label>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Price Filter */}
        <div className="collection-collapse-block open">
          <h3 className="collapse-block-title">price</h3>
          <div className="collection-collapse-block-content">
            <div className="collection-brand-filter">
              <div className="wrapper mt-3">
                <div className="range-slider">
                  <input 
                    type="range" 
                    className="form-range" 
                    min="0" 
                    max="100000" 
                    step="1000"
                    value={filters.priceRange[1]}
                    onChange={setPriceRange}
                    style={{ width: '100%' }}
                  />
                  <div className="mt-2 text-muted fw-bold">
                    Up to ₦{filters.priceRange[1].toLocaleString()}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </>
  );
}
