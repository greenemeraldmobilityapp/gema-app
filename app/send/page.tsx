'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import Button from '@/components/Button';
import Card from '@/components/Card';

export default function SendPage() {
  const [selectedType, setSelectedType] = useState<'sameday' | 'regular'>('sameday');

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName="Budi Santoso" walletBalance={250000} />

      <main className="pb-24 max-w-md mx-auto">
        <section className="px-4 py-6">
          <h1 className="text-2xl font-bold text-light-primary dark:text-dark-primary mb-6">GEMA Send</h1>

          {/* Delivery Type Selection */}
          <div className="grid grid-cols-2 gap-4 mb-6">
            {[
              { id: 'sameday', label: 'Same Day', desc: 'Hari ini', icon: '⚡' },
              { id: 'regular', label: 'Regular', desc: 'Besok', icon: '📦' },
            ].map((type) => (
              <Card
                key={type.id}
                onClick={() => setSelectedType(type.id as 'sameday' | 'regular')}
                className={`cursor-pointer p-4 text-center ${
                  selectedType === type.id
                    ? 'bg-[#50C878] text-white border-2 border-[#50C878]'
                    : 'border-2 border-light-border dark:border-dark-border'
                }`}
              >
                <p className="text-3xl mb-2">{type.icon}</p>
                <p className="font-bold">{type.label}</p>
                <p className="text-xs opacity-75">{type.desc}</p>
              </Card>
            ))}
          </div>

          {/* Pickup Form */}
          <div className="space-y-4 mb-6">
            <h2 className="font-bold text-light-primary dark:text-dark-primary">Lokasi Pengiriman</h2>

            {/* Pickup Location */}
            <div>
              <label className="block text-sm font-semibold text-light-primary dark:text-dark-primary mb-2">
                Tempat Penjemput
              </label>
              <input
                type="text"
                placeholder="Cari toko atau lokasi"
                className="input-field w-full"
              />
            </div>

            {/* Delivery Location */}
            <div>
              <label className="block text-sm font-semibold text-light-primary dark:text-dark-primary mb-2">
                Tempat Tujuan
              </label>
              <input
                type="text"
                placeholder="Alamat rumah atau kantor"
                className="input-field w-full"
              />
            </div>

            {/* Package Details */}
            <div>
              <label className="block text-sm font-semibold text-light-primary dark:text-dark-primary mb-2">
                Deskripsi Paket
              </label>
              <textarea
                placeholder="Apa yang dikirim? (opsional)"
                className="input-field w-full resize-none"
                rows={3}
              />
            </div>
          </div>

          {/* Estimated Price */}
          <Card className="bg-emerald-500/10 border-2 border-emerald-500 mb-6 dark:border-emerald-400">
            <div className="flex justify-between items-center mb-3">
              <span className="font-semibold text-light-primary dark:text-dark-primary">Estimasi Harga</span>
              <span className="text-2xl font-bold text-[#50C878]">Rp 15.000</span>
            </div>
            <div className="space-y-2 text-sm text-light-secondary dark:text-dark-secondary">
              <div className="flex justify-between">
                <span>Pengiriman</span>
                <span>Rp 15.000</span>
              </div>
              <div className="flex justify-between">
                <span>Biaya Aplikasi</span>
                <span>Rp 2.000</span>
              </div>
              <div className="pt-2 border-t border-light-border dark:border-dark-border flex justify-between font-bold text-light-primary dark:text-dark-primary">
                <span>Total</span>
                <span>Rp 17.000</span>
              </div>
            </div>
          </Card>

          {/* CTA Buttons */}
          <div className="space-y-3">
            <Button variant="primary" fullWidth size="lg">
              Pesan Sekarang
            </Button>
            <Button variant="secondary" fullWidth size="lg">
              Lihat Harga Berbeda
            </Button>
          </div>
        </section>
      </main>

      <BottomNavigation activeTab="home" />
    </div>
  );
}
