import '../repositories/tracking_repository.dart';

class CompleteDeliveryUseCase {
  final TrackingRepository repository;

  CompleteDeliveryUseCase(this.repository);

  Future<void> call() async {
    await repository.resetTracking();
  }
}
