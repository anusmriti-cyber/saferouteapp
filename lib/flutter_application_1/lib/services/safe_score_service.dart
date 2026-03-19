import 'api_client.dart';

class SafeScoreService {
  Future<Map<String, dynamic>> getSafetyScore(
    double latitude,
    double longitude,
  ) async {
    final response = await ApiClient.post("/safety-score", {
      "lat": latitude,
      "lng": longitude,
      "time": DateTime.now().toIso8601String(),
    });

    return response;
  }
}
