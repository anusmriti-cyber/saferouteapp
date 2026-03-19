import 'package:flutter/foundation.dart';

class SOSService {
  static final SOSService _instance = SOSService._internal();
  factory SOSService() => _instance;
  SOSService._internal();

  bool _isSosActive = false;
  bool get isSosActive => _isSosActive;

  Future<void> triggerSOS() async {
    if (_isSosActive) return;
    
    _isSosActive = true;
    if (kDebugMode) {
      print("SOS TRIGGERED! Notifying authorities and emergency contacts...");
    }

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    
    // Logic to:
    // 1. Send SMS to emergency contacts
    // 2. Alert SafeRoute Backend
    // 3. (Optional) Call emergency services
  }

  Future<void> cancelSOS() async {
    _isSosActive = false;
    if (kDebugMode) {
      print("SOS Cancelled.");
    }
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simple Euclidean distance for mock purposes
    return 0.5; 
  }
}
