/**
 * Currency Formatter
 * Format numbers to Indonesian Rupiah (IDR)
 */
export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
  }).format(value);
}

/**
 * Date Formatter
 * Format date to Indonesian locale
 */
export function formatDate(date: Date | string): string {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  return dateObj.toLocaleDateString('id-ID', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

/**
 * Time Formatter
 * Format time to HH:MM format
 */
export function formatTime(date: Date | string): string {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  return dateObj.toLocaleTimeString('id-ID', {
    hour: '2-digit',
    minute: '2-digit',
  });
}

/**
 * Calculate Haversine Distance
 * Distance between two coordinates in kilometers
 */
export function haversineDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R = 6371; // Earth's radius in km
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

/**
 * Calculate Shipping Fee
 * Based on distance using Haversine formula
 */
export function calculateShippingFee(distance: number): number {
  // Rp 5.000 per km, minimum Rp 10.000
  const baseFee = 10000;
  const feePerKm = 5000;
  const calculatedFee = feePerKm * distance;
  return Math.max(baseFee, Math.ceil(calculatedFee / 1000) * 1000); // Round to nearest 1000
}

/**
 * Validate Email
 */
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Validate Phone Number
 * Indonesian phone numbers starting with 0 or +62
 */
export function isValidPhone(phone: string): boolean {
  const phoneRegex = /^(\+62|0)[0-9]{8,12}$/;
  return phoneRegex.test(phone.replace(/\s/g, ''));
}

/**
 * Generate UUID
 */
export function generateUUID(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

/**
 * Truncate Text
 */
export function truncateText(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}

/**
 * Debounce Function
 */
export function debounce<T extends (...args: any[]) => any>(
  func: T,
  delay: number
): (...args: Parameters<T>) => void {
  let timeoutId: NodeJS.Timeout;
  return (...args: Parameters<T>) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func(...args), delay);
  };
}

/**
 * Get Status Color
 * Returns color class based on order status
 */
export function getStatusColor(status: string): string {
  const colors: Record<string, string> = {
    pending: 'bg-[#FFCC00] text-gray-800',
    pickup: 'bg-blue-500 text-white',
    otw: 'bg-[#50C878] text-white',
    delivered: 'bg-purple-500 text-white',
    cancelled: 'bg-[#E74C3C] text-white',
  };
  return colors[status] || 'bg-gray-500 text-white';
}

/**
 * Get Status Label
 */
export function getStatusLabel(status: string): string {
  const labels: Record<string, string> = {
    pending: 'Menunggu Kurir',
    pickup: 'Mengambil Barang',
    otw: 'Dalam Perjalanan',
    delivered: 'Sampai',
    cancelled: 'Dibatalkan',
  };
  return labels[status] || 'Unknown';
}
