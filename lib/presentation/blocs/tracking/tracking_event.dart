import 'package:equatable/equatable.dart';
import '../../../domain/entities/location.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class StartTracking extends TrackingEvent {
  const StartTracking();
}

class StopTracking extends TrackingEvent {
  const StopTracking();
}

class LocationUpdated extends TrackingEvent {
  final Location location;

  const LocationUpdated(this.location);

  @override
  List<Object?> get props => [location];
}

class LoadDriverInfo extends TrackingEvent {
  const LoadDriverInfo();
}

class DeliveryCompleted extends TrackingEvent {
  const DeliveryCompleted();
}

