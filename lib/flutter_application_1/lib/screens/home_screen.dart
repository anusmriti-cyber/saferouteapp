import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'transport_screen.dart';
import 'profile_screen.dart';
import 'emergency_contacts_screen.dart';
import '../services/auth_service.dart';
import '../widgets/safe_score_gauge.dart';
import '../widgets/sos_hold_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final userName = user?['name'] ?? 'User';

    return Scaffold(
      drawer: _buildDrawer(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A0400)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔴 ANIMATED WOMEN SAFETY BANNER
              const _WomenSafetyBanner(),

              const SizedBox(height: 20),

              // 🔹 HEADER WITH MENU AND SEARCH
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Menu Button
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Search Bar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E), // Darker search bar
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF2E2E2E)),
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Where do you want to go?",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFE8340A),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          onSubmitted: (value) {
                            // Navigate to map with search query
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 WOMEN SAFETY SLOGAN
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE8340A).withOpacity(0.4),
                      const Color(0xFFE8340A).withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8340A).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.woman, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      "Empowering Women,\nEnsuring Safety",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your safety is our priority. Navigate with confidence.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 SAFETY FEATURES TITLE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Safety Features",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8340A),
                    letterSpacing: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 FEATURE ICONS GRID
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0, // Perfectly square
                  children: [
                    _featureIconCard(
                      icon: Icons.route,
                      title: "Safe Routes",
                      description: "Find secure paths to destination",
                      footer: "View Maps",
                      color: const Color(0xFF00D2FF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapScreen(),
                          ),
                        );
                      },
                    ),
                    _featureIconCard(
                      icon: Icons.directions_bus,
                      title: "Transport",
                      description: "Live safety scores",
                      footer: "Check Status",
                      color: const Color(0xFFFFB03B), // Vibrant Orange
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransportScreen(),
                          ),
                        );
                      },
                    ),
                    _featureIconCard(
                      icon: Icons.shield,
                      title: "SafeScore",
                      description: "Real-time analysis",
                      footer: "Scan Area",
                      color: const Color(0xFF00E676), // Neon Green
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF161616),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Current Safety Level",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const SafeScoreGauge(score: 85),
                                const SizedBox(height: 20),
                                const Text(
                                  "You are in a highly secure area.",
                                  style: TextStyle(color: Color(0xFF9E9E9E)),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    _featureIconCard(
                      icon: Icons.warning,
                      title: "SOS Alert",
                      description: "Instant help",
                      footer: "Emergency",
                      color: const Color(0xFFFF1744), // Vibrant Red
                      onTap: () {
                        Navigator.pushNamed(context, '/sos');
                      },
                    ),
                    _featureIconCard(
                      icon: Icons.people_alt,
                      title: "Companion",
                      description: "Live track sharing",
                      footer: "Start Mode",
                      color: const Color(0xFF4A5DFF), // Deep Purple
                      onTap: () {
                        Navigator.pushNamed(context, '/companion_mode');
                      },
                    ),
                    _featureIconCard(
                      icon: Icons.report_gmailerrorred_rounded,
                      title: "Report Hazard",
                      description: "Help community",
                      footer: "Submit Now",
                      color: const Color(0xFFFBBC04), // Vibrant Yellow/Orange
                      onTap: () {
                        Navigator.pushNamed(context, '/hazard_report');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 FOOTER (Modern standard navigation layout)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF130300), Color(0xFF1F0400)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0x33E8340A)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22E8340A),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Journey History (Left)
                    _footerItem(
                      icon: Icons.history,
                      label: "History",
                      onTap: () {
                        // Navigate to journey history
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Journey History - Coming Soon!"),
                          ),
                        );
                      },
                    ),

                    // Emergency Contacts (Center)
                    _footerItem(
                      icon: Icons.emergency,
                      label: "Emergency",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmergencyContactsScreen(),
                          ),
                        );
                      },
                    ),

                    // Profile (Right)
                    _footerItem(
                      icon: Icons.person,
                      label: "Profile",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

  // 🔹 CONTACT ITEM WIDGET
  Widget _contactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.white54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 FOOTER ITEM WIDGET
  Widget _footerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 26),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  // 🔹 PREMIUM FEATURE CARD WIDGET
  Widget _featureIconCard({
    required IconData icon,
    required String title,
    required String description,
    required String footer,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _PremiumCard(
      icon: icon,
      title: title,
      description: description,
      footer: footer,
      color: color,
      onTap: onTap,
    );
  }



  // 🔹 SHOW ABOUT DIALOG
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A0400), Color(0xFF0A0A0A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE8340A).withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8340A).withOpacity(0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8340A).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE8340A).withOpacity(0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.info,
                        color: Color(0xFFE8340A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "About SafeRoute",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white54),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Accent line
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE8340A).withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                const Text(
                  "Empowering Women's Safety",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8340A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "SafeRoute is an AI-powered navigation app designed specifically for women's safety. Our intelligent system analyzes multiple safety factors including lighting conditions, crowd density, transport availability, and historical safety data to provide the safest routes for your journeys.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Features include real-time SafeScore calculations, emergency SOS alerts with live location sharing, public transport frequency monitoring, and comprehensive safety analytics.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 24),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8340A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Got it!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 SHOW CONTACT DIALOG
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A0400), Color(0xFF0A0A0A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE8340A).withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE8340A).withOpacity(0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8340A).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE8340A).withOpacity(0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.contact_mail,
                        color: Color(0xFFE8340A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white54),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Accent line
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE8340A).withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Contact items
                _contactItem(
                  icon: Icons.email_outlined,
                  title: "Email Support",
                  subtitle: "support@saferoute.com",
                  color: const Color(0xFFE8340A),
                ),
                Divider(
                  height: 24,
                  color: Colors.white.withOpacity(0.08),
                ),
                _contactItem(
                  icon: Icons.phone_outlined,
                  title: "Emergency Helpline",
                  subtitle: "+1 (555) 123-SAFE",
                  color: const Color(0xFF00E676),
                ),
                Divider(
                  height: 24,
                  color: Colors.white.withOpacity(0.08),
                ),
                _contactItem(
                  icon: Icons.location_on_outlined,
                  title: "Office Address",
                  subtitle: "123 Safety Street, Secure City, SC 12345",
                  color: const Color(0xFFFFB03B),
                ),

                const SizedBox(height: 24),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8340A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 SIDE NAVIGATION DRAWER
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A0400), Color(0xFF0A0A0A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(bottom: BorderSide(color: Color(0xFFE8340A), width: 2)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A0400),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE8340A), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.shield,
                      size: 30,
                      color: Color(0xFFE8340A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "SafeRoute",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _drawerItem(
            icon: Icons.info_outline,
            title: "About Us",
            onTap: () {
              Navigator.pop(context); // Close drawer
              _showAboutDialog(context);
            },
          ),
          _drawerItem(
            icon: Icons.contact_support_outlined,
            title: "Contact Us",
            onTap: () {
              Navigator.pop(context); // Close drawer
              _showContactDialog(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE8340A), size: 26),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Animated Women Safety Banner
// ──────────────────────────────────────────────────────────────────────────
class _WomenSafetyBanner extends StatefulWidget {
  const _WomenSafetyBanner();

  @override
  State<_WomenSafetyBanner> createState() => _WomenSafetyBannerState();
}

class _WomenSafetyBannerState extends State<_WomenSafetyBanner>
    with TickerProviderStateMixin {
  static const _slogans = [
    ('Her voice matters.', 'Speak up. We listen.'),
    ('Safety is her right.', 'Navigate with confidence.'),
    ('No fear. Just freedom.', 'Every route, secured for her.'),
    ('She deserves to walk.', 'Safe paths, day and night.'),
    ('Empowered. Protected.', 'Your shield in every journey.'),
  ];

  int _index = 0;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fade  = CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _pulse = Tween<double>(begin: 1.0, end: 1.15)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _textController.forward();
    _startCycle();
  }

  void _startCycle() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _textController.reverse().then((_) {
        if (!mounted) return;
        setState(() => _index = (_index + 1) % _slogans.length);
        _textController.forward().then((_) => _startCycle());
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (headline, sub) = _slogans[_index];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0000),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8340A), width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55E8340A),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pulsing shield icon
          ScaleTransition(
            scale: _pulse,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5722), Color(0xFFE8340A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x88E8340A),
                    blurRadius: 14,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(width: 18),
          // Fading text
          Expanded(
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sub,
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
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
}

// ──────────────────────────────────────────────────────────────────────────
class _PremiumCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String footer;
  final Color color;
  final VoidCallback onTap;

  const _PremiumCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.footer,
    required this.color,
    required this.onTap,
  });

  @override
  State<_PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<_PremiumCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 6.0, end: 18.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF101010), // Near-black background
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _pressed
                      ? const Color(0xFFFF5722)
                      : const Color(0xFFE8340A),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8340A).withAlpha(
                        (_pressed ? 120 : (_glowAnimation.value * 3.5).round())),
                    blurRadius: _pressed ? 24 : _glowAnimation.value,
                    spreadRadius: _pressed ? 2 : 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Circular gradient icon (AMD style) ──
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF5722), Color(0xFFE8340A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8340A).withAlpha(100),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 22),
                  ),

                  const SizedBox(height: 7),

                  // ── Bold white title ──
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 3),

                  // ── Subtle grey description ──
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 10,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // ── Red footer label ──
                  Text(
                    widget.footer,
                    style: const TextStyle(
                      color: Color(0xFFE8340A),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
