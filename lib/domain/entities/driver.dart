import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String vehicleNumber;
  final String photoUrl;
  final double rating;

  const Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.vehicleNumber,
    required this.photoUrl,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        vehicleNumber,
        photoUrl,
        rating,
      ];
}