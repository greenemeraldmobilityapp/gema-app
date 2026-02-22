'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import Button from '@/components/Button';
import Card from '@/components/Card';

export default function ServicePage() {
  const [services] = useState([
    {
      id: 1,
      name: 'Ukir Kayu Jepara',
      provider: 'Pak Tukang Ukir',
      rating: 4.9,
      reviews: 142,
      price: 'Mulai Rp 250.000',
      availability: 'Tersedia hari ini',
      icon: '🪵',
    },
    {
      id: 2,
      name: 'Servis AC & Kulkas',
      provider: 'Bengkel AC Jaya',
      rating: 4.7,
      reviews: 98,
      price: 'Mulai Rp 150.000',
      availability: 'Tersedia hari ini',
      icon: '❄️',
    },
    {
      id: 3,
      name: 'Pindahan & Angkut',
      provider: 'Tim Angkut Professional',
      rating: 4.8,
      reviews: 167,
      price: 'Mulai Rp 500.000',
      availability: 'Tersedia besok',
      icon: '📦',
    },
    {
      id: 4,
      name: 'Servis Mebel',
      provider: 'Workshop Furniture',
      rating: 4.6,
      reviews: 76,
      price: 'Mulai Rp 300.000',
      availability: 'Tersedia 2 hari',
      icon: '🪑',
    },
  ]);

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName="Budi Santoso" walletBalance={250000} />

      <main className="pb-24 max-w-md mx-auto">
        <section className="px-4 py-6">
          <h1 className="text-2xl font-bold text-light-primary dark:text-dark-primary mb-4">GEMA Service</h1>

          {/* Search */}
          <div className="mb-6 flex gap-2">
            <input
              type="text"
              placeholder="Cari jasa..."
              className="input-field flex-1"
            />
            <button className="bg-[#50C878] text-white px-4 py-2.5 rounded-lg font-semibold hover:bg-[#2E8B57] transition-colors">
              🔍
            </button>
          </div>

          {/* Categories */}
          <div className="mb-6 flex gap-2 overflow-x-auto pb-2">
            {['Semua', 'Ukir', 'Servis', 'Angkut', 'Mebel'].map((cat) => (
              <button
                key={cat}
                className="px-4 py-2 rounded-full bg-light-secondary dark:bg-dark-tertiary text-light-secondary dark:text-dark-secondary hover:bg-[#50C878] hover:text-white transition-colors whitespace-nowrap text-sm font-semibold"
              >
                {cat}
              </button>
            ))}
          </div>

          {/* Services List */}
          <div className="space-y-4">
            {services.map((service) => (
              <Card key={service.id} className="cursor-pointer hover:shadow-light dark:hover:shadow-dark">
                <div className="flex gap-4 mb-3">
                  <div className="w-16 h-16 rounded-lg bg-light-secondary dark:bg-dark-tertiary flex items-center justify-center text-3xl flex-shrink-0">
                    {service.icon}
                  </div>
                  <div className="flex-1">
                    <p className="font-bold text-light-primary dark:text-dark-primary text-base">{service.name}</p>
                    <p className="text-sm text-light-secondary dark:text-dark-secondary">{service.provider}</p>
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-sm">
                        <span className="font-semibold text-yellow-500">⭐ {service.rating}</span>
                        <span className="text-light-secondary dark:text-dark-secondary"> ({service.reviews})</span>
                      </span>
                    </div>
                  </div>
                </div>

                <div className="mb-3 pt-3 border-t border-gray-200 dark:border-gray-700">
                  <p className="text-sm font-semibold text-[#50C878] mb-1">{service.price}</p>
                  <p className="text-xs text-gray-600 dark:text-gray-400">📅 {service.availability}</p>
                </div>

                <Button variant="primary" fullWidth size="sm">
                  Pesan Jasa
                </Button>
              </Card>
            ))}
          </div>
        </section>
      </main>

      <BottomNavigation activeTab="home" />
    </div>
  );
}
