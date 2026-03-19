import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../services/geocoding_service.dart';
import '../services/route_service.dart';
import '../models/route_model.dart';
import '../widgets/safe_score_gauge.dart';
import '../widgets/sos_hold_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController fromController = TextEditingController(
    text: "Current Location",
  );
  final TextEditingController toController = TextEditingController();

  LatLng? currentLocation;
  LatLng? destinationLocation;

  List<RouteModel> routes = [];
  RouteModel? selectedRoute;

  bool isPanelExpanded = false;
  bool isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // 🚨 SOS
  void _triggerSOS() {
    if (currentLocation == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Emergency SOS Activated",
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          "Live location shared:\n"
          "Lat: ${currentLocation!.latitude}\n"
          "Lng: ${currentLocation!.longitude}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Color getColorFromSafeScore(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  Widget _routeTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _scoreRow(String label, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            "$score / 100",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColorFromSafeScore(score),
            ),
          ),
        ],
      ),
    );
  }

  /// 🕒 ETA + 📏 DISTANCE WIDGET
  Widget _etaDistanceCard(RouteModel route) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                "${route.durationMin.toStringAsFixed(0)} mins",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.route, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                "${route.distanceKm.toStringAsFixed(1)} km",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("SafeRoute Map")),
      body: Stack(
        children: [
          // 🗺 MAP
          FlutterMap(
            options: MapOptions(
              initialCenter: currentLocation!,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'safe-route',
              ),

              // Background safety roads
              //PolylineLayer(
              //polylines: SafeScoreService.getDummyRoads().map((road) {
              //return Polyline(
              //points: road.roadPoints,
              //strokeWidth: 4,
              //color:
              //getColorFromSafeScore(road.safeScore).withOpacity(0.3),
              //);
              //}).toList(),
              //),

              // OSRM ROUTE
              PolylineLayer(
                polylines: routes.map((route) {
                  final isSelected = selectedRoute == route;
                  return Polyline(
                    points: route.path,
                    strokeWidth: isSelected ? 7 : 5,
                    color: isSelected
                        ? Colors.green
                        : Colors.green.withOpacity(0.4),
                  );
                }).toList(),
              ),

              // MARKERS
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLocation!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  if (destinationLocation != null)
                    Marker(
                      point: destinationLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.flag,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 🚨 SOS BUTTON
          Positioned(
            right: 20,
            bottom: 160,
            child: SOSHoldButton(
              onTriggered: _triggerSOS,
            ),
          ),

          // ⬆️ OPEN PANEL
          Positioned(
            left: 20,
            bottom: 160,
            child: FloatingActionButton(
              backgroundColor: Colors.black87,
              onPressed: () {
                setState(() => isPanelExpanded = true);
              },
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            ),
          ),

          // ⬆️ COLLAPSIBLE PANEL
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: isPanelExpanded ? 0 : -420,
            child: Container(
              height: 420,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ⬇️ CLOSE PANEL
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () {
                          setState(() => isPanelExpanded = false);
                        },
                      ),
                    ),

                    _routeTextField(
                      controller: fromController,
                      icon: Icons.my_location,
                      hint: "From",
                      enabled: false,
                    ),
                    const SizedBox(height: 10),
                    _routeTextField(
                      controller: toController,
                      icon: Icons.location_on,
                      hint: "Enter destination",
                      enabled: true,
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B894),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final query = toController.text.trim();
                          if (query.isEmpty) return;

                          setState(() => isLoadingRoute = true);

                          final geo = await GeocodingService.getCoordinates(
                            query,
                          );
                          if (geo == null) {
                            setState(() => isLoadingRoute = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Location not found"),
                              ),
                            );
                            return;
                          }

                          final fetchedRoutes = await RouteService.getRoutes(
                            start: currentLocation!,
                            end: geo,
                          );

                          setState(() {
                            destinationLocation = geo;
                            routes = fetchedRoutes;
                            selectedRoute = routes.first;
                            isLoadingRoute = false;
                          });
                        },
                        child: isLoadingRoute
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Find Safest Route",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),

                    // 🕒 ETA + 📏 DISTANCE
                    if (selectedRoute != null) _etaDistanceCard(selectedRoute!),

                    // WHY THIS ROUTE? Premium Breakdown
                    if (selectedRoute != null)
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Route Safety Breakdown",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SafeScoreGauge(
                              score: ((selectedRoute!.lightingScore +
                                          selectedRoute!.transportScore +
                                          selectedRoute!.crowdScore) /
                                      3)
                                  .toInt(),
                              size: 180,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _safetyItem(
                                  Icons.lightbulb,
                                  "Lighting",
                                  selectedRoute!.lightingScore,
                                  const Color(0xFFFFD93D),
                                ),
                                _safetyItem(
                                  Icons.groups,
                                  "Crowd",
                                  selectedRoute!.crowdScore,
                                  const Color(0xFF4A5DFF),
                                ),
                                _safetyItem(
                                  Icons.bus_alert,
                                  "Transport",
                                  selectedRoute!.transportScore,
                                  const Color(0xFF00B894),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _safetyItem(IconData icon, String label, int score, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          "$score%",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: getColorFromSafeScore(score),
          ),
        ),
      ],
    );
  }
}
