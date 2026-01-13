import 'dart:async';
import 'dart:math';
import '../../domain/entities/location.dart';
import '../../domain/entities/delivery_status.dart';
import '../models/location_model.dart';

class MockLocationService {
  StreamController<Location>? _locationController;
  Timer? _timer;
  int _currentIndex = 0;
  bool _isTracking = false;

  static const List<Map<String, double>> _routeCoordinates = [
    // Indiranagar Metro
    {'lat': 12.9784, 'lng': 77.6408},

    {'lat': 12.9779, 'lng': 77.6422},
    {'lat': 12.9771, 'lng': 77.6440},
    {'lat': 12.9762, 'lng': 77.6461},

    // CMH Road stretch
    {'lat': 12.9750, 'lng': 77.6485},
    {'lat': 12.9738, 'lng': 77.6510},
    {'lat': 12.9725, 'lng': 77.6536},

    // Domlur
    {'lat': 12.9709, 'lng': 77.6560},
    {'lat': 12.9695, 'lng': 77.6584},

    // Inner Ring Road
    {'lat': 12.9678, 'lng': 77.6609},
    {'lat': 12.9659, 'lng': 77.6634},
    {'lat': 12.9642, 'lng': 77.6661},

    // Ejipura
    {'lat': 12.9626, 'lng': 77.6685},
    {'lat': 12.9611, 'lng': 77.6708},

    // Koramangala 5th Block
    {'lat': 12.9596, 'lng': 77.6732},
  ];

  Stream<Location> getLocationStream() {
    if (_locationController != null && !_locationController!.isClosed) {
      return _locationController!.stream;
    }

    _locationController = StreamController<Location>.broadcast();
    return _locationController!.stream;
  }

  void startTracking() {
    if (_isTracking || _currentIndex >= _routeCoordinates.length) {
      return;
    }

    print('Starting tracking from index: $_currentIndex');
    _isTracking = true;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex >= _routeCoordinates.length) {
        final lastCoordinate = _routeCoordinates.last;
        final deliveredLocation = LocationModel(
          latitude: lastCoordinate['lat']!,
          longitude: lastCoordinate['lng']!,
          speed: 0.0,
          heading: 0.0,
          status: DeliveryStatus.delivered,
          timestamp: DateTime.now(),
        );

        if (_locationController != null && !_locationController!.isClosed) {
          _locationController!.add(deliveredLocation);
        }

        timer.cancel();
        return;
      }

      final coordinate = _routeCoordinates[_currentIndex];
      final location = _createLocation(coordinate, _currentIndex);

      print(
        'Emitting location at index $_currentIndex: ${coordinate['lat']}, ${coordinate['lng']}',
      );

      if (_locationController != null && !_locationController!.isClosed) {
        _locationController!.add(location);
      }

      _currentIndex++;
    });
  }

  void stopTracking() {
    _isTracking = false;
    _timer?.cancel();
    _timer = null;
    // _locationController?.close();
    // _locationController = null;
    // _currentIndex = 0;
  }

  void resetTracking() {
    _isTracking = false;
    _timer?.cancel();
    _timer = null;

    _locationController?.close();
    _locationController = null;
    _currentIndex = 0;
  }

  Location _createLocation(Map<String, double> coordinate, int index) {
    final totalPoints = _routeCoordinates.length;
    final progress = index / totalPoints;

    DeliveryStatus status;
    if (progress < 0.1) {
      status = DeliveryStatus.picked;
    } else if (progress < 0.85) {
      status = DeliveryStatus.enRoute;
    } else if (progress < 1.0) {
      status = DeliveryStatus.arriving;
    } else {
      status = DeliveryStatus.delivered;
    }

    double heading = 0.0;
    if (index > 0) {
      final prevCoord = _routeCoordinates[index - 1];
      heading = _calculateBearing(
        prevCoord['lat']!,
        prevCoord['lng']!,
        coordinate['lat']!,
        coordinate['lng']!,
      );
    }
    final random = Random();
    final speed = 25.0 + random.nextDouble() * 15.0;

    return LocationModel(
      latitude: coordinate['lat']!,
      longitude: coordinate['lng']!,
      speed: speed,
      heading: heading,
      status: status,
      timestamp: DateTime.now(),
    );
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final dLon = _degreesToRadians(lon2 - lon1);
    final y = sin(dLon) * cos(_degreesToRadians(lat2));
    final x =
        cos(_degreesToRadians(lat1)) * sin(_degreesToRadians(lat2)) -
        sin(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * cos(dLon);
    final bearing = atan2(y, x);
    return (_radiansToDegrees(bearing) + 360) % 360;
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180.0;
  double _radiansToDegrees(double radians) => radians * 180.0 / pi;

  List<Location> getRouteCoordinates() {
    return _routeCoordinates.asMap().entries.map((entry) {
      return _createLocation(entry.value, entry.key);
    }).toList();
  }

  bool get isTracking => _isTracking;
}
