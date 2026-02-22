/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        emerald: {
          50: '#f0fdf4',
          100: '#dcfce7',
          200: '#bbf7d0',
          300: '#86efac',
          400: '#4ade80',
          500: '#22c55e',
          600: '#16a34a',
          700: '#15803d',
          800: '#166534',
          900: '#145231',
          main: '#50C878',
          dark: '#2E8B57',
        },
        warning: '#FFCC00',
        danger: '#E74C3C',
        'success': '#10b981',
        // Light Mode Colors
        'light-primary': '#ffffff',
        'light-secondary': '#f9fafb',
        'light-tertiary': '#f3f4f6',
        'light-text-primary': '#111827',
        'light-text-secondary': '#4b5563',
        'light-text-tertiary': '#9ca3af',
        'light-border': '#e5e7eb',
        'light-border-light': '#f3f4f6',
        // Dark Mode Colors
        'dark-primary': '#0f172a',
        'dark-secondary': '#1e293b',
        'dark-tertiary': '#334155',
        'dark-text-primary': '#f1f5f9',
        'dark-text-secondary': '#cbd5e1',
        'dark-text-tertiary': '#94a3b8',
        'dark-border': '#475569',
        'dark-border-light': '#334155',
      },
      backgroundColor: {
        light: '#FFFFFF',
        'light-secondary': '#F9FAFB',
        'light-tertiary': '#F3F4F6',
        dark: '#0f172a',
        'dark-secondary': '#1e293b',
        'dark-tertiary': '#334155',
      },
      textColor: {
        'light-primary': '#111827',
        'light-secondary': '#4b5563',
        'light-tertiary': '#9ca3af',
        'dark-primary': '#f1f5f9',
        'dark-secondary': '#cbd5e1',
        'dark-tertiary': '#94a3b8',
      },
      borderColor: {
        'light-border': '#e5e7eb',
        'light-border-light': '#f3f4f6',
        'dark-border': '#475569',
        'dark-border-light': '#334155',
      },
      borderRadius: {
        lg: '8px',
        xl: '12px',
      },
      boxShadow: {
        soft: '0 2px 4px rgba(0, 0, 0, 0.05)',
        'soft-lg': '0 10px 15px rgba(0, 0, 0, 0.1)',
        'light': '0 2px 8px rgba(0, 0, 0, 0.08)',
        'dark': '0 2px 8px rgba(0, 0, 0, 0.4)',
      },
    },
  },
  plugins: [
    function ({ addComponents, addUtilities, theme }) {
      // Custom component classes for Light & Dark modes
      addComponents({
        // CARDS
        '.card': {
          '@apply rounded-xl transition-all duration-300': {},
        },
        '.card-light': {
          '@apply bg-white border border-light-border shadow-light text-light-primary': {},
        },
        '.card-dark': {
          '@apply dark:bg-dark-secondary dark:border dark:border-dark-border dark:shadow-dark dark:text-dark-primary': {},
        },
        '.card-base': {
          '@apply bg-white dark:bg-dark-secondary border border-light-border dark:border-dark-border shadow-light dark:shadow-dark text-light-primary dark:text-dark-primary': {},
        },
        
        // BUTTONS
        '.btn': {
          '@apply rounded-lg font-medium transition-all duration-200 flex items-center justify-center px-4 py-2': {},
        },
        '.btn-primary': {
          '@apply bg-emerald-main text-white hover:bg-emerald-dark hover:shadow-light dark:hover:shadow-dark active:scale-95': {},
        },
        '.btn-secondary': {
          '@apply bg-light-tertiary text-light-primary dark:bg-dark-tertiary dark:text-dark-primary hover:bg-light-secondary dark:hover:bg-dark-secondary': {},
        },
        '.btn-danger': {
          '@apply bg-danger text-white hover:bg-red-600 dark:bg-red-600 dark:hover:bg-red-700 active:scale-95': {},
        },
        '.btn-warning': {
          '@apply bg-warning text-gray-800 hover:bg-yellow-500 active:scale-95': {},
        },
        
        // INPUT FIELDS
        '.input-field': {
          '@apply rounded-lg border-2 border-light-border dark:border-dark-border px-4 py-2 transition-all duration-200 focus:outline-none focus:border-emerald-main bg-white dark:bg-dark-secondary text-light-primary dark:text-dark-primary placeholder-light-tertiary dark:placeholder-dark-tertiary': {},
        },
        
        // HEADERS & TEXT
        '.text-primary': {
          '@apply text-light-primary dark:text-dark-primary': {},
        },
        '.text-secondary': {
          '@apply text-light-secondary dark:text-dark-secondary': {},
        },
        '.text-tertiary': {
          '@apply text-light-tertiary dark:text-dark-tertiary': {},
        },
        
        // DIVIDERS & BORDERS
        '.divider': {
          '@apply border-light-border dark:border-dark-border': {},
        },
      });

      // Utilities for better flexibility
      addUtilities({
        '.surface-primary': {
          '@apply bg-white dark:bg-dark-primary': {},
        },
        '.surface-secondary': {
          '@apply bg-light-secondary dark:bg-dark-secondary': {},
        },
        '.surface-tertiary': {
          '@apply bg-light-tertiary dark:bg-dark-tertiary': {},
        },
        '.surface-elevated': {
          '@apply shadow-light dark:shadow-dark': {},
        },
        '.shadow-soft': {
          'box-shadow': '0 2px 4px rgba(0, 0, 0, 0.05)',
        },
        '.shadow-soft-lg': {
          'box-shadow': '0 10px 15px rgba(0, 0, 0, 0.1)',
        },
        '.haptic-tap': {
          '@apply active:scale-95 transition-transform duration-75': {},
        },
        '.carving-watermark': {
          'background-image': 'url("data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22%3E%3Cpath d=%22M50 10 L60 40 L90 40 L70 55 L80 85 L50 70 L20 85 L30 55 L10 40 L40 40 Z%22 fill=%22%23000%22 opacity=%220.03%22/%3E%3C/svg%3E")',
          'background-repeat': 'repeat',
          'background-size': '200px 200px',
        },
      });
    },
  ],
};
