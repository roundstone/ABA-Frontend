'use client';

import React from 'react';
import Image from 'next/image';
import { Swiper, SwiperSlide } from 'swiper/react';
import { Pagination, Autoplay } from 'swiper/modules';
import 'swiper/css';
import 'swiper/css/pagination';

interface ProductGalleryProps {
  images: string[];
}

export default function ProductGallery({ images }: ProductGalleryProps) {
  return (
    <div className="sticky-details">
      <Swiper
        modules={[Pagination, Autoplay]}
        spaceBetween={20}
        slidesPerView={1}
        pagination={{ clickable: true }}
        autoplay={{ delay: 3000 }}
        breakpoints={{
          576: { slidesPerView: 2 },
          992: { slidesPerView: 3 },
        }}
        className="product-3-slider no-arrow"
      >
        {images.map((img, idx) => (
          <SwiperSlide key={idx}>
            <div className="product-slider-image">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={img} alt={`Product image ${idx + 1}`} className="img-fluid blur-up lazyloaded" />
            </div>
          </SwiperSlide>
        ))}
      </Swiper>
    </div>
  );
}
