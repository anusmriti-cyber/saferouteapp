import 'package:latlong2/latlong.dart';

class RouteModel {
  final String name;
  final List<LatLng> path;

  final int safeScore;
  final int lightingScore;
  final int transportScore;
  final int crowdScore;

  // ✅ NEW
  final double distanceKm;
  final double durationMin;

  RouteModel({
    required this.name,
    required this.path,
    required this.safeScore,
    required this.lightingScore,
    required this.transportScore,
    required this.crowdScore,
    required this.distanceKm,
    required this.durationMin,
  });
}
