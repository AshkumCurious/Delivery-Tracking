import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/blocs/tracking/tracking_bloc.dart';
import 'presentation/blocs/map/map_bloc.dart';
import 'presentation/screens/tracking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const DeliveryTrackingApp());
}

class DeliveryTrackingApp extends StatelessWidget {
  const DeliveryTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Delivery Tracking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<TrackingBloc>(
            create: (context) => di.getItInst<TrackingBloc>(),
          ),
          BlocProvider<MapBloc>(create: (context) => di.getItInst<MapBloc>()),
        ],
        child: const TrackingScreen(),
      ),
    );
  }
}
