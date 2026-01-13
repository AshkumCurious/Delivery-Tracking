import '../../domain/entities/location.dart';
import '../../domain/entities/delivery_status.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    required super.speed,
    required super.heading,
    required super.status,
    required super.timestamp,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      status: DeliveryStatus.fromString(json['status'] as String),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] as int) * 1000,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      'speed': speed,
      'heading': heading,
      'status': status.value,
      'timestamp': timestamp.millisecondsSinceEpoch ~/ 1000,
    };
  }

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      speed: location.speed,
      heading: location.heading,
      status: location.status,
      timestamp: location.timestamp,
    );
  }
}