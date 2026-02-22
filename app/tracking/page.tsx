'use client';

import TrackingMap from '@/components/TrackingMap';

export default function TrackingPage() {
  return (
    <TrackingMap
      orderId="1002"
      driverName="Budi Wijaya"
      driverPhone="082123456789"
      estimatedTime="15 menit"
      status="otw"
    />
  );
}
