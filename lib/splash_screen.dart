import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to HomeScreen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Column(
        children: [
          const Spacer(flex: 1),

          // Responsive image
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Image.asset(
                'assets/images/images.png', // PNG logo path
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // // App name
          // const Text(
          //   'SkyCast',
          //   style: TextStyle(
          //     fontSize: 28,
          //     fontWeight: FontWeight.w700,
          //     color: Colors.white,
          //   ),
          // ),

          const Spacer(flex: 2),

          // Circular progress indicator
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),

          const SizedBox(height: 16),

          // Version text
          const Text(
            'version 1.0.0',
            style: TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 26),
        ],
      ),
    );
  }
}
