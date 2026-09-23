"use client";
import React, { useEffect, useState, useMemo } from 'react';
import Slider from 'react-slick';
import Breadcrumb from '@/components/ui/Breadcrumb';
import { ShopSidebar, FilterState } from '@/components/public/shop/ShopSidebar';
import { ShopTopBar } from '@/components/public/shop/ShopTopBar';
import { ShopProductGrid } from '@/components/public/shop/ShopProductGrid';
import { PublicService, PublicProduct, PublicCategory } from '@/services/mock/public.service';

export default function ShopPage() {
    const [products, setProducts] = useState<PublicProduct[]>([]);
    const [categories, setCategories] = useState<PublicCategory[]>([]);
    const [isLoading, setIsLoading] = useState(true);

    const [gridClass, setGridClass] = useState('col-xl-4 col-6');
    const [isListView, setIsListView] = useState(false);
    const [activeLayout, setActiveLayout] = useState('product-3');

    const [sortBy, setSortBy] = useState('featured');
    
    // Filter State
    const [filters, setFilters] = useState<FilterState>({
        categories: [],
        brands: [],
        colors: [],
        ratings: [],
        priceRange: [0, 100000],
    });

    const [isFilterMobileOpen, setIsFilterMobileOpen] = useState(false);

    useEffect(() => {
        const fetchData = async () => {
            setIsLoading(true);
            const [fetchedProducts, fetchedCategories] = await Promise.all([
                PublicService.getProducts(),
                PublicService.getCategories(),
            ]);
            setProducts(fetchedProducts);
            setCategories(fetchedCategories);
            setIsLoading(false);
        };
        fetchData();
    }, []);

    const handleLayoutChange = (layout: string, newGridClass: string, isList = false) => {
        setActiveLayout(layout);
        setGridClass(newGridClass);
        setIsListView(isList);
    };

    // Derived unique brands and colors for filters
    const availableBrands = useMemo(() => Array.from(new Set(products.map(p => p.brand))), [products]);
    const availableColors = useMemo(() => {
        const colors = new Set<string>();
        products.forEach(p => {
            if (p.colors) p.colors.forEach(c => colors.add(c));
        });
        return Array.from(colors);
    }, [products]);

    // Apply filtering and sorting dynamically
    const filteredAndSortedProducts = useMemo(() => {
        let result = [...products];

        // Apply Filters
        if (filters.categories.length > 0) {
            result = result.filter(p => filters.categories.includes(p.category));
        }
        if (filters.brands.length > 0) {
            result = result.filter(p => filters.brands.includes(p.brand));
        }
        if (filters.colors.length > 0) {
            result = result.filter(p => p.colors && p.colors.some(c => filters.colors.includes(c)));
        }
        if (filters.ratings.length > 0) {
            result = result.filter(p => filters.ratings.includes(Math.floor(p.rating)));
        }
        result = result.filter(p => p.price >= filters.priceRange[0] && p.price <= filters.priceRange[1]);

        // Apply Sorting
        switch (sortBy) {
            case 'asc':
                result.sort((a, b) => a.name.localeCompare(b.name));
                break;
            case 'desc':
                result.sort((a, b) => b.name.localeCompare(a.name));
                break;
            case 'price-low':
                result.sort((a, b) => a.price - b.price);
                break;
            case 'price-high':
                result.sort((a, b) => b.price - a.price);
                break;
            default:
                break;
        }

        return result;
    }, [products, filters, sortBy]);

    const categorySliderSettings = {
        dots: false,
        infinite: true,
        speed: 500,
        slidesToShow: 6,
        slidesToScroll: 1,
        autoplay: true,
        autoplaySpeed: 3000,
        responsive: [
            { breakpoint: 1200, settings: { slidesToShow: 5 } },
            { breakpoint: 992, settings: { slidesToShow: 4 } },
            { breakpoint: 768, settings: { slidesToShow: 3 } },
            { breakpoint: 576, settings: { slidesToShow: 2 } },
        ]
    };

    return (
        <>
            <Breadcrumb
                title="Collection"
                items={[{ label: 'Home', url: '/' }, { label: 'Shop' }]}
            />
            
            {/*  Category Slider Start  */}
            <section className="category-slider-section">
                <div className="container">
                    <Slider {...categorySliderSettings} className="product-category-slider no-arrow">
                        {categories.map((cat, index) => (
                            <div key={index}>
                                <div>
                                    <a className="category-box" href="#!">
                                        <img alt={cat.name} className="img-fluid" src={cat.imageUrl || `/images/category/${index % 12 + 1}.png`} />
                                        <h5>{cat.name}</h5>
                                    </a>
                                </div>
                            </div>
                        ))}
                    </Slider>
                </div>
            </section>
            
            {/*  Shop Main Section start  */}
            <section className="section-b-space ratio_asos">
                <div className="collection-wrapper">
                    <div className="container">
                        <div className="row">
                            
                            {/* Sidebar Filters */}
                            <div className={`col-xl-3 col-lg-4 collection-filter ${isFilterMobileOpen ? 'openFilter' : ''}`}>
                                <ShopSidebar 
                                    filters={filters} 
                                    setFilters={setFilters}
                                    categories={categories}
                                    availableBrands={availableBrands}
                                    availableColors={availableColors}
                                />
                            </div>

                            {/* Product Grid Area */}
                            <div className="collection-content col-xl-9 col-lg-8">
                                <div className="page-main-content">
                                    <div className="row">
                                        <div className="col-sm-12">
                                            <div className="top-banner-wrapper">
                                                <a href="#!"><img alt="" className="img-fluid blur-up lazyload"
                                                        src="/images/mega-menu/2.jpg" /></a>
                                                <div className="top-banner-content small-section">
                                                    <h4>BIGGEST SALE ON FASHION</h4>
                                                    <h5>Welcome to the ABA Shop. Discover handcrafted quality items from local artisans.</h5>
                                                    <p>
                                                        Experience premium quality with our curated selection of products. 
                                                        Crafted perfectly for everyday use and built to last.
                                                    </p>
                                                </div>
                                            </div>
                                            <div className="collection-product-wrapper">
                                                <ShopTopBar 
                                                    sortBy={sortBy}
                                                    setSortBy={setSortBy}
                                                    activeLayout={activeLayout}
                                                    handleLayoutChange={handleLayoutChange}
                                                    toggleFilterMobile={() => setIsFilterMobileOpen(!isFilterMobileOpen)}
                                                />

                                                {isLoading ? (
                                                    <div className="row text-center mt-5">
                                                        <div className="col-12">
                                                            <div className="spinner-border text-primary" role="status">
                                                                <span className="visually-hidden">Loading...</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                ) : (
                                                    <ShopProductGrid 
                                                        products={filteredAndSortedProducts}
                                                        isListView={isListView}
                                                        gridClass={gridClass}
                                                    />
                                                )}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </>
    );
}
