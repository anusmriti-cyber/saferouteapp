import 'package:flutter/material.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Safe Score Summary
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.green.shade50,
              child: Row(
                children: [
                  _buildStat(Icons.verified_user_rounded, "SafeScore", "92/100", Colors.green),
                  const Spacer(),
                  _buildStat(Icons.timer_outlined, "Time", "15 min", Colors.blue),
                  const Spacer(),
                  _buildStat(Icons.social_distance_rounded, "Distance", "1.2 km", Colors.purple),
                ],
              ),
            ),
            
            // Step by Step Directions (Mock)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Directions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  _buildDirectionItem("Start pointing North on Main St", true),
                  _buildDirectionItem("Turn right onto Oak Ave in 200m", false),
                  _buildDirectionItem("Cross the park (Well lit path)", true),
                  _buildDirectionItem("Continue for 500m to destination", false),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("START NAVIGATION"),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildDirectionItem(String text, bool isHighlight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: isHighlight ? Colors.green : Colors.grey),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: isHighlight ? Colors.black : Colors.black87)),
        ],
      ),
    );
  }
}
