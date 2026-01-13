import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState.initial()) {
    on<InitializeMap>(_onInitializeMap);
    on<UpdateDriverPosition>(_onUpdateDriverPosition);
    on<UpdateCameraPosition>(_onUpdateCameraPosition);
    on<SetRoute>(_onSetRoute);
    on<AnimateToDriver>(_onAnimateToDriver);
  }

  void _onInitializeMap(InitializeMap event, Emitter<MapState> emit) {
    const userPos = LatLng(12.9784, 77.6408);
    const destinationPos = LatLng(12.9596, 77.6732);

    emit(
      state.copyWith(
        userPosition: userPos,
        destinationPosition: destinationPos,
        driverPosition: userPos,
        cameraCenter: userPos,
        isInitialized: true,
      ),
    );
  }

  void _onUpdateDriverPosition(
    UpdateDriverPosition event,
    Emitter<MapState> emit,
  ) {
    emit(
      state.copyWith(
        driverPosition: event.position,
        driverHeading: event.heading,
      ),
    );
  }

  void _onUpdateCameraPosition(
    UpdateCameraPosition event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(cameraCenter: event.center, cameraZoom: event.zoom));
  }

  void _onSetRoute(SetRoute event, Emitter<MapState> emit) {
    emit(state.copyWith(routePoints: event.routePoints));
  }

  void _onAnimateToDriver(AnimateToDriver event, Emitter<MapState> emit) {
    if (state.driverPosition != null) {
      emit(
        state.copyWith(cameraCenter: state.driverPosition, cameraZoom: 16.0),
      );
    }
  }
}
