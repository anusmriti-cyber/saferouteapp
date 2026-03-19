import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SOSHoldButton extends StatefulWidget {
  final VoidCallback onTriggered;
  final Duration holdDuration;

  const SOSHoldButton({
    super.key,
    required this.onTriggered,
    this.holdDuration = const Duration(seconds: 2),
  });

  @override
  State<SOSHoldButton> createState() => _SOSHoldButtonState();
}

class _SOSHoldButtonState extends State<SOSHoldButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHolding = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerSOS();
      }
    });
  }

  void _triggerSOS() {
    HapticFeedback.vibrate();
    widget.onTriggered();
    _reset();
  }

  void _reset() {
    setState(() {
      _isHolding = false;
    });
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() => _isHolding = true);
        _controller.forward();
        // Periodic haptic feedback while holding
        _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          if (_isHolding) {
            HapticFeedback.lightImpact();
          } else {
            timer.cancel();
          }
        });
      },
      onLongPressEnd: (_) {
        _reset();
        _timer?.cancel();
      },
      child: AnimatedScale(
        scale: _isHolding ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Ring Progress
            SizedBox(
              width: 80,
              height: 80,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: _controller.value,
                    strokeWidth: 6,
                    backgroundColor: Colors.red.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  );
                },
              ),
            ),
            // The Button
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(_isHolding ? 0.6 : 0.3),
                    blurRadius: _isHolding ? 20 : 10,
                    spreadRadius: _isHolding ? 5 : 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
