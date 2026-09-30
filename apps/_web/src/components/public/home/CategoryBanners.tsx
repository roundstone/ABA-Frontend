"use client";
import React from 'react';

export function CategoryBanners() {
  return (
    <div className="category-bg ratio_square">
      <div className="container-fluid p-0">
        <div className="row order-section">
          <div className="col-sm-4 p-0">
            <a className="image-block" href="#!"><img alt="" className="img-fluid  lazyload bg-img" src="/images/bags/banner/1.jpg"/></a>
          </div>
          <div className="col-sm-4 p-0">
            <div className="contain-block even">
              <div>
                <h6>new products</h6>
                <a href="#!"><h2>Local Handbags</h2></a>
                <a className="btn btn-solid category-btn" href="#!">-20% off</a>
                <a href="#!"><h6><span>shop now</span></h6></a>
              </div>
            </div>
          </div>
          <div className="col-sm-4 p-0">
            <a className="image-block" href="#!"><img alt="" className="img-fluid  lazyload bg-img" src="/images/bags/banner/2.jpg"/></a>
          </div>
        </div>
      </div>
    </div>
  );
}
