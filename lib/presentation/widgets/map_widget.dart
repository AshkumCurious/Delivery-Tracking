import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../blocs/map/map_bloc.dart';
import '../blocs/map/map_state.dart';
import 'dart:math' as math;

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  late MapController _mapController;
  AnimationController? _markerAnimationController;
  Animation<double>? _markerAnimation;
  LatLng? _previousPosition;
  LatLng? _targetPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _markerAnimationController?.dispose();
    super.dispose();
  }

  void _animateMarker(LatLng from, LatLng to) {
    _previousPosition = from;
    _targetPosition = to;

    _markerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _markerAnimationController!,
        curve: Curves.linear,
      ),
    );

    _markerAnimationController!.forward(from: 0.0);
  }

  LatLng _interpolatePosition(double t) {
    if (_previousPosition == null || _targetPosition == null) {
      return _targetPosition ?? const LatLng(0, 0);
    }

    return LatLng(
      _previousPosition!.latitude +
          (_targetPosition!.latitude - _previousPosition!.latitude) * t,
      _previousPosition!.longitude +
          (_targetPosition!.longitude - _previousPosition!.longitude) * t,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state.isInitialized && state.driverPosition != null) {
          if (_previousPosition == null) {
            _previousPosition = state.driverPosition;
          } else if (_previousPosition != state.driverPosition) {
            _animateMarker(_previousPosition!, state.driverPosition!);
          }

          _mapController.move(state.driverPosition!, state.cameraZoom);
        }
      },
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _markerAnimationController!,
          builder: (context, child) {
            final currentDriverPosition = _markerAnimation != null
                ? _interpolatePosition(_markerAnimation!.value)
                : state.driverPosition;

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: state.cameraCenter,
                initialZoom: state.cameraZoom,
                minZoom: 10.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.delivery_tracking',
                ),

                if (state.routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: state.routePoints,
                        strokeWidth: 4.0,
                        color: const Color(0xFF4F46E5),
                        borderStrokeWidth: 2.0,
                        borderColor: Colors.white,
                      ),
                    ],
                  ),

                MarkerLayer(
                  markers: [
                    if (state.userPosition != null)
                      Marker(
                        point: state.userPosition!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),

                    if (state.destinationPosition != null)
                      Marker(
                        point: state.destinationPosition!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.place,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),

                    if (currentDriverPosition != null)
                      Marker(
                        point: currentDriverPosition,
                        width: 60,
                        height: 60,
                        child: Transform.rotate(
                          angle: state.driverHeading * math.pi / 180,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF4F46E5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
