'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import Button from '@/components/Button';
import Card from '@/components/Card';

export default function MarketplacePage() {
  const [products] = useState([
    {
      id: 1,
      name: 'Mebel Kursi Jati Ukir Asli Jepara',
      store: 'Toko Mebel Sinar Karya',
      price: 2500000,
      rating: 4.9,
      reviews: 234,
      image: '🪑',
      sold: 156,
    },
    {
      id: 2,
      name: 'Batik Tulis Motif Jepara Asli',
      store: 'Batik Nusa Jepara',
      price: 285000,
      rating: 4.8,
      reviews: 512,
      image: '👕',
      sold: 892,
    },
    {
      id: 3,
      name: 'Tas Tangan Ukiran Kayu Jepara',
      store: 'Kerajinan Tangan Jepara',
      price: 450000,
      rating: 4.7,
      reviews: 189,
      image: '👜',
      sold: 67,
    },
  ]);

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0,
    }).format(value);
  };

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName="Budi Santoso" walletBalance={250000} />

      <main className="pb-24 max-w-md mx-auto">
        <section className="px-4 py-6">
          <h1 className="text-2xl font-bold text-light-primary dark:text-dark-primary mb-4">Marketplace</h1>

          {/* Search & Filter */}
          <div className="mb-6 flex gap-2">
            <input
              type="text"
              placeholder="Cari produk..."
              className="input-field flex-1"
            />
            <button className="bg-[#50C878] text-white px-4 py-2.5 rounded-lg font-semibold hover:bg-[#2E8B57] transition-colors">
              🔍
            </button>
          </div>

          {/* Categories */}
          <div className="mb-6 flex gap-2 overflow-x-auto pb-2">
            {['Semua', 'Mebel', 'Fashion', 'Kerajinan', 'Elektronik'].map((cat) => (
              <button
                key={cat}
                className="px-4 py-2 rounded-full bg-light-secondary dark:bg-dark-tertiary text-light-secondary dark:text-dark-secondary hover:bg-[#50C878] hover:text-white transition-colors whitespace-nowrap text-sm font-semibold"
              >
                {cat}
              </button>
            ))}
          </div>

          {/* Products List */}
          <div className="space-y-4">
            {products.map((product) => (
              <Card key={product.id} className="overflow-hidden hover:shadow-light dark:hover:shadow-dark cursor-pointer">
                <div className="grid grid-cols-3 gap-3 mb-3">
                  <div className="col-span-1 w-full h-28 bg-light-secondary dark:bg-dark-tertiary rounded-lg flex items-center justify-center text-6xl">
                    {product.image}
                  </div>
                  <div className="col-span-2 flex flex-col justify-between">
                    <div>
                      <p className="font-bold text-light-primary dark:text-dark-primary line-clamp-2 text-sm mb-1">
                        {product.name}
                      </p>
                      <p className="text-xs text-light-secondary dark:text-dark-secondary">{product.store}</p>
                    </div>
                    <div>
                      <p className="text-lg font-bold text-[#50C878]">{formatCurrency(product.price)}</p>
                      <div className="flex items-center gap-1 mt-1">
                        <span className="text-xs">
                          <span className="font-semibold text-yellow-500">⭐ {product.rating}</span>
                          <span className="text-gray-500 dark:text-gray-400"> ({product.reviews})</span>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="pt-3 border-t border-gray-200 dark:border-gray-700 flex justify-between items-center text-xs text-gray-600 dark:text-gray-400 mb-3">
                  <span>Terjual {product.sold}</span>
                  <Button variant="primary" size="sm">
                    Beli
                  </Button>
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
