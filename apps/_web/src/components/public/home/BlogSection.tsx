"use client";
import React from 'react';
import Slider from 'react-slick';
import { PublicBlogPost } from '@/services/mock/public.service';

interface BlogSectionProps {
  blogPosts: PublicBlogPost[];
}

export function BlogSection({ blogPosts }: BlogSectionProps) {
  const sliderSettings = {
    dots: false,
    infinite: true,
    speed: 500,
    slidesToShow: 3,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 4000,
    responsive: [
      { breakpoint: 1024, settings: { slidesToShow: 3 } },
      { breakpoint: 768, settings: { slidesToShow: 2 } },
      { breakpoint: 640, settings: { slidesToShow: 1 } }
    ]
  };

  return (
    <section className="blog ratio3_2 slick-default-margin">
      <div className="container">
        <div className="row">
          <div className="col-md-12">
            <div className="title2">
              <h4>recent story</h4>
              <h2 className="title-inner2">latest blog</h2>
            </div>
            <Slider {...sliderSettings} className="slide-3 no-arrow">
              {blogPosts.map((post) => (
                <div key={post.id}>
                  <div className="col-md-12">
                    <a href={post.href}>
                      <div className="classic-effect">
                        <div>
                          <img alt={post.title} className="img-fluid  lazyload bg-img" src={post.imageUrl} />
                          <span></span>
                        </div>
                      </div>
                    </a>
                    <div className="blog-details">
                      <h4>{post.date}</h4>
                      <a href={post.href}><p>{post.title}</p></a>
                      <hr className="style1"/>
                      <h6>by: {post.author} , {post.commentCount} Comment(s)</h6>
                    </div>
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
