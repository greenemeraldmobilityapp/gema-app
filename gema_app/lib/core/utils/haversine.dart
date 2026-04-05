import 'dart:math';

class Haversine {
  Haversine._();

  static const double _earthRadiusKm = 6371.0;

  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c * 1000;
  }

  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  static double calculateDurationMinutes(
    double distanceMeters, {
    double averageSpeedKmh = 30.0,
  }) {
    final distanceKm = distanceMeters / 1000;
    return (distanceKm / averageSpeedKmh) * 60;
  }

  static double estimateDeliveryFee(
    double distanceMeters, {
    double baseFare = 5000.0,
    double perKmRate = 2000.0,
  }) {
    final distanceKm = distanceMeters / 1000;
    return baseFare + (distanceKm * perKmRate);
  }
}
