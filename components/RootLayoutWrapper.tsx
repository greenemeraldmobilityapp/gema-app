'use client';

import { useTheme } from './ThemeProvider';

export default function RootLayoutWrapper({ children }: { children: React.ReactNode }) {
  const { theme } = useTheme();

  return (
    <div className={theme} suppressHydrationWarning>
      {children}
    </div>
  );
}
