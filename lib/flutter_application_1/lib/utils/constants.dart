class AppConstants {
  static const String appName = "SafeRoute";
  static const String appTagline = "Your Safe Journey Companion";

  // API Endpoints (Placeholders)
  static const String baseUrl = "https://api.saferoute.app/v1";
  static const String crimeDataEndpoint = "/safety/crime-stats";
  static const String hazardReportEndpoint = "/safety/hazards";
  static const String routeSafetyEndpoint = "/navigation/safe-routes";
  static const String sosEndpoint = "/emergency/sos";

  // Maps Config
  static const double defaultLat = 22.5726; // Kolkata
  static const double defaultLng = 88.3639;
  static const double defaultZoom = 14.0;

  // Storage Keys
  static const String keyUserToken = "user_token";
  static const String keyUserData = "user_data";
  static const String keyIsFirstRun = "is_first_run";

  // Asset Paths
  static const String logoPath = "assets/images/logo.png";
  static const String mapMarkerPath = "assets/icons/marker.png";
}
