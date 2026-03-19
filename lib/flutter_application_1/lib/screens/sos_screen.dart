import 'package:flutter/material.dart';
import 'dart:async';
import '../services/sos_service.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  int _countdown = 3;
  Timer? _timer;
  bool _isSosTriggered = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _triggerSOS();
      }
    });
  }

  void _triggerSOS() {
    setState(() {
      _isSosTriggered = true;
    });
    SOSService().triggerSOS();
  }

  void _cancelSOS() {
    _timer?.cancel();
    SOSService().cancelSOS();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isSosTriggered ? Colors.red.shade900 : Colors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                _isSosTriggered ? "EMERGENCY ALERT SENT" : "SENDING EMERGENCY ALERT",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (!_isSosTriggered)
                Text(
                  "Alerting authorities in $_countdown...",
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
              const SizedBox(height: 80),
              if (!_isSosTriggered)
                GestureDetector(
                  onTap: _cancelSOS,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                  child: const Text("CLOSE"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
