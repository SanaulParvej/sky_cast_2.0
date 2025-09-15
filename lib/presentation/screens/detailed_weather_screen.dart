import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../../constants/app_constants.dart';
import '../../utils/app_utils.dart';
import '../widgets/modern_weather_widgets.dart';

class DetailedWeatherScreen extends StatefulWidget {
  const DetailedWeatherScreen({super.key});

  @override
  State<DetailedWeatherScreen> createState() => _DetailedWeatherScreenState();
}

class _DetailedWeatherScreenState extends State<DetailedWeatherScreen>
    with TickerProviderStateMixin {
  final WeatherController weatherController = Get.find<WeatherController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A7FFF), // Modern blue
              Color(0xFF7B9CFF), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildMainWeatherInfo(),
                  _buildHourlyForecast(),
                  _buildWeatherDetails(),
                  _buildAirQuality(),
                  _buildSunriseSunset(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                'Weather Details',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Obx(() {
                if (weatherController.hasWeather) {
                  return Text(
                    weatherController.currentWeather.value!.fullLocation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeatherInfo() {
    return Obx(() {
      if (!weatherController.hasWeather) {
        return const SizedBox.shrink();
      }

      final weather = weatherController.currentWeather.value!;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              WeatherUtils.getWeatherEmoji(weather.weatherMain),
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            Text(
              weather.temperatureString,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weather.weatherDescription,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Feels like ${weather.feelsLikeString}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHourlyForecast() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Hourly Forecast',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 24,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildHourlyCard(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyCard(int index) {
    final hour = (DateTime.now().hour + index) % 24;
    final temp = 20 + (index % 8);
    final isRaining = index % 5 == 0;

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.9,
        ), // More opaque for better text visibility
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            hour == 0
                ? '12AM'
                : hour > 12
                ? '${hour - 12}PM'
                : '${hour}AM',
            style: const TextStyle(
              color: Color(0xFF2D3748), // Dark for better visibility
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(isRaining ? '🌧️' : '☀️', style: const TextStyle(fontSize: 24)),
          Text(
            '${temp}°',
            style: const TextStyle(
              color: Color(0xFF1A202C), // Very dark for maximum readability
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weather Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C), // Very dark for better readability
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem('Humidity', '65%', Icons.water_drop),
              ),
              Expanded(
                child: _buildDetailItem('Wind Speed', '12 km/h', Icons.air),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem('Pressure', '1013 hPa', Icons.compress),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Visibility',
                  '10 km',
                  Icons.visibility,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem('UV Index', '6 (High)', Icons.wb_sunny),
              ),
              Expanded(
                child: _buildDetailItem('Dew Point', '18°C', Icons.opacity),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppConstants.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4A5568), // Darker for better visibility
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C), // Very dark for maximum readability
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQuality() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.air, color: AppConstants.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Air Quality',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A202C), // Very dark for better readability
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Good',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'AQI: 42',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C), // Very dark for better readability
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: const LinearGradient(
                colors: [
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(left: 50),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunriseSunset() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sun & Moon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C), // Very dark for better readability
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Sunrise',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(
                          0xFF4A5568,
                        ), // Darker for better visibility
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      '6:30 AM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(
                          0xFF1A202C,
                        ), // Very dark for maximum readability
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 60, color: Colors.grey.shade300),
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.nightlight, color: Colors.indigo, size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Sunset',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(
                          0xFF4A5568,
                        ), // Darker for better visibility
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      '7:45 PM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(
                          0xFF1A202C,
                        ), // Very dark for maximum readability
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
