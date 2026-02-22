'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import WalletCard from '@/components/WalletCard';
import ServiceGrid from '@/components/ServiceGrid';
import Card from '@/components/Card';

export default function HomePage() {
  const [announcements] = useState([
    {
      id: 1,
      title: '🎯 Diskon 50% GEMA Food Hari Ini!',
      desc: 'Pesan makanan minimal Rp 50.000, semua gratis ongkir',
    },
    {
      id: 2,
      title: '🎁 Program Loyalitas Pelanggan Setia',
      desc: 'Setiap 10 pesanan, dapatkan voucher Rp 100.000',
    },
  ]);

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName="Budi Santoso" isLoading={false} />

      <main className="pb-24 max-w-md mx-auto">
        {/* Wallet Section */}
        <section className="px-4 py-6">
          <WalletCard balance={250000} isLoading={false} />
        </section>

        {/* Service Grid */}
        <section className="px-4 py-4">
          <h2 className="text-lg font-bold text-light-primary dark:text-dark-primary mb-4">Layanan Kami</h2>
          <ServiceGrid />
        </section>

        {/* Announcements */}
        <section className="px-4 py-6">
          <h2 className="text-lg font-bold text-light-primary dark:text-dark-primary mb-4">Promo & Berita</h2>
          <div className="space-y-3">
            {announcements.map((announce) => (
              <Card
                key={announce.id}
                className="border-l-4 border-emerald-500 cursor-pointer hover:shadow-light dark:hover:shadow-dark"
              >
                <p className="font-bold text-light-primary dark:text-dark-primary mb-1">{announce.title}</p>
                <p className="text-sm text-light-secondary dark:text-dark-secondary">{announce.desc}</p>
              </Card>
            ))}
          </div>
        </section>

        {/* Quick Links */}
        <section className="px-4 py-6">
          <h2 className="text-lg font-bold text-light-primary dark:text-dark-primary mb-4">Akses Cepat</h2>
          <div className="grid grid-cols-3 gap-3">
            {[
              { icon: '🛡️', label: 'Bantuan', href: '#' },
              { icon: '⭐', label: 'Rating', href: '#' },
              { icon: '📱', label: 'Unduh App', href: '#' },
            ].map((link, i) => (
              <Card key={i} className="text-center cursor-pointer hover:shadow-light dark:hover:shadow-dark p-4">
                <p className="text-3xl mb-2">{link.icon}</p>
                <p className="text-xs font-semibold text-light-primary dark:text-dark-primary">{link.label}</p>
              </Card>
            ))}
          </div>
        </section>

        {/* Marketing Banner */}
        <section className="px-4 py-6">
          <Card className="bg-gradient-to-r from-emerald-500 to-emerald-600 text-white p-6 rounded-2xl">
            <h3 className="text-xl font-bold mb-2">🚀 Bergabunglah sebagai Mitra!</h3>
            <p className="text-sm opacity-90 mb-4">
              Jadilah pedagang atau kurir GEMA dan dapatkan penghasilan tambahan.
            </p>
            <button className="w-full bg-white text-emerald-600 font-bold py-2 rounded-lg hover:bg-gray-100 transition-colors">
              Daftar Sekarang
            </button>
          </Card>
        </section>
      </main>

      <BottomNavigation activeTab="home" />
    </div>
  );
}
