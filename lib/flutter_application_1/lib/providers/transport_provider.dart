import 'package:flutter/foundation.dart';
import '../models/transport_data_model.dart';
import '../services/trnsport_api_service.dart';

class TransportProvider extends ChangeNotifier {
  List<TransportDataModel> _transports = [];
  bool _isLoading = false;
  String _currentCategory = "Bus";

  List<TransportDataModel> get transports => _transports;
  bool get isLoading => _isLoading;
  String get currentCategory => _currentCategory;

  Future<void> fetchTransports(String category) async {
    _isLoading = true;
    _currentCategory = category;
    notifyListeners();

    try {
      // Logic to fetch from TransportApiService
      await Future.delayed(const Duration(milliseconds: 800));
      _transports = []; // Mock fetching
    } catch (e) {
      if (kDebugMode) print("Error fetching transport: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
