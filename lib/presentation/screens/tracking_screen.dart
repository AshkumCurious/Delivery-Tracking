import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../blocs/tracking/tracking_bloc.dart';
import '../blocs/tracking/tracking_event.dart';
import '../blocs/tracking/tracking_state.dart';
import '../blocs/map/map_bloc.dart';
import '../blocs/map/map_event.dart';
import '../widgets/map_widget.dart';
import '../widgets/driver_info_bottom_sheet.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MapBloc>().add(const InitializeMap());
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<TrackingBloc>().add(const StartTracking());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TrackingBloc, TrackingState>(
        listener: (context, state) {
          if (state is TrackingActive) {
            context.read<MapBloc>().add(
              UpdateDriverPosition(
                position: LatLng(
                  state.currentLocation.latitude,
                  state.currentLocation.longitude,
                ),
                heading: state.currentLocation.heading,
              ),
            );
          } else if (state is TrackingCompleted) {
            _showDeliveryCompletedDialog(context);
          } else if (state is TrackingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              const MapWidget(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              context.read<TrackingBloc>().add(
                                const StopTracking(),
                              );
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Track Delivery',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () {
                              context.read<MapBloc>().add(
                                const AnimateToDriver(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (state is TrackingLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),

              if (state is TrackingActive)
                DraggableScrollableSheet(
                  initialChildSize: 0.18, 
                  minChildSize: 0.18,
                  maxChildSize: 0.5, 
                  builder: (context, scrollController) {
                    return DriverInfoBottomSheet(
                      scrollController: scrollController,
                      driver: state.driver,
                      status: state.status,
                      distanceKm: state.distanceRemaining,
                      eta: state.eta,
                      lastUpdated: state.lastUpdated,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  void _showDeliveryCompletedDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Delivered!'),
          ],
        ),
        content: const Text('Your order has been delivered successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();

              parentContext.read<TrackingBloc>().add(const StopTracking());
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
