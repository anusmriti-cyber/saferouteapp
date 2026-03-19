import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          _buildSectionHeader("Account"),
          _buildSettingTile(Icons.person_outline, "Edit Profile", () {}),
          _buildSettingTile(Icons.notifications_none_rounded, "Notifications", () {}),
          
          _buildSectionHeader("Safety"),
          SwitchListTile(
            title: const Text("Auto-SOS on fall detection"),
            value: true,
            onChanged: (val) {},
            secondary: const Icon(Icons.emergency_outlined),
          ),
          SwitchListTile(
            title: const Text("Low lighting alerts"),
            value: true,
            onChanged: (val) {},
            secondary: const Icon(Icons.wb_sunny_outlined),
          ),

          _buildSectionHeader("Basics"),
          _buildSettingTile(Icons.help_outline_rounded, "Help & Support", () {}),
          _buildSettingTile(Icons.info_outline_rounded, "About SafeRoute", () {}),
          
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
              child: const Text("LOGOUT"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
