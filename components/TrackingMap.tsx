'use client';

interface TrackingMapProps {
  orderId: string;
  driverLat?: number;
  driverLng?: number;
  destLat?: number;
  destLng?: number;
  driverName?: string;
  driverPhone?: string;
  estimatedTime?: string;
  status?: 'pending' | 'pickup' | 'otw' | 'delivered' | 'cancelled';
}

export default function TrackingMap({
  orderId,
  driverName = 'Budi Wijaya',
  estimatedTime = '15 menit',
  status = 'otw',
}: TrackingMapProps) {
  const statusConfig = {
    pending: { label: 'Menunggu kurir', color: 'bg-[#FFCC00] text-gray-800' },
    pickup: { label: 'Mengambil barang', color: 'bg-blue-500 text-white' },
    otw: { label: 'Dalam perjalanan', color: 'bg-[#50C878] text-white' },
    delivered: { label: 'Sampai', color: 'bg-purple-500 text-white' },
    cancelled: { label: 'Dibatalkan', color: 'bg-[#E74C3C] text-white' },
  };

  return (
    <div className="h-screen w-full flex flex-col bg-gray-100 dark:bg-gray-900">
      {/* Map Container - Placeholder */}
      <div className="flex-1 bg-gradient-to-br from-blue-100 to-blue-50 dark:from-gray-800 dark:to-gray-700 relative overflow-hidden">
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="text-center">
            <svg className="w-20 h-20 mx-auto text-blue-400 opacity-30 mb-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm3.5-9c.83 0 1.5-.67 1.5-1.5S16.33 8 15.5 8 14 8.67 14 9.5s.67 1.5 1.5 1.5z" />
            </svg>
            <p className="text-gray-500 dark:text-gray-400">Peta Interaktif (Leaflet.js)</p>
          </div>
        </div>

        {/* Current Location Marker */}
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 animate-pulse">
          <div className="w-4 h-4 bg-[#50C878] rounded-full border-4 border-white shadow-lg" />
        </div>

        {/* Close Button */}
        <button className="absolute top-4 right-4 w-10 h-10 bg-white dark:bg-gray-800 rounded-full shadow-soft flex items-center justify-center hover:bg-gray-50 dark:hover:bg-gray-700 z-10">
          <svg className="w-5 h-5 text-gray-600 dark:text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      {/* Floating Driver Info Drawer */}
      <div className="bg-white dark:bg-[#1e1e1e] rounded-t-3xl shadow-soft-lg border-t border-gray-200 dark:border-gray-700 p-6 space-y-4">
        {/* Status Badge */}
        <div className={`inline-block px-4 py-2 rounded-full font-semibold text-sm ${statusConfig[status].color}`}>
          {statusConfig[status].label}
        </div>

        {/* Driver Info */}
        <div className="flex items-start gap-4">
          <div className="w-16 h-16 rounded-full bg-gradient-to-br from-[#50C878] to-[#2E8B57] flex items-center justify-center text-white text-2xl font-bold flex-shrink-0">
            {driverName.charAt(0)}
          </div>
          <div className="flex-1">
            <p className="font-bold text-lg text-gray-900 dark:text-white">{driverName}</p>
            <p className="text-sm text-gray-500 dark:text-gray-400">Kurir • Kendaraan: B 1234 ABC</p>
            <p className="text-sm font-semibold text-[#50C878] mt-2">Estimasi: {estimatedTime}</p>
          </div>
          <button className="w-10 h-10 bg-[#50C878] rounded-full flex items-center justify-center text-white hover:bg-[#2E8B57] transition-colors flex-shrink-0">
            ⭐
          </button>
        </div>

        {/* Action Buttons */}
        <div className="grid grid-cols-3 gap-3 pt-4 border-t border-gray-200 dark:border-gray-700">
          {/* Call */}
          <button className="py-3 rounded-lg bg-green-50 dark:bg-green-900/20 text-[#50C878] hover:bg-green-100 dark:hover:bg-green-900/30 font-semibold text-sm transition-colors flex items-center justify-center gap-2">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z" />
            </svg>
            Panggil
          </button>

          {/* Message */}
          <button className="py-3 rounded-lg bg-blue-50 dark:bg-blue-900/20 text-blue-600 hover:bg-blue-100 dark:hover:bg-blue-900/30 font-semibold text-sm transition-colors flex items-center justify-center gap-2">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z" />
            </svg>
            Pesan
          </button>

          {/* Share Location */}
          <button className="py-3 rounded-lg bg-purple-50 dark:bg-purple-900/20 text-purple-600 hover:bg-purple-100 dark:hover:bg-purple-900/30 font-semibold text-sm transition-colors flex items-center justify-center gap-2">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm0-13c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5z" />
            </svg>
            Lokasi
          </button>
        </div>

        {/* Order Details */}
        <div className="pt-4 border-t border-gray-200 dark:border-gray-700 space-y-2">
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-400">ID Pesanan</span>
            <span className="font-semibold text-gray-900 dark:text-white">#{orderId}</span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-600 dark:text-gray-400">Total</span>
            <span className="font-semibold text-gray-900 dark:text-white">Rp 125.000</span>
          </div>
        </div>
      </div>
    </div>
  );
}
