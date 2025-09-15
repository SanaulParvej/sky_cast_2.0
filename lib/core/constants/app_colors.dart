import 'package:flutter/material.dart';

class AppColors {
  // Modern Blue Weather Palette
  static const Color primaryBlue = Color(0xFF5A7FFF); // Main blue
  static const Color lightBlue = Color(0xFF7B9CFF); // Light blue
  static const Color deepBlue = Color(0xFF4A6FFF); // Deep blue
  static const Color accentBlue = Color(0xFF6B8AFF); // Accent blue

  // Background Colors
  static const Color backgroundStart = Color(0xFF5A7FFF); // Gradient start
  static const Color backgroundEnd = Color(0xFF7B9CFF); // Gradient end
  static const Color cardBackground = Color(0xFFFFFFFF); // White cards
  static const Color glassSurface = Color(0x30FFFFFF); // Glass effect

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748); // Dark text
  static const Color textSecondary = Color(0xFF718096); // Gray text
  static const Color textOnBlue = Color(0xFFFFFFFF); // White on blue
  static const Color textMuted = Color(0xFFA0AEC0); // Muted text

  // Weather Status Colors
  static const Color sunny = Color(0xFFFBD38D); // Yellow/Orange
  static const Color cloudy = Color(0xFFCBD5E0); // Light gray
  static const Color rainy = Color(0xFF63B3ED); // Blue
  static const Color stormy = Color(0xFF805AD5); // Purple

  // UI Elements
  static const Color shadowColor = Color(0x1A000000); // Soft shadow
  static const Color dividerColor = Color(0xFFE2E8F0); // Light divider
  static const Color successColor = Color(0xFF48BB78); // Green
  static const Color warningColor = Color(0xFFED8936); // Orange
  static const Color errorColor = Color(0xFFE53E3E); // Red

  // Legacy/Additional Colors for compatibility
  static const Color surfaceColor = Color(0xFFFFFFFF); // White surface
  static const Color accentColor = Color(0xFF6B8AFF); // Same as accentBlue
  static const Color textPrimaryColor = Color(
    0xFF2D3748,
  ); // Same as textPrimary
  static const Color textSecondaryColor = Color(
    0xFF718096,
  ); // Same as textSecondary
  static const Color textTertiaryColor = Color(0xFFA0AEC0); // Same as textMuted
  static const Color backgroundColor = Color(
    0xFF5A7FFF,
  ); // Same as backgroundStart
  static const Color cardColor = Color(0xFFFFFFFF); // Same as cardBackground
  static const Color glassBorderColor = Color(
    0x30FFFFFF,
  ); // Same as glassSurface

  // Theme compatibility colors
  static const Color primaryColor = Color(0xFF5A7FFF); // Same as primaryBlue
  static const Color secondaryColor = Color(0xFF7B9CFF); // Same as lightBlue
}
