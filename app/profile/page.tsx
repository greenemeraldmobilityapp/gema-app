'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import Button from '@/components/Button';
import Card from '@/components/Card';
import { useTheme } from '@/components/ThemeProvider';

export default function ProfilePage() {
  const { theme, toggleTheme } = useTheme();
  const [user] = useState({
    name: 'Budi Santoso',
    phone: '08123456789',
    email: 'budi@example.com',
    address: 'Jl. Raya Jepara, Kabupaten Jepara, Jawa Tengah',
    verified: true,
    rating: 4.8,
    totalOrders: 24,
  });

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName={user.name} walletBalance={250000} />

      <main className="pb-24 max-w-md mx-auto">
        {/* Profile Header */}
        <section className="px-4 py-8 border-b border-light-border dark:border-dark-border">
          <div className="flex items-start gap-4 mb-6">
            <div className="w-20 h-20 rounded-full bg-gradient-to-br from-[#50C878] to-[#2E8B57] flex items-center justify-center text-white text-3xl font-bold">
              {user.name.charAt(0)}
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1">
                <p className="text-xl font-bold text-light-primary dark:text-dark-primary">{user.name}</p>
                {user.verified && (
                  <svg className="w-5 h-5 text-[#50C878]" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                  </svg>
                )}
              </div>
              <p className="text-sm text-light-secondary dark:text-dark-secondary mb-2">{user.phone}</p>
              <div className="flex items-center gap-3">
                <span className="text-sm font-semibold text-yellow-500">⭐ {user.rating}</span>
                <span className="text-sm text-light-secondary dark:text-dark-secondary">({user.totalOrders} pesanan)</span>
              </div>
            </div>
          </div>

          <Button variant="primary" fullWidth>
            Edit Profil
          </Button>
        </section>

        {/* Menu Items */}
        <section className="px-4 py-4 space-y-2">
          {[
            { icon: '👤', label: 'Data Pribadi', href: '#' },
            { icon: '🏠', label: 'Alamat Pengiriman', href: '#' },
            { icon: '💳', label: 'Metode Pembayaran', href: '#' },
            { icon: '🎁', label: 'Promo & Voucher', href: '#' },
          ].map((item, i) => (
            <Card key={i} className="flex items-center gap-4 cursor-pointer hover:bg-light-secondary dark:hover:bg-dark-tertiary/50 p-4 transition-colors">
              <span className="text-2xl">{item.icon}</span>
              <div className="flex-1">
                <p className="font-semibold text-light-primary dark:text-dark-primary">{item.label}</p>
              </div>
              <svg className="w-5 h-5 text-light-tertiary dark:text-dark-secondary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </Card>
          ))}
        </section>

        {/* Settings Section */}
        <section className="px-4 py-6 border-t border-light-border dark:border-dark-border">
          <h2 className="font-bold text-light-primary dark:text-dark-primary mb-4">Pengaturan</h2>
          <div className="space-y-3">
            {/* Dark Mode Toggle */}
            <div className="flex items-center justify-between p-4 bg-light-secondary dark:bg-dark-tertiary rounded-lg">
              <div className="flex items-center gap-3">
                <span className="text-lg">{theme === 'dark' ? '🌙' : '☀️'}</span>
                <span className="font-semibold text-light-primary dark:text-dark-primary">Mode Gelap</span>
              </div>
              <button
                onClick={toggleTheme}
                className={`w-12 h-7 rounded-full transition-colors ${
                  theme === 'dark' ? 'bg-[#50C878]' : 'bg-light-tertiary'
                } relative`}
              >
                <div
                  className={`w-5 h-5 bg-light-primary dark:bg-dark-primary rounded-full absolute top-1 transition-all ${
                    theme === 'dark' ? 'right-1' : 'left-1'
                  }`}
                />
              </button>
            </div>

            {[
              { icon: '🔔', label: 'Notifikasi' },
              { icon: '🔒', label: 'Keamanan' },
              { icon: 'ℹ️', label: 'Tentang Aplikasi' },
            ].map((item, i) => (
              <div key={i} className="flex items-center justify-between p-4 bg-light-secondary dark:bg-dark-tertiary/50 rounded-lg cursor-pointer hover:bg-light-tertiary dark:hover:bg-dark-tertiary">
                <div className="flex items-center gap-3">
                  <span className="text-lg">{item.icon}</span>
                  <span className="font-semibold text-light-primary dark:text-dark-primary">{item.label}</span>
                </div>
                <svg className="w-5 h-5 text-light-tertiary dark:text-dark-secondary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                </svg>
              </div>
            ))}
          </div>
        </section>

        {/* Logout Button */}
        <section className="px-4 py-6">
          <Button variant="danger" fullWidth>
            Logout
          </Button>
        </section>
      </main>

      <BottomNavigation activeTab="profile" />
    </div>
  );
}
