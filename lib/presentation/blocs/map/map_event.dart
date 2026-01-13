import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class InitializeMap extends MapEvent {
  const InitializeMap();
}

class UpdateDriverPosition extends MapEvent {
  final LatLng position;
  final double heading;

  const UpdateDriverPosition({
    required this.position,
    required this.heading,
  });

  @override
  List<Object?> get props => [position, heading];
}

class UpdateCameraPosition extends MapEvent {
  final LatLng center;
  final double zoom;

  const UpdateCameraPosition({
    required this.center,
    required this.zoom,
  });

  @override
  List<Object?> get props => [center, zoom];
}

class SetRoute extends MapEvent {
  final List<LatLng> routePoints;

  const SetRoute(this.routePoints);

  @override
  List<Object?> get props => [routePoints];
}

class AnimateToDriver extends MapEvent {
  const AnimateToDriver();
}

