// core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../../data/datasources/mock_location_service.dart';
import '../../data/repositories/tracking_repository_impl.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../domain/usecases/start_tracking_usecase.dart';
import '../../domain/usecases/stop_tracking_usecase.dart';
import '../../domain/usecases/get_location_stream_usecase.dart';
import '../../domain/usecases/get_driver_info_usecase.dart';
import '../../presentation/blocs/tracking/tracking_bloc.dart';
import '../../presentation/blocs/map/map_bloc.dart';

final getItInst = GetIt.instance;

Future<void> init() async {
  getItInst.registerFactory(
    () => TrackingBloc(
      startTrackingUseCase: getItInst(),
      stopTrackingUseCase: getItInst(),
      getLocationStreamUseCase: getItInst(),
      getDriverInfoUseCase: getItInst(),
      repository: getItInst(),
    ),
  );

  getItInst.registerFactory(() => MapBloc());
  getItInst.registerLazySingleton(() => StartTrackingUseCase(getItInst()));
  getItInst.registerLazySingleton(() => StopTrackingUseCase(getItInst()));
  getItInst.registerLazySingleton(() => GetLocationStreamUseCase(getItInst()));
  getItInst.registerLazySingleton(() => GetDriverInfoUseCase(getItInst()));
  getItInst.registerLazySingleton<TrackingRepository>(
    () => TrackingRepositoryImpl(getItInst()),
  );
  getItInst.registerLazySingleton(() => MockLocationService());
}