import 'package:equatable/equatable.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/entities/driver.dart';
import '../../../domain/entities/delivery_status.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {
  const TrackingInitial();
}

class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

class TrackingActive extends TrackingState {
  final Location currentLocation;
  final Driver? driver;
  final double distanceRemaining;
  final Duration eta;
  final DeliveryStatus status;
  final DateTime lastUpdated;

  const TrackingActive({
    required this.currentLocation,
    this.driver,
    required this.distanceRemaining,
    required this.eta,
    required this.status,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        currentLocation,
        driver,
        distanceRemaining,
        eta,
        status,
        lastUpdated,
      ];

  TrackingActive copyWith({
    Location? currentLocation,
    Driver? driver,
    double? distanceRemaining,
    Duration? eta,
    DeliveryStatus? status,
    DateTime? lastUpdated,
  }) {
    return TrackingActive(
      currentLocation: currentLocation ?? this.currentLocation,
      driver: driver ?? this.driver,
      distanceRemaining: distanceRemaining ?? this.distanceRemaining,
      eta: eta ?? this.eta,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class TrackingCompleted extends TrackingState {
  final DateTime completedAt;

  const TrackingCompleted({required this.completedAt});

  @override
  List<Object?> get props => [completedAt];
}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}