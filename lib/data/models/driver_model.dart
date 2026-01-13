import '../../domain/entities/driver.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.vehicleNumber,
    required super.photoUrl,
    required super.rating,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      photoUrl: json['photoUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'vehicleNumber': vehicleNumber,
      'photoUrl': photoUrl,
      'rating': rating,
    };
  }

  factory DriverModel.fromEntity(Driver driver) {
    return DriverModel(
      id: driver.id,
      name: driver.name,
      phoneNumber: driver.phoneNumber,
      vehicleNumber: driver.vehicleNumber,
      photoUrl: driver.photoUrl,
      rating: driver.rating,
    );
  }
}