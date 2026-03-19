import 'package:flutter/material.dart';

class CompanionModeScreen extends StatefulWidget {
  const CompanionModeScreen({super.key});

  @override
  State<CompanionModeScreen> createState() => _CompanionModeScreenState();
}

class _CompanionModeScreenState extends State<CompanionModeScreen> {
  bool _isActive = false;

  void _toggleCompanionMode() {
    setState(() {
      _isActive = !_isActive;
    });
    
    String message = _isActive 
        ? "Companion Mode Active: Your live location is now being shared."
        : "Companion Mode Deactivated.";
        
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Companion Mode"),
        backgroundColor: Colors.transparent, // Core design
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0A), Color(0xFF1A0400)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(
                  Icons.people_alt_rounded, 
                  size: 100, 
                  color: _isActive ? const Color(0xFFE8340A) : Colors.grey[700],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Companion Mode",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Share your live journey with a trusted contact. They can track your progress and get alerted if you stray from your path or stop moving for too long.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E), // Darker cards
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isActive 
                          ? const Color(0xFFE8340A).withOpacity(0.5) 
                          : const Color(0xFF2E2E2E),
                      width: 2,
                    ),
                    boxShadow: _isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFFE8340A).withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isActive ? "LIVE TRACKING ACTIVE" : "TRACKING INACTIVE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isActive ? const Color(0xFFE8340A) : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isActive ? "Sharing with: Mom, Dad" : "Not sharing with anyone",
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _toggleCompanionMode,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _isActive 
                          ? Colors.transparent 
                          : const Color(0xFFE8340A),
                      foregroundColor: _isActive 
                          ? const Color(0xFFE8340A) 
                          : Colors.white,
                      side: BorderSide(
                        color: const Color(0xFFE8340A),
                        width: _isActive ? 2 : 0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _isActive ? "STOP SHARING" : "START SHARING",
                      style: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
