
import '../repositories/tracking_repository.dart';

class StartTrackingUseCase {
  final TrackingRepository repository;

  StartTrackingUseCase(this.repository);

  Future<void> call() async {
    return await repository.startTracking();
  }
}