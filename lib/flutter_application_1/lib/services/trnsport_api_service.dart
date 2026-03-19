import 'package:latlong2/latlong.dart';
import '../models/transport_data_model.dart';

class TransportApiService {
  static List<TransportDataModel> getDummyTransportData() {
    return [
      // --- BUSES ---
      TransportDataModel(
        location: const LatLng(22.8925, 88.3955),
        transportType: "Bus",
        transportName: "Bus 215 / S-12",
        frequency: "Every 12 mins",
        areaName: "Downtown Square",
        schedules: ["08:00 AM", "08:12 AM", "08:24 AM", "08:36 AM", "08:48 AM"],
        frequencyLevel: "High",
        transportScore: 85,
      ),
      TransportDataModel(
        location: const LatLng(22.8908, 88.3920),
        transportType: "Bus",
        transportName: "AC-47 Express",
        frequency: "Every 25 mins",
        areaName: "Suburban Mall",
        schedules: ["09:00 AM", "09:25 AM", "09:50 AM", "10:15 AM"],
        frequencyLevel: "Medium",
        transportScore: 60,
      ),
      // --- TRAINS ---
      TransportDataModel(
        location: const LatLng(22.8950, 88.4010),
        transportType: "Train",
        transportName: "Howrah Local",
        frequency: "Every 15 mins",
        areaName: "Central Junction",
        schedules: ["07:45 AM", "08:00 AM", "08:15 AM", "08:30 AM", "08:45 AM"],
        frequencyLevel: "High",
        transportScore: 90,
      ),
      TransportDataModel(
        location: const LatLng(22.8980, 88.4050),
        transportType: "Train",
        transportName: "Kolkata Metro (Line 1)",
        frequency: "Every 8 mins",
        areaName: "Park Street Station",
        schedules: ["08:05 AM", "08:13 AM", "08:21 AM", "08:29 AM", "08:37 AM"],
        frequencyLevel: "High",
        transportScore: 95,
      ),
      TransportDataModel(
        location: const LatLng(22.8940, 88.3990),
        transportType: "Train",
        transportName: "Intercity Express",
        frequency: "Occasional",
        areaName: "Peripheral Hub",
        schedules: ["06:30 AM", "11:00 AM", "04:30 PM", "09:00 PM"],
        frequencyLevel: "Low",
        transportScore: 40,
      ),
    ];
  }
}
