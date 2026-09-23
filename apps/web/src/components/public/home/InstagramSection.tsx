"use client";
import React from 'react';
import Slider from 'react-slick';
import { PublicInstagramPost } from '@/services/mock/public.service';

interface InstagramSectionProps {
  instagramPosts: PublicInstagramPost[];
}

export function InstagramSection({ instagramPosts }: InstagramSectionProps) {
  const sliderSettings = {
    dots: false,
    infinite: true,
    speed: 500,
    slidesToShow: 7,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 2500,
    responsive: [
      { breakpoint: 1024, settings: { slidesToShow: 5 } },
      { breakpoint: 768, settings: { slidesToShow: 4 } },
      { breakpoint: 640, settings: { slidesToShow: 3 } },
      { breakpoint: 480, settings: { slidesToShow: 2 } }
    ]
  };

  return (
    <section className="instagram ratio_square">
      <div className="container-fluid">
        <div className="row">
          <div className="col-md-12 p-0">
            <h2 className="title-borderless"># instagram</h2>
            <Slider {...sliderSettings} className="slide-7 no-arrow slick-instagram">
              {instagramPosts.map((post) => (
                <div key={post.id}>
                  <div>
                    <a href={post.href}>
                      <div className="instagram-box">
                        <img alt="Instagram" className="bg-img" src={post.imageUrl} style={{ width: '100%', aspectRatio: '1/1', objectFit: 'cover' }} />
                        <div className="overlay"><i className="ri-instagram-fill"></i></div>
                      </div>
                    </a>
                  </div>
                </div>
              ))}
            </Slider>
          </div>
        </div>
      </div>
    </section>
  );
}
