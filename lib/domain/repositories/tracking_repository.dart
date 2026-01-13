import '../entities/location.dart';
import '../entities/driver.dart';

abstract class TrackingRepository {
  Stream<Location> getLocationStream();
  
  Future<Driver> getDriverInfo();
  
  Future<List<Location>> getRouteCoordinates();
  
  double calculateDistance(double lat1, double lon1, double lat2, double lon2);
  
  Duration calculateETA(double distanceKm, double averageSpeedKmh);
  
  Future<void> startTracking();
  
  Future<void> stopTracking();

  Future<void> resetTracking();
}