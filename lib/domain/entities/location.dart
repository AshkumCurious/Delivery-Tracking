import 'package:equatable/equatable.dart';

import 'delivery_status.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final DeliveryStatus status;
  final DateTime timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.status,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        speed,
        heading,
        status,
        timestamp,
      ];
}