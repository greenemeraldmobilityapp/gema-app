'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

interface BottomNavigationProps {
  activeTab?: string;
}

const navItems = [
  {
    id: 'home',
    label: 'Beranda',
    icon: 'home',
    href: '/',
  },
  {
    id: 'activity',
    label: 'Aktivitas',
    icon: 'activity',
    href: '/activity',
  },
  {
    id: 'chat',
    label: 'Chat',
    icon: 'chat',
    href: '/chat',
  },
  {
    id: 'profile',
    label: 'Profil',
    icon: 'profile',
    href: '/profile',
  },
];

const getIcon = (iconName: string, isActive: boolean) => {
  const className = `w-6 h-6 ${isActive ? 'text-[#50C878]' : 'text-gray-500 dark:text-gray-400'}`;
  switch (iconName) {
    case 'home':
      return (
        <svg className={className} fill={isActive ? 'currentColor' : 'none'} stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 12l2-3m0 0l7-4 7 4m-7-4v12m0 0l-7-4m7 4l7-4" />
        </svg>
      );
    case 'activity':
      return (
        <svg className={className} fill={isActive ? 'currentColor' : 'none'} stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
        </svg>
      );
    case 'chat':
      return (
        <svg className={className} fill={isActive ? 'currentColor' : 'none'} stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
        </svg>
      );
    case 'profile':
      return (
        <svg className={className} fill={isActive ? 'currentColor' : 'none'} stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
        </svg>
      );
    default:
      return null;
  }
};

export default function BottomNavigation({ activeTab }: BottomNavigationProps) {
  const pathname = usePathname();
  const currentTab = activeTab || (pathname === '/' ? 'home' : pathname.split('/')[1]) || 'home';

  return (
    <nav className="fixed bottom-0 left-0 right-0 max-w-md mx-auto bg-white dark:bg-[#1e1e1e] border-t border-gray-200 dark:border-gray-700 shadow-soft-lg">
      <div className="flex items-center justify-around h-20">
        {navItems.map((item) => {
          const isActive = currentTab === item.id;
          return (
            <Link
              key={item.id}
              href={item.href}
              className={`flex flex-col items-center justify-center w-full h-full transition-colors duration-200 ${
                isActive
                  ? 'text-[#50C878]'
                  : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200'
              }`}
            >
              {getIcon(item.icon, isActive)}
              <span className="text-xs font-semibold mt-1">{item.label}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
