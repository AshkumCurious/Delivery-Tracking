import 'dart:math';
import '../../domain/entities/location.dart';
import '../../domain/entities/driver.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/mock_location_service.dart';
import '../models/driver_model.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final MockLocationService mockLocationService;
  Stream<Location>? _cachedStream;
  bool _isTracking = false;

  TrackingRepositoryImpl(this.mockLocationService);

  @override
  Stream<Location> getLocationStream() {
    _cachedStream ??= mockLocationService.getLocationStream();
    return _cachedStream!;
  }

  @override
  Future<Driver> getDriverInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const DriverModel(
      id: 'DRV001',
      name: 'Ashish Kumar',
      phoneNumber: '+91 98765 43210',
      vehicleNumber: 'TS 09 AB 1234',
      photoUrl:
          'https://ui-avatars.com/api/?name=Ashish+Kumar&size=200&background=4F46E5&color=fff',
      rating: 4.8,
    );
  }

  @override
  Future<List<Location>> getRouteCoordinates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockLocationService.getRouteCoordinates();
  }

  @override
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  @override
  Duration calculateETA(double distanceKm, double averageSpeedKmh) {
    if (averageSpeedKmh == 0) {
      return const Duration(hours: 0);
    }

    final hours = distanceKm / averageSpeedKmh;
    final minutes = (hours * 60).round();

    return Duration(minutes: minutes);
  }

  @override
  Future<void> startTracking() async {
    if (_isTracking) {
      print('Repository: Tracking already running — ignored');
      return;
    }

    print('Repository: Starting tracking');
    _isTracking = true;
    mockLocationService.startTracking();
  }

  @override
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    print('Repository: Stopping tracking');
    _isTracking = false;
    mockLocationService.stopTracking();
    _cachedStream = null;
  }

  @override
  Future<void> resetTracking() async {
    print('Repository: Reset tracking');
    _isTracking = false;
    mockLocationService.resetTracking();
    _cachedStream = null;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
