import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'SkyCast';
  static const String appVersion = '1.0.0';

  // Modern Color Palette
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color backgroundColor = Color(0xFF0F172A); // Dark slate
  static const Color surfaceColor = Color(0xFF1E293B); // Slate 800
  static const Color cardColor = Color(0xFF334155); // Slate 700
  static const Color textPrimaryColor = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondaryColor = Color(0xFFCBD5E1); // Slate 300
  static const Color textTertiaryColor = Color(0xFF94A3B8); // Slate 400
  static const Color errorColor = Color(0xFFEF4444); // Red 500
  static const Color successColor = Color(0xFF10B981); // Emerald 500
  static const Color warningColor = Color(0xFFF59E0B); // Amber 500

  // Glass morphism colors
  static const Color glassColor = Color(0x1AFFFFFF);
  static const Color glassBorderColor = Color(0x33FFFFFF);

  // Modern Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient weatherCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33334155), Color(0x1A475569)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
  );

  static const LinearGradient temperatureGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
  );

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 30.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;
  static const double fontSizeTemperature = 60.0;

  // Icon Sizes
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 30.0;
  static const double iconSizeLarge = 40.0;
  static const double iconSizeXLarge = 80.0;

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // API
  static const String weatherApiKey = 'e2082ee185cdd39a3b380b4a571acf99';
  static const String weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';
}
