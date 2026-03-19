import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final Color color;

  const ReportButton({
    super.key,
    required this.onTap,
    this.label = "Report Hazard",
    this.icon = Icons.report_gmailerrorred_rounded,
    this.color = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
