'use client';

import { ReactNode } from 'react';

interface CardProps {
  children: ReactNode;
  className?: string;
  onClick?: () => void;
  variant?: 'default' | 'elevated' | 'outlined';
}

export default function Card({
  children,
  className = '',
  onClick,
  variant = 'default',
}: CardProps) {
  const variantClasses = {
    default: 'bg-light-secondary dark:bg-dark-secondary shadow-light dark:shadow-dark border border-light-border dark:border-dark-border',
    elevated: 'bg-light-primary dark:bg-dark-secondary shadow-light dark:shadow-dark border border-light-border dark:border-dark-border',
    outlined: 'bg-transparent border-2 border-light-border dark:border-dark-border',
  };

  return (
    <div
      className={`card rounded-xl p-4 transition-all duration-200 ${variantClasses[variant]} ${
        onClick ? 'cursor-pointer hover:shadow-soft-lg' : ''
      } ${className}`}
      onClick={onClick}
    >
      {children}
    </div>
  );
}
