import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  // Main Background Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryBlue, AppColors.lightBlue],
  );

  // Card Gradients
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFC)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.glassSurface, Color(0x20FFFFFF)],
  );

  // Weather Icon Gradients
  static const LinearGradient sunnyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBD38D), Color(0xFFF6AD55)],
  );

  static const LinearGradient cloudyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E0)],
  );

  static const LinearGradient rainyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF63B3ED), Color(0xFF4299E1)],
  );

  // Temperature Display Gradient
  static const LinearGradient temperatureGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryBlue, AppColors.accentBlue],
  );

  // Forecast Card Gradients
  static const LinearGradient forecastGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7FAFC), Color(0xFFEDF2F7)],
  );
}
