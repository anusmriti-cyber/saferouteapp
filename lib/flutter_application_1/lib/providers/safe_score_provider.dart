import 'package:flutter/foundation.dart';
import '../services/safe_score_service.dart';

class SafeScoreProvider extends ChangeNotifier {
  double _currentSafeScore = 100.0;
  bool _isLoading = false;

  double get currentSafeScore => _currentSafeScore;
  bool get isLoading => _isLoading;

  Future<void> calculateScore(double lat, double lng) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, this would use SafeScoreService.calculate(lat, lng);
      await Future.delayed(const Duration(seconds: 1));
      _currentSafeScore = 88.5; 
    } catch (e) {
      if (kDebugMode) print("Error calculating score: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
