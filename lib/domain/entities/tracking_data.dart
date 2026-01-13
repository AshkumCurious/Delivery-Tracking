import 'package:delivery_tracking/domain/entities/driver.dart';
import 'package:delivery_tracking/domain/entities/location.dart';
import 'package:equatable/equatable.dart';

class TrackingData extends Equatable {
  final Location currentLocation;
  final Driver driver;
  final double distanceRemaining;
  final Duration estimatedTime;
  final List<Location> route;

  const TrackingData({
    required this.currentLocation,
    required this.driver,
    required this.distanceRemaining,
    required this.estimatedTime,
    required this.route,
  });

  @override
  List<Object?> get props => [
        currentLocation,
        driver,
        distanceRemaining,
        estimatedTime,
        route,
      ];
}