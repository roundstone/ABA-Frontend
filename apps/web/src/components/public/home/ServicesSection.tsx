"use client";
import React from 'react';

export function ServicesSection() {
  return (
    <div className="container">
      <section className="service section-b-space">
        <div className="row partition4">
          <div className="col-lg-3 col-md-6 service-block1">
            <i className="ri-truck-line" style={{ fontSize: '40px', color: '#ff4c3b' }}></i>
            <h4>Nationwide Delivery</h4>
            <p>We deliver Aba products anywhere in Nigeria swiftly.</p>
          </div>
          <div className="col-lg-3 col-md-6 service-block1">
            <i className="ri-customer-service-2-line" style={{ fontSize: '40px', color: '#ff4c3b' }}></i>
            <h4>24 X 7 Service</h4>
            <p>Top-notch support for all our merchants and buyers.</p>
          </div>
          <div className="col-lg-3 col-md-6 service-block1">
            <i className="ri-price-tag-3-line" style={{ fontSize: '40px', color: '#ff4c3b' }}></i>
            <h4>Wholesale Offers</h4>
            <p>Get incredible discounts when you buy in bulk.</p>
          </div>
          <div className="col-lg-3 col-md-6 service-block1">
            <i className="ri-bank-card-line" style={{ fontSize: '40px', color: '#ff4c3b' }}></i>
            <h4>Secure Payment</h4>
            <p>100% secure payment gateways for all transactions.</p>
          </div>
        </div>
      </section>
    </div>
  );
}
