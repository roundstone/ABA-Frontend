'use client';

export default function SearchPopup() {
  return (
    <>
      <div className="modal fade search-modal theme-modal-2" id="searchModal" tabIndex={-1}>
<div className="modal-dialog modal-dialog-centered modal-xl">
<div className="modal-content">
<div className="modal-header">
<h3 className="modal-title fs-5">Search in store</h3>
<button className="btn-close" data-bs-dismiss="modal" type="button">
<i className="ri-close-line"></i>
</button>
</div>
<div className="modal-body">
<div className="search-input-box">
<input className="form-control" placeholder="Search with brands and categories..." type="text"/>
<i className="ri-search-2-line"></i>
</div>
<ul className="search-category">
<li className="category-title">Top search:</li>
<li>
<a href="category-page.html">Baby Essentials</a>
</li>
<li>
<a href="category-page.html">Bag Emporium</a>
</li>
<li>
<a href="category-page.html">Bags</a>
</li>
<li>
<a href="category-page.html">Books</a>
</li>
</ul>
<div className="search-product-box mt-sm-4 mt-3">
<h3 className="search-title">Most Searched</h3>
<div className="row row-cols-xl-4 row-cols-md-3 row-cols-2 g-sm-4 g-3">
<div className="col">
<div className="basic-product theme-product-1">
<div className="overflow-hidden">
<div className="img-wrapper">
<div className="ribbon"><span>Exclusive</span></div>
<a href="/product/1">
<img alt="" className="img-fluid blur-up lazyloaded" src="/images/fashion-1/product/1.jpg"/>
</a>
<div className="rating-label"><i className="ri-star-fill"></i><span>2.5</span>
</div>
<div className="cart-info">
<a className="wishlist-icon" href="#!" title="Add to Wishlist">
<i className="ri-heart-line"></i>
</a>
<button data-bs-target="#cartOffcanvas" data-bs-toggle="offcanvas" title="Add to cart">
<i className="ri-shopping-cart-line"></i>
</button>
<a data-bs-toggle="modal" href="#quickView" title="Quick View">
<i className="ri-eye-line"></i>
</a>
<a href="compare.html" title="Compare">
<i className="ri-loop-left-line"></i>
</a>
</div>
</div>
<div className="product-detail">
<div>
<div className="brand-w-color">
<a className="product-title" href="/product/1">
                                                        Glamour Gaze
                                                    </a>
<div className="color-panel">
<ul>
<li ></li>
<li ></li>
<li ></li>
</ul>
<span>+2</span>
</div>
</div>
<h6>Boyfriend Shirts</h6>
<h4 className="price">$ 2.79<del> $3.00 </del><span className="discounted-price"> 7%
                                                        Off
                                                    </span>
</h4>
</div>
<ul className="offer-panel">
<li>
<span className="offer-icon">
<i className="ri-discount-percent-fill"></i>
</span>
                                                    Limited Time Offer: 4% off
                                                </li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 4% off</li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 4% off</li>
</ul>
</div>
</div>
</div>
</div>
<div className="col">
<div className="basic-product theme-product-1">
<div className="overflow-hidden">
<div className="img-wrapper">
<a href="/product/1"><img alt="" className="img-fluid blur-up lazyloaded" src="/images/fashion-1/product/11.jpg"/></a>
<div className="rating-label"><i className="ri-star-fill"></i>
<span>6.5</span>
</div>
<div className="cart-info">
<a className="wishlist-icon" href="#!" title="Add to Wishlist">
<i className="ri-heart-line"></i>
</a>
<button data-bs-target="#cartOffcanvas" data-bs-toggle="offcanvas" title="Add to cart">
<i className="ri-shopping-cart-line"></i>
</button>
<a data-bs-toggle="modal" href="#quickView" title="Quick View">
<i className="ri-eye-line"></i>
</a>
<a href="compare.html" title="Compare">
<i className="ri-loop-left-line"></i>
</a>
</div>
</div>
<div className="product-detail">
<div>
<div className="brand-w-color">
<a className="product-title" href="/product/1">
                                                        VogueVista
                                                    </a>
</div>
<h6>Chic Crop Top</h6>
<h4 className="price">$ 5.60<del> $6.80 </del><span className="discounted-price"> 5%
                                                        Off
                                                    </span>
</h4>
</div>
<ul className="offer-panel">
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 25% off</li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 25% off</li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 25% off</li>
</ul>
</div>
</div>
</div>
</div>
<div className="col">
<div className="basic-product theme-product-1">
<div className="overflow-hidden">
<div className="img-wrapper">
<a href="/product/1"><img alt="" className="img-fluid blur-up lazyloaded" src="/images/fashion-1/product/15.jpg"/></a>
<div className="rating-label"><i className="ri-star-fill"></i>
<span>3.7</span>
</div>
<div className="cart-info">
<a className="wishlist-icon" href="#!" title="Add to Wishlist">
<i className="ri-heart-line"></i>
</a>
<button data-bs-target="#cartOffcanvas" data-bs-toggle="offcanvas" title="Add to cart">
<i className="ri-shopping-cart-line"></i>
</button>
<a data-bs-toggle="modal" href="#quickView" title="Quick View">
<i className="ri-eye-line"></i>
</a>
<a href="compare.html" title="Compare">
<i className="ri-loop-left-line"></i>
</a>
</div>
</div>
<div className="product-detail">
<div>
<div className="brand-w-color">
<a className="product-title" href="/product/1">
                                                        Urban Chic
                                                    </a>
</div>
<h6>Classic Jacket</h6>
<h4 className="price">$ 3.80 </h4>
</div>
<ul className="offer-panel">
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 10% off</li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 10% off</li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 10% off</li>
</ul>
</div>
</div>
</div>
</div>
<div className="col">
<div className="basic-product theme-product-1">
<div className="overflow-hidden">
<div className="img-wrapper">
<a href="/product/1">
<img alt="" className="img-fluid blur-up lazyloaded" src="/images/fashion-1/product/16.jpg"/>
</a>
<div className="rating-label"><i className="ri-star-fill"></i>
<span>8.7</span>
</div>
<div className="cart-info">
<a className="wishlist-icon" href="#!" title="Add to Wishlist">
<i className="ri-heart-line"></i>
</a>
<button data-bs-target="#cartOffcanvas" data-bs-toggle="offcanvas" title="Add to cart">
<i className="ri-shopping-cart-line"></i>
</button>
<a data-bs-toggle="modal" href="#quickView" title="Quick View">
<i className="ri-eye-line"></i>
</a>
<a href="compare.html" title="Compare">
<i className="ri-loop-left-line"></i>
</a>
</div>
</div>
<div className="product-detail">
<div>
<div className="brand-w-color">
<a className="product-title" href="/product/1">
                                                        Couture Edge
                                                    </a>
</div>
<h6>Versatile Shacket</h6>
<h4 className="price"> $3.00
                                                </h4>
</div>
<ul className="offer-panel">
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 12% off</li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 12% off</li>
<li><span className="offer-icon"><i className="ri-discount-percent-fill"></i></span>
                                                    Limited Time Offer: 12% off</li>
</ul>
</div>
</div>
</div>
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
