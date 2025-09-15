import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_gradients.dart';
import '../../utils/app_utils.dart';

class ModernWeatherCard extends StatelessWidget {
  final String location;
  final String temperature;
  final String condition;
  final String weatherIcon;
  final VoidCallback? onTap;

  const ModernWeatherCard({
    super.key,
    required this.location,
    required this.temperature,
    required this.condition,
    required this.weatherIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          gradient: AppGradients.cardGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                gradient: AppGradients.glassGradient,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location and Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.more_vert,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Date
                  Text(
                    AppDateUtils.formatDate(DateTime.now()),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Weather Icon and Temperature
                  Row(
                    children: [
                      // Weather Icon Container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppGradients.backgroundGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            WeatherUtils.getWeatherEmoji(weatherIcon),
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Temperature
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              temperature,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w300,
                                color: AppColors.primaryBlue,
                                height: 1,
                              ),
                            ),
                            Text(
                              condition,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Weather Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherStat(Icons.air, '12 km/h', 'Wind'),
                      _buildWeatherStat(Icons.opacity, '20%', 'Humidity'),
                      _buildWeatherStat(
                        Icons.visibility,
                        '10 km',
                        'Visibility',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}

class WeatherForecastCard extends StatelessWidget {
  final String day;
  final String temperature;
  final String weatherIcon;
  final bool isSelected;

  const WeatherForecastCard({
    super.key,
    required this.day,
    required this.temperature,
    required this.weatherIcon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Make the card responsive to screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 400 ? 65.0 : 60.0;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        gradient: isSelected
            ? AppGradients.primaryGradient
            : AppGradients.forecastGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF2D3748), // Darker for better readability
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              WeatherUtils.getWeatherEmoji(weatherIcon),
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            temperature,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF1A202C), // Very dark for readability
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ModernWeatherBackground extends StatelessWidget {
  final Widget child;

  const ModernWeatherBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
      child: Stack(
        children: [
          // Background pattern/decoration
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
