import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'weather_controller.dart';
import 'constants/app_constants.dart';
import 'utils/app_utils.dart';
import 'widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final WeatherController weatherController = Get.put(WeatherController());
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDurationLong,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    if (_searchController.text.trim().isNotEmpty) {
      weatherController.getWeatherByCity(_searchController.text.trim());
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: Obx(() {
            if (weatherController.isInitialLoading) {
              return const LoadingWidget(
                message: 'Loading weather data...',
                color: AppConstants.primaryColor,
              );
            }

            if (weatherController.hasError) {
              return CustomErrorWidget(
                message: weatherController.errorMessage.value,
                onRetry: () => weatherController.getCurrentLocationWeather(),
              );
            }

            return RefreshIndicator(
              onRefresh: weatherController.refreshWeather,
              color: AppConstants.primaryColor,
              backgroundColor: AppConstants.surfaceColor,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAppBar(),
                          _buildSearchBar(),
                          if (weatherController.hasWeather) ...[
                            _buildMainWeatherCard(),
                            _buildWeatherDetails(),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Loading overlay when searching
                  Obx(() {
                    if (weatherController.isLoading.value &&
                        weatherController.hasWeather) {
                      return Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Searching for weather data...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppConstants.primaryGradient.createShader(bounds),
                child: const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXXLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'Your Weather Companion',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: AppConstants.textSecondaryColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.my_location,
                onPressed: weatherController.getCurrentLocationWeather,
                tooltip: 'Current Location',
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.refresh,
                onPressed: weatherController.refreshWeather,
                tooltip: 'Refresh',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppConstants.glassGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.glassBorderColor, width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppConstants.textPrimaryColor),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildSearchBar() {
    return CustomTextField(
      controller: _searchController,
      hintText: 'Search for a city...',
      prefixIcon: Icons.search,
      onSubmitted: (_) => _searchWeather(),
      suffixIcon: Obx(() {
        if (weatherController.isLoading.value &&
            _searchController.text.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.all(8),
            width: 24,
            height: 24,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: AppConstants.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _searchWeather,
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildMainWeatherCard() {
    final weather = weatherController.currentWeather.value!;

    return CustomCard(
      glassMorphism: true,
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppDateUtils.formatDate(DateTime.now()),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: AppConstants.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppDateUtils.formatTime(DateTime.now()),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Location with Icon
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppConstants.accentColor,
                size: AppConstants.iconSizeSmall,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  weather.fullLocation,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Temperature and Weather Icon
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppConstants.temperatureGradient.createShader(bounds),
                      child: Text(
                        weather.temperatureString,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeTemperature,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      weather.weatherMain,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeXLarge,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimaryColor,
                      ),
                    ),
                    Text(
                      weather.weatherDescription,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.textSecondaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppConstants.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        WeatherUtils.getWeatherEmoji(weather.weatherMain),
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Feels like ${weather.feelsLikeString}',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondaryColor,
                        ),
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

  Widget _buildWeatherDetails() {
    final weather = weatherController.currentWeather.value!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppConstants.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Weather Details',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.paddingMedium),

        // Weather Details Grid
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppConstants.paddingMedium,
            crossAxisSpacing: AppConstants.paddingMedium,
            childAspectRatio: 1.2,
            children: [
              WeatherDetailCard(
                icon: Icons.air,
                value: weather.windSpeedString,
                label: 'Wind Speed',
                gradient: const LinearGradient(
                  colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                ),
              ),
              WeatherDetailCard(
                icon: Icons.opacity,
                value: weather.humidityString,
                label: 'Humidity',
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                ),
              ),
              WeatherDetailCard(
                icon: Icons.compress,
                value: weather.pressureString,
                label: 'Pressure',
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                ),
              ),
              WeatherDetailCard(
                icon: Icons.visibility,
                value: weather.visibilityString,
                label: 'Visibility',
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
              ),
              WeatherDetailCard(
                icon: Icons.thermostat_outlined,
                value: weather.maxTempString,
                label: 'Max Temp',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
              ),
              WeatherDetailCard(
                icon: Icons.thermostat_outlined,
                value: weather.minTempString,
                label: 'Min Temp',
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.paddingLarge),

        // Sunrise/Sunset Info
        CustomCard(
          glassMorphism: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSunTimeColumn(
                icon: Icons.wb_sunny_outlined,
                iconColor: const Color(0xFFF59E0B),
                label: 'Sunrise',
                time: AppDateUtils.formatSunriseSunset(weather.sunrise),
              ),
              Container(
                width: 1,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppConstants.textSecondaryColor.withOpacity(0.3),
                      AppConstants.textSecondaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              _buildSunTimeColumn(
                icon: Icons.nights_stay_outlined,
                iconColor: const Color(0xFF6366F1),
                label: 'Sunset',
                time: AppDateUtils.formatSunriseSunset(weather.sunset),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.paddingLarge),
      ],
    );
  }

  Widget _buildSunTimeColumn({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String time,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: AppConstants.iconSizeMedium,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: AppConstants.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}
