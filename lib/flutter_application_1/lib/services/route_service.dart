import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';
import 'osrm_service.dart';

class RouteService {
  static Future<List<RouteModel>> getRoutes({
    required LatLng start,
    required LatLng end,
  }) async {
    final osrmResult = await OSRMService.getRoute(start: start, end: end);

    return [
      RouteModel(
        name: "Safest Route",
        path: osrmResult.path,
        safeScore: 85,
        lightingScore: 90,
        transportScore: 80,
        crowdScore: 85,
        distanceKm: osrmResult.distanceKm,
        durationMin: osrmResult.durationMin,
      ),
    ];
  }
}
