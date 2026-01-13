import '../entities/location.dart';
import '../repositories/tracking_repository.dart';

class GetLocationStreamUseCase {
  final TrackingRepository repository;

  GetLocationStreamUseCase(this.repository);

  Stream<Location> call() {
    return repository.getLocationStream();
  }
}