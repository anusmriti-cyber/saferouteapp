import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;
  String _displayName = '';

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    _displayName = user?['name'] ?? 'User';
  }

  // ── EDIT PROFILE DIALOG ──────────────────────────────────────────────────
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _displayName);
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A0400), Color(0xFF0A0A0A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE8340A).withOpacity(0.35), width: 1.2),
                boxShadow: [BoxShadow(color: const Color(0xFFE8340A).withOpacity(0.18), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8340A).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE8340A).withOpacity(0.4)),
                          ),
                          child: const Icon(Icons.edit, color: Color(0xFFE8340A), size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Accent line
                    Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFFE8340A).withOpacity(0.7), Colors.transparent]))),
                    const SizedBox(height: 20),

                    // Name field
                    const Text('Display Name', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFE8340A)),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: const Color(0xFFE8340A).withOpacity(0.25)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE8340A), width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name cannot be empty' : null,
                    ),
                    const SizedBox(height: 10),

                    // Email (read-only)
                    const Text('Email', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161616),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline, color: Colors.white38, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AuthService.currentUser?['email'] ?? '',
                              style: const TextStyle(color: Colors.white54, fontSize: 14),
                            ),
                          ),
                          const Text('read-only', style: TextStyle(color: Colors.white24, fontSize: 11)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                setDialogState(() => isSaving = true);
                                try {
                                  final user = FirebaseAuth.instance.currentUser;
                                  await user?.updateDisplayName(nameController.text.trim());
                                  await user?.reload();
                                  if (mounted) {
                                    setState(() => _displayName = nameController.text.trim());
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Profile updated!'),
                                        backgroundColor: const Color(0xFFE8340A),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  setDialogState(() => isSaving = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8340A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          disabledBackgroundColor: const Color(0xFFE8340A).withOpacity(0.5),
                        ),
                        child: isSaving
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.4)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  // ── ABOUT DIALOG ─────────────────────────────────────────────────────────
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1A0400), Color(0xFF0A0A0A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE8340A).withOpacity(0.35), width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8340A).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8340A).withOpacity(0.4)),
                    ),
                    child: const Icon(Icons.info, color: Color(0xFFE8340A), size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(child: Text('About SafeRoute', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white))),
                  IconButton(onPressed: () => Navigator.of(ctx).pop(), icon: const Icon(Icons.close, color: Colors.white54)),
                ],
              ),
              const SizedBox(height: 16),
              Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFFE8340A).withOpacity(0.7), Colors.transparent]))),
              const SizedBox(height: 16),
              const Text('Empowering Women\'s Safety', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE8340A))),
              const SizedBox(height: 12),
              const Text(
                'SafeRoute is an AI-powered navigation app designed specifically for women\'s safety. Our intelligent system analyzes multiple safety factors including lighting conditions, crowd density, transport availability, and historical safety data to provide the safest routes for your journeys.',
                style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.6),
              ),
              const SizedBox(height: 8),
              const Text(
                'Features include real-time SafeScore calculations, emergency SOS alerts with live location sharing, public transport frequency monitoring, and comprehensive safety analytics.',
                style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.6),
              ),
              const SizedBox(height: 20),
              _dialogRow(Icons.tag, 'Version', '1.0.0'),
              const SizedBox(height: 8),
              _dialogRow(Icons.code, 'Built with', 'Flutter + Firebase'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8340A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Got it!', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE8340A), size: 16),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.white54, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ── ACTIVITY HISTORY BOTTOM SHEET ─────────────────────────────────────────
  void _showActivityHistory() {
    final activities = [
      {'icon': Icons.route, 'title': 'Safe route planned', 'subtitle': 'Home → City Mall', 'time': '2 hrs ago', 'color': const Color(0xFF00D2FF)},
      {'icon': Icons.shield, 'title': 'SafeScore scanned', 'subtitle': 'Sector 14, Near Park', 'time': 'Yesterday', 'color': const Color(0xFF00E676)},
      {'icon': Icons.warning_amber_rounded, 'title': 'Hazard reported', 'subtitle': 'Broken streetlight on MG Rd', 'time': '2 days ago', 'color': const Color(0xFFFFB03B)},
      {'icon': Icons.emergency, 'title': 'SOS triggered', 'subtitle': 'Alert sent to 3 contacts', 'time': '5 days ago', 'color': const Color(0xFFFF1744)},
      {'icon': Icons.directions_bus, 'title': 'Transport checked', 'subtitle': 'Bus Route 22 safety score', 'time': '1 week ago', 'color': const Color(0xFFFFB03B)},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF1A0400), Color(0xFF0A0A0A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: Color(0x44E8340A), width: 1)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  Icon(Icons.history, color: Color(0xFFE8340A), size: 22),
                  SizedBox(width: 10),
                  Text('Activity History', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: activities.length,
                separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.07), height: 16),
                itemBuilder: (_, i) {
                  final a = activities[i];
                  return Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: (a['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: (a['color'] as Color).withOpacity(0.3)),
                        ),
                        child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 3),
                            Text(a['subtitle'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(a['time'] as String, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PROGRESS REPORTS BOTTOM SHEET ─────────────────────────────────────────
  void _showProgressReports() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF1A0400), Color(0xFF0A0A0A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: Color(0x44E8340A), width: 1)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.bar_chart, color: Color(0xFFE8340A), size: 22),
                  SizedBox(width: 10),
                  Text('Progress Reports', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  _statCard('12', 'Routes\nPlanned', const Color(0xFF00D2FF)),
                  const SizedBox(width: 12),
                  _statCard('3', 'Hazards\nReported', const Color(0xFFFFB03B)),
                  const SizedBox(width: 12),
                  _statCard('87', 'Avg Safe\nScore', const Color(0xFF00E676)),
                ],
              ),
              const SizedBox(height: 20),

              const Text('This Week\'s Safety Summary', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),

              _progressRow('Safe Routes Used', 0.78, const Color(0xFF00D2FF), '78%'),
              const SizedBox(height: 12),
              _progressRow('Hazard Avoidance Rate', 0.91, const Color(0xFF00E676), '91%'),
              const SizedBox(height: 12),
              _progressRow('SOS Preparedness', 0.65, const Color(0xFFFFB03B), '65%'),
              const SizedBox(height: 12),
              _progressRow('Emergency Contacts Set', 1.0, const Color(0xFFE8340A), '100%'),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8340A).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8340A).withOpacity(0.2)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.emoji_events, color: Color(0xFFFFB03B), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You\'re in the top 15% of SafeRoute users this week! Keep staying safe.',
                        style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.3)),
          ],
        ),
      ),
    );
  }

  Widget _progressRow(String label, double value, Color color, String pct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            Text(pct, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Profile',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Profile Card — tap opens Edit Profile
                      HoverElevatedCard(
                        onTap: _showEditProfileDialog,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A0400),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFFE8340A), width: 1.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _displayName.isNotEmpty ? _displayName[0].toUpperCase() : 'U',
                                        style: const TextStyle(color: Color(0xFFE8340A), fontSize: 32, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8340A),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
                                      ),
                                      child: const Icon(Icons.edit, size: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _displayName,
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userEmail,
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8340A).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.verified_user, color: Color(0xFFE8340A), size: 14),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Verified Member',
                                            style: TextStyle(color: Colors.orange[300], fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text('Tap to edit profile', style: TextStyle(color: Colors.white30, fontSize: 11)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dark Mode toggle
                      _buildSwitchMenuItem(
                        icon: Icons.dark_mode,
                        title: 'Dark Mode',
                        subtitle: isDarkMode ? 'Enabled' : 'Disabled',
                        value: isDarkMode,
                        onChanged: (val) => setState(() => isDarkMode = val),
                      ),
                      const SizedBox(height: 12),

                      // Settings
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'Notifications, account, safety',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingScreen()),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Activity History
                      _buildMenuItem(
                        icon: Icons.history,
                        title: 'Activity History',
                        subtitle: 'Routes, scans & reports',
                        onTap: _showActivityHistory,
                      ),
                      const SizedBox(height: 12),

                      // Progress Reports
                      _buildMenuItem(
                        icon: Icons.bar_chart,
                        title: 'Progress Reports',
                        subtitle: 'Weekly stats & achievements',
                        onTap: _showProgressReports,
                      ),
                      const SizedBox(height: 12),

                      // About SafeRoute
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'About SafeRoute',
                        subtitle: 'Version, credits & mission',
                        onTap: _showAboutDialog,
                      ),

                      const SizedBox(height: 40),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                          label: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF1A1A1A),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                title: const Text('Logout?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white70)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE8340A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    child: const Text('Logout', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await AuthService.logout();
                              if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8340A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
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
    String subtitle = '',
    required VoidCallback onTap,
  }) {
    return HoverElevatedCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8340A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFE8340A), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 15),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8340A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFE8340A), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFFE8340A),
              activeTrackColor: const Color(0xFFE8340A).withOpacity(0.4),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hover Elevated Card ───────────────────────────────────────────────────
class HoverElevatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const HoverElevatedCard({super.key, required this.child, required this.onTap});

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
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF2A2A2A) : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _isHovered ? const Color(0xFFE8340A).withOpacity(0.35) : const Color(0xFF2E2E2E)),
            boxShadow: _isHovered
                ? [BoxShadow(color: const Color(0xFFE8340A).withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6))]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
