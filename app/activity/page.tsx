'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import Button from '@/components/Button';
import Card from '@/components/Card';

export default function ActivityPage() {
  const [orders] = useState([
    {
      id: '1001',
      type: 'Food',
      merchant: 'Warung Soto Ayam Bu Retno',
      status: 'delivered',
      date: '20 Feb 2026',
      time: '12:30',
      total: 65000,
      items: ['Soto Ayam x2', 'Es Jeruk x1'],
    },
    {
      id: '1002',
      type: 'Send',
      merchant: 'Pengiriman Paket',
      status: 'otw',
      date: '22 Feb 2026',
      time: '14:45',
      total: 25000,
      items: ['1 Paket'],
    },
  ]);

  const statusConfig = {
    delivered: { label: 'Selesai', color: 'bg-purple-100 text-purple-800' },
    otw: { label: 'Dalam Perjalanan', color: 'bg-[#50C878]/10 text-[#50C878]' },
    pending: { label: 'Menunggu', color: 'bg-[#FFCC00]/10 text-yellow-800' },
    cancelled: { label: 'Dibatalkan', color: 'bg-red-100 text-red-800' },
  };

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName="Budi Santoso" walletBalance={250000} />

      <main className="pb-24 max-w-md mx-auto">
        <section className="px-4 py-6">
          <h1 className="text-2xl font-bold text-light-primary dark:text-dark-primary mb-6">Aktivitas Saya</h1>

          {/* Tabs */}
          <div className="flex gap-2 mb-6 border-b border-light-border dark:border-dark-border">
            <button className="pb-3 px-4 font-semibold text-[#50C878] border-b-2 border-[#50C878]">
              Aktif
            </button>
            <button className="pb-3 px-4 font-semibold text-light-secondary dark:text-dark-secondary hover:text-light-primary dark:hover:text-dark-primary">
              Selesai
            </button>
            <button className="pb-3 px-4 font-semibold text-light-secondary dark:text-dark-secondary hover:text-light-primary dark:hover:text-dark-primary">
              Dibatalkan
            </button>
          </div>

          {/* Orders List */}
          <div className="space-y-4">
            {orders.map((order) => (
              <Card key={order.id} className="cursor-pointer hover:shadow-light dark:hover:shadow-dark">
                <div className="flex justify-between items-start mb-3">
                  <div>
                    <p className="font-bold text-light-primary dark:text-dark-primary text-base">{order.merchant}</p>
                    <p className="text-sm text-light-secondary dark:text-dark-secondary">{order.type}</p>
                  </div>
                  <span
                    className={`text-xs font-semibold px-3 py-1 rounded-full ${
                      statusConfig[order.status as keyof typeof statusConfig].color
                    }`}
                  >
                    {statusConfig[order.status as keyof typeof statusConfig].label}
                  </span>
                </div>

                <div className="mb-3 p-2 bg-light-secondary dark:bg-dark-tertiary rounded-lg">
                  {order.items.map((item, i) => (
                    <p key={i} className="text-sm text-light-secondary dark:text-dark-secondary">
                      • {item}
                    </p>
                  ))}
                </div>

                <div className="flex justify-between items-center">
                  <div>
                    <p className="text-xs text-light-secondary dark:text-dark-secondary">
                      {order.date} • {order.time}
                    </p>
                    <p className="font-semibold text-light-primary dark:text-dark-primary mt-1">Rp {order.total.toLocaleString('id-ID')}</p>
                  </div>
                  <svg className="w-5 h-5 text-light-tertiary dark:text-dark-secondary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                  </svg>
                </div>

                {order.status === 'otw' && (
                  <Button variant="primary" size="sm" fullWidth className="mt-3 text-sm">
                    Lacak Pesanan
                  </Button>
                )}
              </Card>
            ))}
          </div>
        </section>
      </main>

      <BottomNavigation activeTab="activity" />
    </div>
  );
}
