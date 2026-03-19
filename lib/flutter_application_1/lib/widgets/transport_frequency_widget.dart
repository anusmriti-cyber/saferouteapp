import 'package:flutter/material.dart';

class TransportFrequencyWidget extends StatelessWidget {
  final String transportName;
  final String frequency; // "High", "Medium", "Low"
  final String nextTime;

  const TransportFrequencyWidget({
    super.key,
    required this.transportName,
    required this.frequency,
    required this.nextTime,
  });

  @override
  Widget build(BuildContext context) {
    Color color = _getColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark Theme Card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E2E)), // Dark Border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Darker shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.directions_bus_rounded, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transportName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: Colors.white, // White text for title
                  ),
                ),
                Text(
                  "Next: $nextTime",
                  style: const TextStyle(
                    color: Colors.grey, // Grey for subtitle
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  frequency,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Frequency",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (frequency.toLowerCase()) {
      case 'high': return Colors.green;
      case 'medium': return Colors.orange;
      case 'low': return Colors.red;
      default: return Colors.blue;
    }
  }
}
