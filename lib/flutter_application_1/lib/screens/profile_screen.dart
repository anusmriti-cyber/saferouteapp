import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final userName = user?['name'] ?? 'User';
    final userEmail = user?['email'] ?? 'user@example.com';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A0400)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.wb_sunny_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Profile Card
                      HoverElevatedCard(
                        onTap: () {
                          // Can add profile edit navigation here
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A0400),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFE8340A), width: 1.5),
                                ),
                                child: const Icon(
                                  Icons.psychology, 
                                  size: 40, 
                                  color: Color(0xFFE8340A),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      userEmail,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8340A).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.verified_user, 
                                            color: Color(0xFFE8340A), 
                                            size: 14,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Verified Member",
                                            style: TextStyle(
                                              color: Colors.orange[300],
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Menu Items
                      _buildSwitchMenuItem(
                        icon: Icons.dark_mode,
                        title: "Dark Mode",
                        subtitle: isDarkMode ? "Enabled" : "Disabled",
                        value: isDarkMode,
                        onChanged: (val) {
                          setState(() {
                            isDarkMode = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: "Activity History",
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.bar_chart,
                        title: "Progress Reports",
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: "About SafeRoute",
                        onTap: () {},
                      ),

                      const SizedBox(height: 40),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            AuthService.logout();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8340A), // Home page accent color
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return HoverElevatedCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return HoverElevatedCard(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFFE8340A), // Brand active color
              activeTrackColor: const Color(0xFFE8340A).withOpacity(0.5),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Hover Elevated Card Widget
class HoverElevatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const HoverElevatedCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<HoverElevatedCard> createState() => _HoverElevatedCardState();
}

class _HoverElevatedCardState extends State<HoverElevatedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -5.0 : 0.0), // Elevated lift
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF2A2A2A) : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2E2E2E)),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFE8340A).withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
