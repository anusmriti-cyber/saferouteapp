import 'package:latlong2/latlong.dart';

class TransportDataModel {
  final LatLng location;
  final String transportType; // Bus, Auto, Metro
  final String frequency; // e.g. "Every 10 mins"
  final String transportName; // e.g. "Howrah Local", "Bus 215"
  final String areaName;
  final List<String> schedules;
  final String frequencyLevel; // High, Medium, Low
  final int transportScore; // 0–100

  TransportDataModel({
    required this.location,
    required this.transportType,
    required this.transportName,
    required this.frequency,
    required this.areaName,
    required this.schedules,
    required this.frequencyLevel,
    required this.transportScore,
  });
}
