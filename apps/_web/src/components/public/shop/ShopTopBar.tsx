"use client";
import React from 'react';

interface ShopTopBarProps {
  sortBy: string;
  setSortBy: (val: string) => void;
  activeLayout: string;
  handleLayoutChange: (layout: string, gridClass: string, isList?: boolean) => void;
  toggleFilterMobile: () => void;
}

export function ShopTopBar({ sortBy, setSortBy, activeLayout, handleLayoutChange, toggleFilterMobile }: ShopTopBarProps) {
  return (
    <>
      <button className="filter-btn btn mt-0 d-xl-none mb-3" onClick={toggleFilterMobile}>
        <i className="ri-filter-fill"></i>
        Filter
      </button>
      <div className="product-top-filter mt-0">
        <div className="product-filter-content w-100">
          <div className="d-flex align-items-center gap-sm-3 gap-2">
            <select 
              className="form-select"
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
            >
              <option value="featured">Featured</option>
              <option value="asc">Alphabetically, A-Z</option>
              <option value="desc">Alphabetically, Z-A</option>
              <option value="price-low">Price, low to high</option>
              <option value="price-high">Price, high to low</option>
            </select>
            <select className="form-select">
              <option value="10">10 Products</option>
              <option value="25">25 Products</option>
              <option value="50">50 Products</option>
              <option value="100">100 Products</option>
            </select>
          </div>
          <div className="collection-grid-view">
            <ul>
              <li className={`product-2-layout-view grid-icon ${activeLayout === 'product-2' ? 'active' : ''}`} onClick={() => handleLayoutChange('product-2', 'col-6')}>
                <img alt="sort" src="/images/inner-page/icon/2.png" />
              </li>
              <li className={`product-3-layout-view grid-icon ${activeLayout === 'product-3' ? 'active' : ''}`} onClick={() => handleLayoutChange('product-3', 'col-xl-4 col-6')}>
                <img alt="sort" src="/images/inner-page/icon/3.png" />
              </li>
              <li className={`product-4-layout-view grid-icon ${activeLayout === 'product-4' ? 'active' : ''}`} onClick={() => handleLayoutChange('product-4', 'col-xl-3 col-6')}>
                <img alt="sort" src="/images/inner-page/icon/4.png" />
              </li>
              <li className={`list-layout-view list-icon ${activeLayout === 'list' ? 'active' : ''}`} onClick={() => handleLayoutChange('list', 'col-sm-12 col-6', true)}>
                <img alt="sort" src="/images/inner-page/icon/list.png" />
              </li>
            </ul>
          </div>
        </div>
      </div>
    </>
  );
}
