'use client';

interface WalletCardProps {
  balance: number;
  isLoading?: boolean;
}

export default function WalletCard({ balance, isLoading }: WalletCardProps) {
  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0,
    }).format(value);
  };

  return (
    <div className="rounded-xl bg-gradient-to-br from-[#50C878] to-[#2E8B57] p-6 text-white shadow-soft-lg">
      <div className="flex justify-between items-start mb-12">
        <div>
          <p className="text-sm opacity-90 mb-1">Saldo Dompet</p>
          <p className="text-3xl font-bold">
            {isLoading ? (
              <span className="skeleton w-32 h-8 bg-green-400" />
            ) : (
              formatCurrency(balance)
            )}
          </p>
        </div>
        <div className="w-12 h-12 bg-white/20 rounded-lg flex items-center justify-center">
          <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
          </svg>
        </div>
      </div>

      <div className="flex gap-3">
        <button className="flex-1 bg-white/20 hover:bg-white/30 backdrop-blur rounded-lg py-2.5 font-semibold text-sm transition-colors">
          Isi Saldo
        </button>
        <button className="flex-1 bg-white/20 hover:bg-white/30 backdrop-blur rounded-lg py-2.5 font-semibold text-sm transition-colors">
          Tarik Dana
        </button>
      </div>
    </div>
  );
}
