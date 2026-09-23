import Breadcrumb from '@/components/ui/Breadcrumb';
import Link from 'next/link';
import Image from 'next/image';
import { PRODUCTS } from '@/data/products';

export const metadata = {
  title: 'Wishlist - Multikart',
  description: 'Your wishlist',
};

export default function WishlistPage() {
  const wishlistItems = PRODUCTS.slice(0, 3);

  return (
    <>
      <Breadcrumb
        title="Wishlist"
        items={[{ label: 'Home', url: '/' }, { label: 'Wishlist' }]}
      />
      <section className="wishlist-section section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-sm-12 table-responsive-xs">
              <table className="table cart-table">
                <thead>
                  <tr className="table-head">
                    <th scope="col">image</th>
                    <th scope="col">product name</th>
                    <th scope="col">price</th>
                    <th scope="col">availability</th>
                    <th scope="col">action</th>
                  </tr>
                </thead>
                <tbody>
                  {wishlistItems.map(item => (
                    <tr key={item.id}>
                      <td>
                        <Link href={`/product/${item.id}`}>
                          <Image src={item.image} alt={item.name} width={100} height={150} />
                        </Link>
                      </td>
                      <td>
                        <Link href={`/product/${item.id}`}>{item.name}</Link>
                        <div className="mobile-cart-content row">
                          <div className="col">
                            <p>in stock</p>
                          </div>
                          <div className="col">
                            <h2 className="td-color">${item.price.toFixed(2)}</h2>
                          </div>
                          <div className="col">
                            <h2 className="td-color">
                              <a href="#" className="icon mr-1"><i className="ti-close"></i></a>
                              <a href="#" className="cart"><i className="ti-shopping-cart"></i></a>
                            </h2>
                          </div>
                        </div>
                      </td>
                      <td>
                        <h2>${item.price.toFixed(2)}</h2>
                      </td>
                      <td>
                        <p>in stock</p>
                      </td>
                      <td>
                        <a href="#" className="icon mr-3"><i className="ti-close"></i></a>
                        <a href="#" className="cart"><i className="ti-shopping-cart"></i></a>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
          <div className="row wishlist-buttons">
            <div className="col-12">
              <Link href="/shop" className="btn btn-solid">continue shopping</Link>
              <Link href="/checkout" className="btn btn-solid">check out</Link>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
