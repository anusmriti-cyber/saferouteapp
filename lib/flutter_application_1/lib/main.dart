import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'utils/theme.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';
import 'providers/safe_score_provider.dart';
import 'providers/transport_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/hazard_report_screen.dart';
import 'screens/companion_mode_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/route_details_screen.dart';
import 'screens/emergency_contacts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => SafeScoreProvider()),
        ChangeNotifierProvider(create: (_) => TransportProvider()),
      ],
      child: const SafeRouteApp(),
    ),
  );
}

class SafeRouteApp extends StatelessWidget {
  const SafeRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRoute',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/sos': (context) => const SOSScreen(),
        '/hazard_report': (context) => const HazardReportScreen(),
        '/companion_mode': (context) => const CompanionModeScreen(),
        '/settings': (context) => const SettingScreen(),
        '/route_details': (context) => const RouteDetailsScreen(),
        '/emergency_contacts': (context) => const EmergencyContactsScreen(),
      },
    );
  }
}
