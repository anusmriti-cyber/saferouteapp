import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OSRMRouteResult {
  final List<LatLng> path;
  final double distanceKm;
  final double durationMin;

  OSRMRouteResult({
    required this.path,
    required this.distanceKm,
    required this.durationMin,
  });
}

class OSRMService {
  static Future<OSRMRouteResult> getRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};'
      '${end.longitude},${end.latitude}'
      '?overview=full&geometries=geojson',
    );

    final response = await http.get(url);

    final data = json.decode(response.body);
    final route = data['routes'][0];

    final coords = route['geometry']['coordinates'] as List;

    final path = coords
        .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
        .toList();

    final distanceKm = route['distance'] / 1000;
    final durationMin = route['duration'] / 60;

    return OSRMRouteResult(
      path: path,
      distanceKm: distanceKm,
      durationMin: durationMin,
    );
  }
}
