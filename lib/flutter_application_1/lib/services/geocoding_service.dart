import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static Future<LatLng?> getCoordinates(String address) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=$address&format=json&limit=1',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'safe-route-app'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        return LatLng(
          double.parse(data[0]['lat']),
          double.parse(data[0]['lon']),
        );
      }
    }
    return null;
  }
}
