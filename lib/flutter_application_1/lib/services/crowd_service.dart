class CrowdService {
  // Mock data representing crowd density in various zones (0.0 to 1.0)
  static final Map<String, double> _mockCrowdDensity = {
    'market_square': 0.85,
    'central_station': 0.95,
    'city_park': 0.25,
    'suburban_road': 0.10,
    'university_campus': 0.60,
  };

  static Future<double> getDensityAtLocation(double lat, double lng) async {
    // Simulate real-time crowd analysis delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // In a real app, logic would use geofencing or heatmaps
    return 0.45; // Default medium density
  }

  static Future<Map<String, double>> getAllDensities() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockCrowdDensity;
  }
}
