import 'package:flutter/material.dart';

class SafeScoreIndicator extends StatelessWidget {
  final double score;
  final double size;

  const SafeScoreIndicator({
    super.key,
    required this.score,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    Color color = _getColor();
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          score.toInt().toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    if (score >= 80) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}
