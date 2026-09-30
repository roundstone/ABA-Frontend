'use client';

import Breadcrumb from '@/components/ui/Breadcrumb';
import Receipt from '@/components/Receipt';
import { OrderService, Order } from '@/services/mock/order.service';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useParams } from 'next/navigation';

export default function OrderSuccessPage() {
  const params = useParams();
  const orderId = params?.orderId as string;
  const [order, setOrder] = useState<Order | null>(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (orderId) {
      const fetchedOrder = OrderService.getOrderById(orderId);
      if (fetchedOrder) {
        setOrder(fetchedOrder);
      }
    }
  }, [orderId]);

  if (!mounted) return null;

  if (!order) {
    return (
      <>
        <Breadcrumb title="Order Success" items={[{ label: 'Home', url: '/' }, { label: 'Order Success' }]} />
        <section className="section-b-space">
          <div className="container text-center">
            <h3>Order not found.</h3>
            <p className="mt-2 text-muted">We could not find an order matching that ID.</p>
            <Link href="/" className="btn btn-solid mt-4">Return Home</Link>
          </div>
        </section>
      </>
    );
  }

  return (
    <>
      <Breadcrumb title="Order Success" items={[{ label: 'Home', url: '/' }, { label: 'Order Success' }]} />
      <Receipt order={order} />
    </>
  );
}
