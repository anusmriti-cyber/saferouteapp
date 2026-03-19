
class CrimeService {
  // Mock data for testing
  static final List<Map<String, dynamic>> _mockCrimeStats = [
    {
      'latitude': 22.5726,
      'longitude': 88.3639,
      'crimeRate': 0.15,
      'description': 'Petty theft reported in this area recently',
      'lastIncidentDate': '2024-03-10'
    },
    {
      'latitude': 22.5800,
      'longitude': 88.3700,
      'crimeRate': 0.45,
      'description': 'Frequent burglaries reported here',
      'lastIncidentDate': '2024-03-15'
    }
  ];

  static Future<double> getSafetyScore(double lat, double lng) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Find closest mock incident or return default safe score
    // In a real app, this would query a spatial database
    return 85.0; // Default score out of 100
  }

  static Future<List<Map<String, dynamic>>> getAreaAnalysis(double lat, double lng) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockCrimeStats;
  }
}
