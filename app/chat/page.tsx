'use client';

import { useState } from 'react';
import Header from '@/components/Header';
import BottomNavigation from '@/components/BottomNavigation';
import Card from '@/components/Card';

export default function ChatPage() {
  const [chats] = useState([
    {
      id: 1,
      name: 'Budi Wijaya (Driver)',
      message: 'Saya sudah sampai di toko, tunggu sebentar ya',
      time: '2 menit lalu',
      unread: 1,
      avatar: '🚗',
    },
    {
      id: 2,
      name: 'Warung Soto Ayam Bu Retno',
      message: 'Pesanan Anda sedang disiapkan',
      time: '15 menit lalu',
      unread: 0,
      avatar: '🍲',
    },
    {
      id: 3,
      name: 'Customer Service GEMA',
      message: 'Terima kasih atas laporan Anda',
      time: '1 jam lalu',
      unread: 0,
      avatar: '💬',
    },
  ]);

  return (
    <div className="min-h-screen bg-light-primary dark:bg-dark-primary">
      <Header userName="Budi Santoso" walletBalance={250000} />

      <main className="pb-24 max-w-md mx-auto">
        <section className="px-4 py-6">
          <h1 className="text-2xl font-bold text-light-primary dark:text-dark-primary mb-4">Chat</h1>

          {/* Search */}
          <div className="mb-6">
            <input
              type="text"
              placeholder="Cari chat..."
              className="input-field w-full"
            />
          </div>

          {/* Chat List */}
          <div className="space-y-2">
            {chats.map((chat) => (
              <Card key={chat.id} className="flex items-center gap-4 cursor-pointer hover:bg-light-secondary dark:hover:bg-dark-tertiary/50 p-4 transition-colors">
                <div className="w-12 h-12 rounded-full bg-light-secondary dark:bg-dark-tertiary flex items-center justify-center text-xl flex-shrink-0">
                  {chat.avatar}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex justify-between items-start mb-1">
                    <p className="font-semibold text-light-primary dark:text-dark-primary truncate">{chat.name}</p>
                    <span className="text-xs text-light-secondary dark:text-dark-secondary ml-2 flex-shrink-0">{chat.time}</span>
                  </div>
                  <p className="text-sm text-light-secondary dark:text-dark-secondary truncate">{chat.message}</p>
                </div>
                {chat.unread > 0 && (
                  <div className="w-5 h-5 rounded-full bg-[#50C878] text-white text-xs flex items-center justify-center font-bold flex-shrink-0">
                    {chat.unread}
                  </div>
                )}
              </Card>
            ))}
          </div>
        </section>
      </main>

      <BottomNavigation activeTab="chat" />
    </div>
  );
}
