import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/delivery_status.dart';
import '../../../domain/usecases/start_tracking_usecase.dart';
import '../../../domain/usecases/stop_tracking_usecase.dart';
import '../../../domain/usecases/get_location_stream_usecase.dart';
import '../../../domain/usecases/get_driver_info_usecase.dart';
import '../../../domain/repositories/tracking_repository.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final StartTrackingUseCase startTrackingUseCase;
  final StopTrackingUseCase stopTrackingUseCase;
  final GetLocationStreamUseCase getLocationStreamUseCase;
  final GetDriverInfoUseCase getDriverInfoUseCase;
  final TrackingRepository repository;

  StreamSubscription? _locationSubscription;
  static const double _destinationLat = 12.9596;
  static const double _destinationLng = 77.6732;

  TrackingBloc({
    required this.startTrackingUseCase,
    required this.stopTrackingUseCase,
    required this.getLocationStreamUseCase,
    required this.getDriverInfoUseCase,
    required this.repository,
  }) : super(const TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
    on<LocationUpdated>(_onLocationUpdated);
    on<LoadDriverInfo>(_onLoadDriverInfo);
    on<DeliveryCompleted>(_onDeliveryCompleted);
  }

  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) async {
    try {
      if (_locationSubscription != null) {
        print('Already tracking, ignoring start event');
        return;
      }

      emit(const TrackingLoading());

      final driver = await getDriverInfoUseCase();

      _locationSubscription = getLocationStreamUseCase().listen(
        (location) {
          print(
            'Location received in bloc: ${location.latitude}, ${location.longitude}',
          );
          add(LocationUpdated(location));
        },
        onError: (error) {
          print('Error in location stream: $error');
          add(const StopTracking());
        },
        onDone: () {
          print('Location stream completed');
        },
      );

      await startTrackingUseCase();

      final initialLocation = await _getInitialLocation();
      emit(
        TrackingActive(
          currentLocation: initialLocation,
          driver: driver,
          distanceRemaining: 0.0,
          eta: const Duration(minutes: 0),
          status: DeliveryStatus.picked,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      print('Error starting tracking: $e');
      emit(TrackingError(message: e.toString()));
    }
  }

  Future<void> _onDeliveryCompleted(
    DeliveryCompleted event,
    Emitter<TrackingState> emit,
  ) async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    await repository.resetTracking(); 

    emit(const TrackingInitial());
  }

  Future<void> _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    await stopTrackingUseCase();
    emit(const TrackingInitial());
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<TrackingState> emit) {
    if (state is! TrackingActive) return;

    final currentState = state as TrackingActive;
    final location = event.location;

    final distance = repository.calculateDistance(
      location.latitude,
      location.longitude,
      _destinationLat,
      _destinationLng,
    );

    final eta = repository.calculateETA(distance, location.speed);

    if (location.status == DeliveryStatus.delivered || distance < 0.05) {
      emit(TrackingCompleted(completedAt: DateTime.now()));
      add(const DeliveryCompleted());
      return;
    }

    emit(
      currentState.copyWith(
        currentLocation: location,
        distanceRemaining: distance,
        eta: eta,
        status: location.status,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  Future<void> _onLoadDriverInfo(
    LoadDriverInfo event,
    Emitter<TrackingState> emit,
  ) async {
    if (state is TrackingActive) {
      final currentState = state as TrackingActive;
      try {
        final driver = await getDriverInfoUseCase();
        emit(currentState.copyWith(driver: driver));
      } catch (e) {
      }
    }
  }

  Future<dynamic> _getInitialLocation() async {
    return repository.getRouteCoordinates().then((coords) => coords.first);
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
