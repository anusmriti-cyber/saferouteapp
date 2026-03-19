import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class LocationProvider extends ChangeNotifier {
  LatLng _currentLocation = const LatLng(22.5726, 88.3639); // Default: Kolkata
  bool _isTracking = false;

  LatLng get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;

  void updateLocation(LatLng newLocation) {
    _currentLocation = newLocation;
    notifyListeners();
  }

  Future<void> startTracking() async {
    _isTracking = true;
    notifyListeners();
    // Logic to start live location updates from geolocator
  }

  void stopTracking() {
    _isTracking = false;
    notifyListeners();
  }
}
