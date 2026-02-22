'use client';

import Link from 'next/link';

const services = [
  {
    id: 'food',
    name: 'GEMA Food',
    description: 'Belanja & pesan makanan',
    icon: '🍽️',
    color: 'from-orange-400 to-orange-600',
    href: '/food',
  },
  {
    id: 'send',
    name: 'GEMA Send',
    description: 'Pengiriman cepat',
    icon: '📦',
    color: 'from-blue-400 to-blue-600',
    href: '/send',
  },
  {
    id: 'service',
    name: 'GEMA Service',
    description: 'Pesan jasa profesional',
    icon: '🔧',
    color: 'from-purple-400 to-purple-600',
    href: '/service',
  },
  {
    id: 'marketplace',
    name: 'Marketplace',
    description: 'Belanja berbagai produk',
    icon: '🛍️',
    color: 'from-pink-400 to-pink-600',
    href: '/marketplace',
  },
];

export default function ServiceGrid() {
  return (
    <div className="grid grid-cols-2 gap-4">
      {services.map((service) => (
        <Link
          key={service.id}
          href={service.href}
          className="group relative overflow-hidden rounded-xl h-40 shadow-soft transition-all duration-300 hover:shadow-soft-lg hover:scale-105"
        >
          {/* Background Gradient */}
          <div className={`absolute inset-0 bg-gradient-to-br ${service.color} opacity-90 group-hover:opacity-100 transition-opacity`} />

          {/* Content */}
          <div className="relative h-full p-4 flex flex-col justify-between text-white">
            <div>
              <p className="text-4xl mb-2">{service.icon}</p>
              <p className="font-bold text-base">{service.name}</p>
            </div>
            <p className="text-xs opacity-90">{service.description}</p>
          </div>

          {/* Hover Arrow */}
          <div className="absolute bottom-2 right-2 transform translate-x-8 group-hover:translate-x-0 opacity-0 group-hover:opacity-100 transition-all duration-300">
            <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
            </svg>
          </div>
        </Link>
      ))}
    </div>
  );
}
