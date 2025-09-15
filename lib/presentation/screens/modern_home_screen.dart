import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../controllers/weather_controller.dart';
import '../../constants/app_constants.dart';
import '../../utils/app_utils.dart';
import '../../widgets/custom_widgets.dart';
import '../widgets/modern_weather_widgets.dart';
import 'detailed_weather_screen.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen>
    with TickerProviderStateMixin {
  final WeatherController weatherController = Get.put(WeatherController());
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Selected time state
  int _selectedTimeIndex = 1; // Default to second item (current time)

  // Realistic hourly weather data (simulated for 5 hours)
  final List<int> _hourlyTemperatures = [20, 22, 25, 28, 27]; // 5 hours
  final List<String> _hourlyConditions = [
    'Clear',
    'Clear',
    'Partly Cloudy',
    'Sunny',
    'Partly Cloudy',
  ];
  final List<String> _hourlyDescriptions = [
    'Clear sky',
    'Mostly clear',
    'Partly cloudy',
    'Sunny weather',
    'Few clouds',
  ];

  // Additional hourly data for dynamic weather insights
  final List<int> _hourlyHumidity = [68, 65, 62, 58, 60]; // % values
  final List<double> _hourlyWindSpeed = [
    8.5,
    12.3,
    15.2,
    18.7,
    14.1,
  ]; // km/h values
  final List<int> _hourlyPressure = [
    1010,
    1013,
    1015,
    1018,
    1014,
  ]; // hPa values
  final List<int> _hourlyUvIndex = [3, 6, 8, 9, 5]; // UV index values
  final List<String> _hourlyUvDescription = [
    'Moderate',
    'High',
    'Very High',
    'Very High',
    'Moderate',
  ];

  // Map related variables
  GoogleMapController? _mapController;
  bool _showMap = false;
  LatLng? _selectedLocation;
  String _selectedAddress = 'Tap on map to select location';
  bool _isLoadingAddress = false;
  static const LatLng _defaultLocation = LatLng(
    23.8103,
    90.4125,
  ); // Dhaka, Bangladesh
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    // Listen for weather updates to sync hourly data
    ever(weatherController.currentWeather, (weather) {
      if (weather != null) {
        _updateHourlyDataFromWeather();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    if (_searchController.text.trim().isNotEmpty) {
      // Clear any existing errors
      weatherController.clearError();

      // Show loading state immediately
      print('Searching for: ${_searchController.text.trim()}');

      // Call the weather API
      weatherController
          .getWeatherByCity(_searchController.text.trim())
          .then((_) {
            // Update hourly arrays with real weather data
            if (weatherController.hasWeather && !weatherController.hasError) {
              _updateHourlyDataFromWeather();
            }

            // Update hourly arrays with real weather data
            if (weatherController.hasWeather && !weatherController.hasError) {
              final weather = weatherController.currentWeather.value!;
              setState(() {
                // Update temperature array based on real weather
                final baseTemp = weather.temperature.round();
                _hourlyTemperatures[0] = baseTemp - 2;
                _hourlyTemperatures[1] = baseTemp; // Current time
                _hourlyTemperatures[2] = baseTemp + 1;
                _hourlyTemperatures[3] = baseTemp + 3;
                _hourlyTemperatures[4] = baseTemp - 1;

                // Update conditions to match current weather
                for (int i = 0; i < _hourlyConditions.length; i++) {
                  _hourlyConditions[i] = weather.weatherMain;
                }

                // Update descriptions to match current weather
                for (int i = 0; i < _hourlyDescriptions.length; i++) {
                  _hourlyDescriptions[i] = weather.weatherDescription;
                }

                // Update humidity with realistic variations
                final baseHumidity = weather.humidity.round();
                _hourlyHumidity[0] = baseHumidity + 3;
                _hourlyHumidity[1] = baseHumidity; // Current time
                _hourlyHumidity[2] = baseHumidity - 2;
                _hourlyHumidity[3] = baseHumidity - 5;
                _hourlyHumidity[4] = baseHumidity - 3;

                // Update wind speed with realistic variations
                final baseWind = weather.windSpeed;
                _hourlyWindSpeed[0] = baseWind - 1.5;
                _hourlyWindSpeed[1] = baseWind; // Current time
                _hourlyWindSpeed[2] = baseWind + 2.0;
                _hourlyWindSpeed[3] = baseWind + 4.5;
                _hourlyWindSpeed[4] = baseWind - 0.8;

                // Update pressure with realistic variations
                final basePressure = weather.pressure.round();
                _hourlyPressure[0] = basePressure - 2;
                _hourlyPressure[1] = basePressure; // Current time
                _hourlyPressure[2] = basePressure + 3;
                _hourlyPressure[3] = basePressure + 5;
                _hourlyPressure[4] = basePressure + 1;
              });
            }

            // Clear the search input after successful search
            _searchController.clear();

            // Show success feedback
            if (weatherController.hasWeather && !weatherController.hasError) {
              Get.snackbar(
                'Location Found',
                'Weather data updated for ${weatherController.currentLocation.value}',
                backgroundColor: const Color(0xFF4A90E2),
                colorText: Colors.white,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            }
          })
          .catchError((error) {
            // Show error feedback
            Get.snackbar(
              'Search Failed',
              'Could not find weather data for "${_searchController.text.trim()}". Please try a different city name.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              icon: const Icon(Icons.error, color: Colors.white),
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
          });
    } else {
      // Show message for empty search
      Get.snackbar(
        'Empty Search',
        'Please enter a city or district name',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: const Icon(Icons.warning, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Update hourly arrays with real weather data
  void _updateHourlyDataFromWeather() {
    final weather = weatherController.currentWeather.value;
    if (weather != null) {
      setState(() {
        // Update arrays with real weather data (spread across hours)
        final baseTemp = weather.temperature.round();
        _hourlyTemperatures[0] = baseTemp - 2;
        _hourlyTemperatures[1] = baseTemp; // Current time
        _hourlyTemperatures[2] = baseTemp + 1;
        _hourlyTemperatures[3] = baseTemp + 3;
        _hourlyTemperatures[4] = baseTemp - 1;

        // Update conditions based on current weather
        for (int i = 0; i < _hourlyConditions.length; i++) {
          _hourlyConditions[i] = weather.weatherMain;
        }

        // Update descriptions
        for (int i = 0; i < _hourlyDescriptions.length; i++) {
          _hourlyDescriptions[i] = weather.weatherDescription;
        }

        // Update humidity with variations
        final baseHumidity = weather.humidity.round();
        _hourlyHumidity[0] = baseHumidity + 3;
        _hourlyHumidity[1] = baseHumidity; // Current time
        _hourlyHumidity[2] = baseHumidity - 2;
        _hourlyHumidity[3] = baseHumidity - 5;
        _hourlyHumidity[4] = baseHumidity - 3;

        // Update wind speed with variations
        final baseWind = weather.windSpeed;
        _hourlyWindSpeed[0] = baseWind - 1.5;
        _hourlyWindSpeed[1] = baseWind; // Current time
        _hourlyWindSpeed[2] = baseWind + 2.0;
        _hourlyWindSpeed[3] = baseWind + 4.5;
        _hourlyWindSpeed[4] = baseWind - 0.8;

        // Update pressure with variations
        final basePressure = weather.pressure.round();
        _hourlyPressure[0] = basePressure - 2;
        _hourlyPressure[1] = basePressure; // Current time
        _hourlyPressure[2] = basePressure + 3;
        _hourlyPressure[3] = basePressure + 5;
        _hourlyPressure[4] = basePressure + 1;
      });
    }
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
              Color(0xFF4A90E2), // Beautiful sky blue
              Color(0xFF7B68EE), // Medium slate blue
              Color(0xFF9966CC), // Amethyst purple
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -100,
              right: -100,
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
            Positioned(
              top: 100,
              left: -50,
              child: Container(
                width: 120,
                height: 120,
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
            Positioned(
              bottom: 100,
              right: -80,
              child: Container(
                width: 160,
                height: 160,
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
            SafeArea(
              child: Obx(() {
                if (weatherController.isInitialLoading) {
                  return const LoadingWidget(
                    message: 'Loading weather data...',
                    color: Colors.white,
                  );
                }

                if (weatherController.hasError) {
                  return _buildErrorState();
                }

                return RefreshIndicator(
                  onRefresh: weatherController.refreshWeather,
                  color: Colors.white,
                  backgroundColor: const Color(0xFF5A7FFF),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          _buildAppBar(),
                          _buildSearchBar(),
                          if (weatherController.hasWeather) ...[
                            _buildMainWeatherCard(),
                            _buildTodayForecast(),
                            _buildWeatherInsights(),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
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
              Text(
                'SkyCast',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Your Personal Weather Assistant',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.my_location,
                onPressed: weatherController.getCurrentLocationWeather,
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.refresh,
                onPressed: weatherController.refreshWeather,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _searchWeather(),
        style: const TextStyle(
          color: Color(0xFF4A5568), // Lighter than before but still readable
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search for a city...',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF), // Lighter hint text
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9CA3AF), // Lighter icon
          ),
          suffixIcon: Obx(() {
            if (weatherController.isLoading.value) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4A90E2),
                    ),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              );
            }
            return IconButton(
              onPressed: _searchWeather,
              icon: const Icon(
                Icons.arrow_forward,
                color: Color(0xFF4A90E2),
                size: 22,
              ),
            );
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMainWeatherCard() {
    final weather = weatherController.currentWeather.value!;
    final selectedHour = DateTime.now().hour + _selectedTimeIndex - 1;

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Stack(
        children: [
          // Background with enhanced glass effect
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.2),
                  const Color(0xFFF0F8FF).withOpacity(0.25),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _showMap ? _buildMapContent() : _buildWeatherContent(),
          ),
          // Floating action button for detailed view
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Get.to(() => const DetailedWeatherScreen()),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Weather content for main card
  Widget _buildWeatherContent() {
    final weather = weatherController.currentWeather.value!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          weather.fullLocation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedTimeIndex == 1
                        ? 'Now, ${_getCurrentTime()}'
                        : _getSelectedTimeLabel(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              WeatherUtils.getWeatherEmoji(
                _hourlyConditions[_selectedTimeIndex],
              ),
              style: const TextStyle(fontSize: 60),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_hourlyTemperatures[_selectedTimeIndex]}°C',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: -2,
                  ),
                ),
                Text(
                  _hourlyDescriptions[_selectedTimeIndex],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Feels like ${_hourlyTemperatures[_selectedTimeIndex] + 2}°C',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _buildQuickStat(
                  'Humidity',
                  '${_hourlyHumidity[_selectedTimeIndex]}%',
                ),
                const SizedBox(height: 8),
                _buildQuickStat(
                  'Wind',
                  '${_hourlyWindSpeed[_selectedTimeIndex].toStringAsFixed(1)} km/h',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Map content for main card
  Widget _buildMapContent() {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4A90E2).withOpacity(0.8),
                    const Color(0xFF7B68EE).withOpacity(0.6),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Temporary map placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 60,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Interactive Map',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap locations below to select',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sample location buttons
                  Positioned(
                    bottom: 80,
                    left: 20,
                    child: _buildLocationButton(
                      'Dhaka, Bangladesh',
                      const LatLng(23.8103, 90.4125),
                    ),
                  ),
                  Positioned(
                    bottom: 120,
                    right: 30,
                    child: _buildLocationButton(
                      'New York, USA',
                      const LatLng(40.7128, -74.0060),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 50,
                    child: _buildLocationButton(
                      'London, UK',
                      const LatLng(51.5074, -0.1278),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 40,
                    child: _buildLocationButton(
                      'Tokyo, Japan',
                      const LatLng(35.6762, 139.6503),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Location info overlay
          if (_selectedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoadingAddress)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Finding address...',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      )
                    else
                      Text(
                        _selectedAddress,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _confirmLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Use This Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Close button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showMap = false;
                  _selectedLocation = null;
                  _markers.clear();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
          // Instructions overlay
          if (_selectedLocation == null)
            Positioned(
              top: 12,
              left: 12,
              right: 50,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Tap anywhere on the map to select location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.9,
        ), // More opaque for better text visibility
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748), // Darker for better readability
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF4A5568), // Darker for better readability
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedTimeLabel() {
    final now = DateTime.now();
    final selectedHour = (now.hour + _selectedTimeIndex - 1) % 24;
    final selectedTime = DateTime(now.year, now.month, now.day, selectedHour);

    if (_selectedTimeIndex == 0) {
      return '1 hour ago';
    } else if (_selectedTimeIndex > 1) {
      final hoursAhead = _selectedTimeIndex - 1;
      return '$hoursAhead hour${hoursAhead > 1 ? 's' : ''} ahead';
    }
    return 'Now';
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  Widget _buildTodayForecast() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const DetailedWeatherScreen()),
                  child: Row(
                    children: [
                      Text(
                        '7-Day Forecasts',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(0.8),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 400 ? 16 : 8,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                final cardWidth =
                    (MediaQuery.of(context).size.width - 80) / 5.5;
                return Container(
                  width: cardWidth.clamp(60.0, 72.0),
                  margin: EdgeInsets.only(
                    right: index < 4 ? 12 : 0,
                    left: index == 0 ? 4 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimeIndex = index;
                      });
                    },
                    child: WeatherForecastCard(
                      day: _getHourLabel(index),
                      temperature: '${_hourlyTemperatures[index]}°',
                      weatherIcon: _hourlyConditions[index],
                      isSelected: _selectedTimeIndex == index,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyForecast() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '7-Day Forecasts',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade300,
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Get.to(() => const DetailedWeatherScreen()),
                child: _buildWeeklyForecastItem(index),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildWeeklyForecastItem(int index) {
    final days = ['Today', 'Tomorrow', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final temps = [
      '21°/17°',
      '24°/18°',
      '26°/19°',
      '23°/16°',
      '22°/15°',
      '25°/18°',
      '27°/20°',
    ];
    final conditions = [
      'Thunderstorms',
      'Mostly Clear',
      'Sunny',
      'Partly Clear',
      'Partly Clear',
      'Sunny',
      'Mostly Clear',
    ];
    final weatherTypes = [
      'Thunderstorm',
      'Clear',
      'Clear',
      'Clouds',
      'Clouds',
      'Clear',
      'Clear',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              days[index],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            WeatherUtils.getWeatherEmoji(weatherTypes[index]),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              conditions[index],
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
          Text(
            temps[index],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppConstants.paddingLarge),
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 80,
              color: AppConstants.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              weatherController.errorMessage.value,
              style: const TextStyle(
                fontSize: 16,
                color: AppConstants.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: weatherController.getCurrentLocationWeather,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHourLabel(int index) {
    final now = DateTime.now();
    final hour =
        (now.hour + index - 1) % 24; // Start from 1 hour before current

    if (hour == 0) return '12AM';
    if (hour < 12) return '${hour}AM';
    if (hour == 12) return '12PM';
    return '${hour - 12}PM';
  }

  Widget _buildWeatherInsights() {
    final weather = weatherController.currentWeather.value!;

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          // Weather details cards row
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  'Visibility',
                  weather.visibility.toStringAsFixed(1),
                  'km',
                  Icons.visibility,
                  const Color(0xFFFF6B35), // Vibrant orange
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  'Wind',
                  weather.windSpeed.toStringAsFixed(0),
                  'km/h',
                  Icons.air,
                  const Color(0xFF00CED1), // Dark turquoise
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  'Humidity',
                  weather.humidity.toStringAsFixed(0),
                  '%',
                  Icons.water_drop,
                  const Color(0xFF4169E1), // Royal blue
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInsightCard(
                  'Pressure',
                  weather.pressure.toStringAsFixed(0),
                  'hPa',
                  Icons.compress,
                  const Color(0xFF9370DB), // Medium purple
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Air quality section
          Container(
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.air, color: Colors.green, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Air Quality',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748), // Balanced darkness
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF32CD32), // Lime green
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF32CD32).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'AQI: 42',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748), // Balanced darkness
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Updated 1 hour ago',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4A5568), // Darker for visibility
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // AQI Progress bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF32CD32), // Lime green
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Good',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2D3748), // Dark for readability
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Moderate',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2D3748), // Dark for readability
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Unhealthy',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2D3748), // Dark for readability
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, const Color(0xFFFAFAFA)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz,
                color: AppConstants.textSecondaryColor,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF718096), // Softer gray, easier on eyes
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(
                    0xFF2D3748,
                  ), // Balanced - not too dark, not too light
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF718096), // Softer color for units
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Embedded Map Widget
  Widget _buildEmbeddedMap() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _defaultLocation,
                zoom: 10.0,
              ),
              onTap: _onMapTapped,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
            ),
            // Location info overlay
            if (_selectedLocation != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoadingAddress)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Finding address...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          _selectedAddress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Use This Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Close button
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showMap = false;
                    _selectedLocation = null;
                    _markers.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
            // Instructions overlay
            if (_selectedLocation == null)
              Positioned(
                top: 12,
                left: 12,
                right: 50,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Tap anywhere on the map to select location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Map callback methods
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected-location'),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      _isLoadingAddress = true;
      _selectedAddress = 'Finding address...';
    });

    _getAddressFromLatLng(location);
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _selectedAddress = _formatAddress(place);
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress =
            'Lat: ${location.latitude.toStringAsFixed(4)}, '
            'Lng: ${location.longitude.toStringAsFixed(4)}';
        _isLoadingAddress = false;
      });
    }
  }

  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    return addressParts.isNotEmpty
        ? addressParts.join(', ')
        : 'Unknown Location';
  }

  void _confirmLocation() async {
    if (_selectedLocation == null) return;

    try {
      // Show loading state
      setState(() {
        _isLoadingAddress = true;
      });

      // Get weather for the selected location
      await weatherController.getWeatherByCoordinates(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );

      // Update hourly data with new weather
      if (weatherController.hasWeather && !weatherController.hasError) {
        _updateHourlyDataFromWeather();
      }

      // Hide map and reset state
      setState(() {
        _showMap = false;
        _selectedLocation = null;
        _markers.clear();
        _isLoadingAddress = false;
      });

      // Show success message
      Get.snackbar(
        'Location Updated',
        'Weather data updated for selected location',
        backgroundColor: const Color(0xFF4A90E2),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      setState(() {
        _isLoadingAddress = false;
      });

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to get weather data for this location',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // Location button for map placeholder
  Widget _buildLocationButton(String locationName, LatLng location) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLocation = location;
          _selectedAddress = locationName;
          _isLoadingAddress = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: const Color(0xFF4A90E2), size: 16),
            const SizedBox(width: 4),
            Text(
              locationName.split(',')[0], // Show only city name
              style: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
