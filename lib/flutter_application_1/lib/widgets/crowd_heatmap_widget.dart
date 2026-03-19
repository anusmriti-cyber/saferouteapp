import 'package:flutter/material.dart';

class CrowdHeatmapWidget extends StatelessWidget {
  final double density; // 0.0 to 1.0

  const CrowdHeatmapWidget({
    super.key,
    required this.density,
  });

  @override
  Widget build(BuildContext context) {
    Color color = _getColorForDensity(density);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.people_alt_rounded, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getTextForDensity(density),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.9),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: density,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForDensity(double density) {
    if (density < 0.3) return Colors.green;
    if (density < 0.7) return Colors.orange;
    return Colors.red;
  }

  String _getTextForDensity(double density) {
    if (density < 0.3) return "Low Crowd (Safe)";
    if (density < 0.7) return "Moderate Crowd";
    return "High Crowd (Alert)";
  }
}
