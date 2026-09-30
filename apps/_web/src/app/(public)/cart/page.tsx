import Breadcrumb from '@/components/ui/Breadcrumb';
import Image from 'next/image';
import Link from 'next/link';

export const metadata = {
  title: 'Cart - Multikart',
  description: 'Your shopping cart',
};

export default function CartPage() {
  return (
    <>
      <Breadcrumb
        title="Cart"
        items={[{ label: 'Home', url: '/' }, { label: 'Cart' }]}
      />
      
      <section className="cart-section section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-sm-12">
              <div className="cart_table">
                <table className="table cart-table table-responsive-xs">
                  <thead>
                    <tr className="table-head">
                      <th scope="col">image</th>
                      <th scope="col">product name</th>
                      <th scope="col">price</th>
                      <th scope="col">quantity</th>
                      <th scope="col">action</th>
                      <th scope="col">total</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <Link href="/product/1">
                          <Image src="/images/bags/product/1.jpg" alt="product" width={80} height={100} />
                        </Link>
                      </td>
                      <td>
                        <Link href="/product/1">Wander Pack Heaven Backpack</Link>
                        <div className="mobile-cart-content row">
                          <div className="col">
                            <div className="qty-box">
                              <div className="input-group">
                                <input type="text" name="quantity" className="form-control input-number" defaultValue="1" />
                              </div>
                            </div>
                          </div>
                          <div className="col">
                            <h2 className="td-color">$20.39</h2>
                          </div>
                          <div className="col">
                            <h2 className="td-color">
                              <a href="#" className="icon"><i className="ri-close-line"></i></a>
                            </h2>
                          </div>
                        </div>
                      </td>
                      <td>
                        <h2>$20.39</h2>
                      </td>
                      <td>
                        <div className="qty-box">
                          <div className="input-group">
                            <input type="number" name="quantity" className="form-control input-number" defaultValue="1" />
                          </div>
                        </div>
                      </td>
                      <td>
                        <a href="#" className="icon"><i className="ri-close-line"></i></a>
                      </td>
                      <td>
                        <h2 className="td-color">$20.39</h2>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <div className="table-responsive-md">
                  <table className="table cart-table ">
                    <tfoot>
                      <tr>
                        <td>total price :</td>
                        <td>
                          <h2>$20.39</h2>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
            </div>
          </div>
          <div className="row cart-buttons">
            <div className="col-6">
              <Link href="/shop" className="btn btn-solid">continue shopping</Link>
            </div>
            <div className="col-6">
              <Link href="/checkout" className="btn btn-solid">check out</Link>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
