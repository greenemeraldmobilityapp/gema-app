'use client';

import { useTheme } from './ThemeProvider';
import { useState } from 'react';

interface HeaderProps {
  userName: string;
  walletBalance?: number;
  isLoading?: boolean;
}

export default function Header({ userName, isLoading }: HeaderProps) {
  const { theme, toggleTheme } = useTheme();
  const [showMenu, setShowMenu] = useState(false);

  return (
    <header className="sticky top-0 z-40 bg-white dark:bg-dark-secondary border-b border-light-border dark:border-dark-border shadow-light dark:shadow-dark">
      <div className="max-w-md mx-auto px-4 py-4 flex items-center justify-between">
        {/* Logo & User Info */}
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#50C878] to-[#2E8B57] flex items-center justify-center text-white font-bold text-lg shadow-light dark:shadow-dark">
            G
          </div>
          <div>
            <p className="text-sm font-semibold text-light-primary dark:text-dark-primary">
              {isLoading ? <span className="skeleton w-20 h-4" /> : `Hi, ${userName.split(' ')[0]}`}
            </p>
            <p className="text-xs text-light-tertiary dark:text-dark-tertiary">Good Morning 🌅</p>
          </div>
        </div>

        {/* Right Actions */}
        <div className="flex items-center gap-2">
          {/* Bell Icon - Notifications */}
          <button className="w-10 h-10 rounded-full bg-light-secondary dark:bg-dark-tertiary flex items-center justify-center hover:bg-light-tertiary dark:hover:bg-dark-tertiary/80 transition-colors text-light-secondary dark:text-dark-secondary">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z" />
            </svg>
          </button>

          {/* Theme Toggle */}
          <button 
            onClick={toggleTheme}
            className="w-10 h-10 rounded-full bg-light-secondary dark:bg-dark-tertiary flex items-center justify-center hover:bg-light-tertiary dark:hover:bg-dark-tertiary/80 transition-colors text-light-tertiary dark:text-yellow-300"
          >
            {theme === 'light' ? (
              <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
              </svg>
            ) : (
              <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="5" />
                <line x1="12" y1="1" x2="12" y2="3" stroke="currentColor" strokeWidth="2" />
                <line x1="12" y1="21" x2="12" y2="23" stroke="currentColor" strokeWidth="2" />
                <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" stroke="currentColor" strokeWidth="2" />
                <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" stroke="currentColor" strokeWidth="2" />
                <line x1="1" y1="12" x2="3" y2="12" stroke="currentColor" strokeWidth="2" />
                <line x1="21" y1="12" x2="23" y2="12" stroke="currentColor" strokeWidth="2" />
                <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" stroke="currentColor" strokeWidth="2" />
                <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" stroke="currentColor" strokeWidth="2" />
              </svg>
            )}
          </button>

          {/* Menu */}
          <button 
            onClick={() => setShowMenu(!showMenu)}
            className="w-10 h-10 rounded-full bg-light-secondary dark:bg-dark-tertiary flex items-center justify-center hover:bg-light-tertiary dark:hover:bg-dark-tertiary/80 transition-colors text-light-tertiary dark:text-dark-secondary"
          >
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" />
            </svg>
          </button>
        </div>
      </div>
    </header>
  );
}
