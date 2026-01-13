import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class MapState extends Equatable {
  final LatLng? driverPosition;
  final double driverHeading;
  final LatLng? userPosition;
  final LatLng? destinationPosition;
  final List<LatLng> routePoints;
  final LatLng cameraCenter;
  final double cameraZoom;
  final bool isInitialized;

  const MapState({
    this.driverPosition,
    this.driverHeading = 0.0,
    this.userPosition,
    this.destinationPosition,
    this.routePoints = const [],
    required this.cameraCenter,
    this.cameraZoom = 15.0,
    this.isInitialized = false,
  });

  factory MapState.initial() {
    return const MapState(
      cameraCenter: LatLng(12.9784, 77.6408),
      cameraZoom: 14.0,
      isInitialized: false,
    );
  }

  MapState copyWith({
    LatLng? driverPosition,
    double? driverHeading,
    LatLng? userPosition,
    LatLng? destinationPosition,
    List<LatLng>? routePoints,
    LatLng? cameraCenter,
    double? cameraZoom,
    bool? isInitialized,
  }) {
    return MapState(
      driverPosition: driverPosition ?? this.driverPosition,
      driverHeading: driverHeading ?? this.driverHeading,
      userPosition: userPosition ?? this.userPosition,
      destinationPosition: destinationPosition ?? this.destinationPosition,
      routePoints: routePoints ?? this.routePoints,
      cameraCenter: cameraCenter ?? this.cameraCenter,
      cameraZoom: cameraZoom ?? this.cameraZoom,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
    driverPosition,
    driverHeading,
    userPosition,
    destinationPosition,
    routePoints,
    cameraCenter,
    cameraZoom,
    isInitialized,
  ];
}
