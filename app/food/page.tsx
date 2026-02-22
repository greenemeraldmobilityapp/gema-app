'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import Card from '@/components/Card';

export default function FoodPage() {
  const [stores] = useState([
    {
      id: 1,
      name: 'Warung Soto Ayam Bu Retno',
      rating: 4.8,
      reviews: 256,
      distance: '0.8 km',
      delivery: '15-20 min',
      category: 'Soto & Nasi',
      image: '🍲',
    },
    {
      id: 2,
      name: 'Bakso Mali Legendaris',
      rating: 4.9,
      reviews: 512,
      distance: '1.2 km',
      delivery: '20-25 min',
      category: 'Bakso',
      image: '🍜',
    },
    {
      id: 3,
      name: 'Toko Kue Tradisional',
      rating: 4.7,
      reviews: 189,
      distance: '0.5 km',
      delivery: '10-15 min',
      category: 'Kue & Pastry',
      image: '🍰',
    },
  ]);

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName="Budi Santoso" walletBalance={250000} />

      <main className="pb-24 max-w-md mx-auto">
        <section className="px-4 py-6">
          <h1 className="text-2xl font-bold text-light-primary dark:text-dark-primary mb-4">GEMA Food</h1>

          {/* Search & Filter */}
          <div className="mb-6 flex gap-2">
            <input
              type="text"
              placeholder="Cari makanan, toko..."
              className="input-field flex-1"
            />
            <button className="bg-[#50C878] text-white px-4 py-2.5 rounded-lg font-semibold hover:bg-[#2E8B57] transition-colors flex items-center gap-2">
              <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M10 18a8 8 0 100-16 8 8 0 000 16zM9 9a1 1 0 100-2 1 1 0 000 2z" />
              </svg>
            </button>
          </div>

          {/* Categories */}
          <div className="mb-6 flex gap-2 overflow-x-auto pb-2">
            {['Semua', 'Nasi', 'Bakso', 'Kue', 'Minuman'].map((cat) => (
              <button
                key={cat}
                className="px-4 py-2 rounded-full bg-light-secondary dark:bg-dark-tertiary text-light-secondary dark:text-dark-secondary hover:bg-[#50C878] hover:text-white transition-colors whitespace-nowrap text-sm font-semibold"
              >
                {cat}
              </button>
            ))}
          </div>

          {/* Stores List */}
          <div className="space-y-3">
            {stores.map((store) => (
              <Card key={store.id} className="cursor-pointer hover:shadow-light dark:hover:shadow-dark">
                <div className="flex gap-4">
                  <div className="w-20 h-20 rounded-lg bg-light-secondary dark:bg-dark-tertiary flex items-center justify-center text-4xl flex-shrink-0">
                    {store.image}
                  </div>
                  <div className="flex-1">
                    <p className="font-bold text-light-primary dark:text-dark-primary">{store.name}</p>
                    <p className="text-xs text-light-secondary dark:text-dark-secondary mt-1">{store.category}</p>
                    <div className="flex items-center gap-4 mt-2">
                      <span className="text-sm">
                        <span className="font-semibold text-yellow-500">⭐ {store.rating}</span>
                        <span className="text-light-secondary dark:text-dark-secondary"> ({store.reviews})</span>
                      </span>
                    </div>
                  </div>
                </div>
                <div className="mt-3 pt-3 border-t border-light-border dark:border-dark-border flex justify-between text-xs text-light-secondary dark:text-dark-secondary">
                  <span>📍 {store.distance}</span>
                  <span>⏱️ {store.delivery}</span>
                </div>
              </Card>
            ))}
          </div>
        </section>
      </main>

      <BottomNavigation activeTab="home" />
    </div>
  );
}
