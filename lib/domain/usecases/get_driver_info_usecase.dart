import '../entities/driver.dart';
import '../repositories/tracking_repository.dart';

class GetDriverInfoUseCase {
  final TrackingRepository repository;

  GetDriverInfoUseCase(this.repository);

  Future<Driver> call() async {
    return await repository.getDriverInfo();
  }
}