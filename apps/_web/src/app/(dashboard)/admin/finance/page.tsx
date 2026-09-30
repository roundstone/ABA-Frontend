'use client';

import { CommissionService } from '@/services/mock/commission.service';
import { OrderService } from '@/services/mock/order.service';
import { useState, useEffect } from 'react';
import Link from 'next/link';
import { DollarSign, CheckSquare, Clock, Briefcase, TrendingDown, CreditCard, Activity, Percent } from 'lucide-react';
import MetricCard from '@/components/admin/dashboard/MetricCard';

export default function AdminFinancePage() {
  const [mounted, setMounted] = useState(false);
  const [loading, setLoading] = useState(true);

  const [metrics, setMetrics] = useState({
    totalRevenue: 0,
    totalCommissionsPaid: 0,
    totalCommissionsPending: 0,
    netRevenue: 0,
    procurementCosts: 0,
    operatingExpenses: 0,
    grossProfit: 0,
    grossMargin: 0,
  });

  useEffect(() => {
    setMounted(true);

    const fetchData = async () => {
      setLoading(true);
      // Simulate network delay for API readiness
      await new Promise(resolve => setTimeout(resolve, 800));

      const orders = OrderService.getOrders();
      const ledger = CommissionService.getLedger();

      // Only count non-cancelled orders for revenue
      const validOrders = orders.filter(o => o.status !== 'CANCELLED');
      const totalRevenue = validOrders.reduce((sum, order) => sum + order.total, 0);

      const paidCommissions = ledger.filter(entry => entry.status === 'PAID');
      const pendingCommissions = ledger.filter(entry => entry.status === 'PENDING' || entry.status === 'APPROVED');

      const totalCommissionsPaid = paidCommissions.reduce((sum, entry) => sum + entry.amount, 0);
      const totalCommissionsPending = pendingCommissions.reduce((sum, entry) => sum + entry.amount, 0);

      const netRevenue = totalRevenue - totalCommissionsPaid;

      // Simulated ERP Financial Metrics
      const procurementCosts = totalRevenue * 0.35; // Mock 35% COGS
      const operatingExpenses = totalRevenue * 0.15; // Mock 15% OPEX
      const grossProfit = netRevenue - procurementCosts - operatingExpenses;
      const grossMargin = totalRevenue > 0 ? (grossProfit / totalRevenue) * 100 : 0;

      setMetrics({
        totalRevenue,
        totalCommissionsPaid,
        totalCommissionsPending,
        netRevenue,
        procurementCosts,
        operatingExpenses,
        grossProfit,
        grossMargin,
      });
      setLoading(false);
    };

    fetchData();
  }, []);

  if (!mounted) return null;

  return (
    <div className="container-fluid">
      <div className="page-header">
        <div className="row">
          <div className="col-lg-6">
            <div className="page-header-left">
              <h3>Finance Overview
                <small>ABA ERP Admin panel</small>
              </h3>
            </div>
          </div>
          <div className="col-lg-6">
            <ol className="breadcrumb pull-right">
              <li className="breadcrumb-item">
                <Link href="/admin"><i data-feather="home"></i></Link>
              </li>
              <li className="breadcrumb-item">Finance</li>
              <li className="breadcrumb-item active">Overview</li>
            </ol>
          </div>
        </div>
      </div>

      <div className="row">
        {/* Core Revenue Metrics */}
        <MetricCard
          title="Total Revenue"
          value={loading ? '...' : metrics.totalRevenue.toFixed(2)}
          Icon={DollarSign}
          colorClass="primary"
          prefix="$"
        />
        <MetricCard
          title="Commissions Paid"
          value={loading ? '...' : metrics.totalCommissionsPaid.toFixed(2)}
          Icon={CheckSquare}
          colorClass="secondary"
          prefix="$"
        />
        <MetricCard
          title="Commissions Pending"
          value={loading ? '...' : metrics.totalCommissionsPending.toFixed(2)}
          Icon={Clock}
          colorClass="warning"
          prefix="$"
        />
        <MetricCard
          title="Net Revenue"
          value={loading ? '...' : metrics.netRevenue.toFixed(2)}
          Icon={Briefcase}
          colorClass="success"
          prefix="$"
        />

        {/* Extended ERP Metrics */}
        <MetricCard
          title="Procurement Costs"
          value={loading ? '...' : metrics.procurementCosts.toFixed(2)}
          Icon={TrendingDown}
          colorClass="danger"
          prefix="$"
          subtitle="Materials & Goods"
        />
        <MetricCard
          title="Operating Expenses"
          value={loading ? '...' : metrics.operatingExpenses.toFixed(2)}
          Icon={CreditCard}
          colorClass="danger"
          prefix="$"
          subtitle="Logistics & Admin"
        />
        <MetricCard
          title="Gross Profit"
          value={loading ? '...' : metrics.grossProfit.toFixed(2)}
          Icon={Activity}
          colorClass="info"
          prefix="$"
        />
        <MetricCard
          title="Gross Margin"
          value={loading ? '...' : metrics.grossMargin.toFixed(1)}
          Icon={Percent}
          colorClass="primary"
          suffix="%"
        />
      </div>
    </div>
  );
}
