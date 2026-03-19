import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';
import '../utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.5, end: 1.05)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.05, end: 1.1)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50),
    ]).animate(_animationController);

    _rotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate to appropriate screen after 3 seconds
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        final nextScreen = AuthService.isLoggedIn
            ? const HomeScreen()
            : const LoginScreen();

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle background glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(20),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: const SafeRouteLogo(),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // App Name with animation
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ).createShader(bounds),
                        child: const Text(
                          'SAFEROUTE',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tagline
                      Text(
                        'SECURE • CONNECT • JOURNEY',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight.withAlpha(150),
                          letterSpacing: 4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Bottom subtle line
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(100),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SafeRouteLogo extends StatelessWidget {
  const SafeRouteLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceAlt,
            AppColors.background,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(30),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withAlpha(150),
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer decorative ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withAlpha(40),
                width: 1,
              ),
            ),
          ),
          // Inner icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withAlpha(200),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(80),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.security_rounded,
              size: 45,
              color: Colors.white,
            ),
          ),
          // Accent detail
          Positioned(
            top: 25,
            right: 25,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 16,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
