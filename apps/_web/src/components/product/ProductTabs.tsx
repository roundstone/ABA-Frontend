'use client';

import React, { useState } from 'react';

export default function ProductTabs() {
  const [activeTab, setActiveTab] = useState('description');

  return (
    <div className="tab-product">
      <ul className="nav nav-tabs nav-material" role="tablist">
        <li className="nav-item">
          <button 
            className={`nav-link ${activeTab === 'description' ? 'active' : ''}`} 
            onClick={() => setActiveTab('description')}
            type="button"
          >
            <i className="icofont icofont-ui-home"></i>Description
          </button>
        </li>
        <li className="nav-item">
          <button 
            className={`nav-link ${activeTab === 'review' ? 'active' : ''}`} 
            onClick={() => setActiveTab('review')}
            type="button"
          >
            <i className="icofont icofont-contacts"></i>Review
          </button>
        </li>
        <li className="nav-item">
          <button 
            className={`nav-link ${activeTab === 'qa' ? 'active' : ''}`} 
            onClick={() => setActiveTab('qa')}
            type="button"
          >
            <i className="icofont icofont-contacts"></i>Q &amp; A
          </button>
        </li>
      </ul>
      <div className="tab-content nav-material">
        {activeTab === 'description' && (
          <div className="tab-pane fade show active">
            <div className="product-tab-description">
              <div className="part">
                <p>&quot;Gym Coords Set&quot; offers a comprehensive solution for those seeking comfort and style in their workout attire. This coordinated set is meticulously designed to elevate your gym experience, blending functionality with fashion seamlessly. Crafted from high-quality, breathable fabrics, each piece in the set ensures optimal performance and comfort during your exercise routines.</p>
                <p>The set includes everything you need for a complete workout ensemble, featuring coordinating tops, bottoms, and accessories. Whether you&apos;re hitting the treadmill, pumping iron, or attending a yoga class, the Gym Coords Set has you covered in both style and functionality.</p>
                <p>With its modern design and versatile color palette, this set transitions effortlessly from the gym to casual outings, making it a practical addition to any active lifestyle. Embrace the confidence and motivation that comes with looking and feeling your best during every workout session with the Gym Coords Set.</p>
              </div>
            </div>
          </div>
        )}
        
        {activeTab === 'review' && (
          <div className="tab-pane fade show active">
            <div className="single-product-tables">
              <div className="row g-3 w-100">
                <div className="col-xl-5">
                  <div className="product-rating-box">
                    <div className="row">
                      <div className="col-12">
                        <div className="rating-box">
                          <h4>Customer reviews</h4>
                          <div className="rating">
                            <i className="ri-star-fill"></i>
                            <i className="ri-star-fill"></i>
                            <i className="ri-star-fill"></i>
                            <i className="ri-star-fill"></i>
                            <i className="ri-star-line"></i>
                          </div>
                          <p>4.5 out of 5</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="col-xl-7">
                  <div className="review-box">
                    <div className="review-list">
                      <div className="review-content">
                        <h5>John Doe <span>(2 days ago)</span></h5>
                        <div className="rating">
                          <i className="ri-star-fill"></i>
                          <i className="ri-star-fill"></i>
                          <i className="ri-star-fill"></i>
                          <i className="ri-star-fill"></i>
                          <i className="ri-star-fill"></i>
                        </div>
                        <p>Very comfortable and fits perfectly. The material is breathable and good for workouts.</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}
        
        {activeTab === 'qa' && (
          <div className="tab-pane fade show active">
            <div className="single-product-tables">
              <h5>Frequently Asked Questions</h5>
              <div className="mt-3">
                <h6>Q: Is this machine washable?</h6>
                <p>A: Yes, it is safe to machine wash on a gentle cycle.</p>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
