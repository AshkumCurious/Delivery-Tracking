import '../repositories/tracking_repository.dart';

class StopTrackingUseCase {
  final TrackingRepository repository;

  StopTrackingUseCase(this.repository);

  Future<void> call() async {
    return await repository.stopTracking();
  }
}