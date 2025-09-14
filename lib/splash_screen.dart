import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_dimensions.dart';
import 'core/constants/app_gradients.dart';
import 'core/constants/app_typography.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Logo scale animation with bounce effect
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Text fade animation
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Pulse animation for glow effect
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation animation for background elements
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Slide animation for loading indicator
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Start animations with delays
    _rotationController.repeat();
    _logoController.forward();

    Timer(const Duration(milliseconds: 600), () {
      _textController.forward();
      _pulseController.repeat(reverse: true);
    });

    // Navigate to HomeScreen after 4 seconds
    Timer(const Duration(seconds: 4), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2), // Beautiful sky blue
              Color(0xFF7B68EE), // Medium slate blue
              Color(0xFF9966CC), // Amethyst purple
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildBackgroundElements(),

            // Main content
            Center(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLarge,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // Animated Logo with Enhanced Glow Effect
                      _buildAnimatedLogo(),

                      const SizedBox(height: AppDimensions.paddingXXLarge),

                      // Animated App Name with Gradient Text
                      _buildAnimatedAppName(),

                      const SizedBox(height: AppDimensions.paddingMedium),

                      // Animated Tagline
                      _buildAnimatedTagline(),

                      const Spacer(flex: 3),

                      // Enhanced Loading Indicator
                      _buildLoadingIndicator(),

                      const SizedBox(height: AppDimensions.paddingXLarge),

                      // Version text with fade effect
                      _buildVersionText(),

                      const SizedBox(height: AppDimensions.paddingXXLarge),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Top right floating element
            Positioned(
              top: -50,
              right: -50,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom left floating element
            Positioned(
              bottom: -100,
              left: -100,
              child: Transform.rotate(
                angle: -_rotationAnimation.value,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD700).withOpacity(0.2),
                        const Color(0xFFFFD700).withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Center floating element
            Positioned(
              top: 150,
              right: -80,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 0.5,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF87CEEB).withOpacity(0.2),
                        const Color(0xFF87CEEB).withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _logoAnimation.value,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF7B68EE),
                      Color(0xFF9966CC),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.4),
                      blurRadius: 30 * _pulseAnimation.value,
                      spreadRadius: 15 * _pulseAnimation.value,
                    ),
                    BoxShadow(
                      color: const Color(0xFF7B68EE).withOpacity(0.3),
                      blurRadius: 20 * _pulseAnimation.value,
                      spreadRadius: 10 * _pulseAnimation.value,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.cloud_outlined,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedAppName() {
    return FadeTransition(
      opacity: _textAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _textController, curve: Curves.easeOut),
            ),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFF0F8FF), Colors.white],
          ).createShader(bounds),
          child: Text(
            AppStrings.appName,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 8,
                  color: Colors.black26,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline() {
    return FadeTransition(
      opacity: _textAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _textController, curve: Curves.easeOut),
            ),
        child: Text(
          AppStrings.appTagline,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
            color: Colors.white.withOpacity(0.9),
            shadows: const [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _textAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFF0F8FF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: CircularProgressIndicator(
                  color: Color(0xFF4A90E2),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Text(
              AppStrings.loading,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 1,
                shadows: const [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black26,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionText() {
    return FadeTransition(
      opacity: _textAnimation,
      child: Text(
        'Version ${AppStrings.appVersion}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
