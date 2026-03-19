import 'package:flutter/material.dart';
import 'dart:math' as math;

class SafeScoreGauge extends StatefulWidget {
  final int score;
  final double size;

  const SafeScoreGauge({
    super.key,
    required this.score,
    this.size = 150,
  });

  @override
  State<SafeScoreGauge> createState() => _SafeScoreGaugeState();
}

class _SafeScoreGaugeState extends State<SafeScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(SafeScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.score / 100,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor(double value) {
    if (value >= 0.7) return const Color(0xFF00B894); // Safe Green
    if (value >= 0.4) return const Color(0xFFFF9500); // Warning Orange
    return const Color(0xFFFF4757); // Danger Red
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = _getScoreColor(_animation.value);
        return SizedBox(
          width: widget.size,
          height: widget.size / 1.5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _GaugePainter(
                  value: _animation.value,
                  color: color,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${( _animation.value * 100).toInt()}',
                    style: TextStyle(
                      fontSize: widget.size * 0.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _animation.value >= 0.7
                        ? "SAFE"
                        : (_animation.value >= 0.4 ? "MODERATE" : "RISKY"),
                    style: TextStyle(
                      fontSize: widget.size * 0.08,
                      fontWeight: FontWeight.w600,
                      color: color,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    const startAngle = -math.pi;
    const sweepAngle = math.pi;

    // Background track
    final trackPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Add glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value,
      false,
      glowPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
