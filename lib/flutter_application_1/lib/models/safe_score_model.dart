import 'package:latlong2/latlong.dart';

class SafeScoreModel {
  final List<LatLng> roadPoints;
  final int safeScore; // 0–100

  SafeScoreModel({required this.roadPoints, required this.safeScore});
}
