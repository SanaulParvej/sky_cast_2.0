import 'package:get/get.dart';
import '../../models/weather_model.dart';
import '../../services/weather_service.dart';
import '../../services/location_service.dart';

class WeatherController extends GetxController {
  // Observable variables
  final Rx<WeatherModel?> currentWeather = Rx<WeatherModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString currentLocation = 'Loading...'.obs;
  final RxString searchQuery = ''.obs;

  // State management
  bool get hasWeather => currentWeather.value != null;
  bool get hasError => errorMessage.value.isNotEmpty;
  bool get isInitialLoading => isLoading.value && currentWeather.value == null;

  @override
  void onInit() {
    super.onInit();
    // Load weather for current location on app start
    getCurrentLocationWeather();
  }

  // Get weather for current location
  Future<void> getCurrentLocationWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final position = await LocationService.getCurrentPosition();
      currentLocation.value =
          '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';

      final weather = await WeatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      if (weather != null) {
        currentWeather.value = weather;
        currentLocation.value = weather.fullLocation;
      } else {
        errorMessage.value = 'Unable to fetch weather data';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error getting current location weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get weather by city name
  Future<void> getWeatherByCity(String cityName) async {
    if (cityName.trim().isEmpty) {
      errorMessage.value = 'Please enter a city name';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      searchQuery.value = cityName.trim();

      print('Fetching weather for: ${cityName.trim()}');

      final weather = await WeatherService.getWeatherByCity(cityName.trim());

      if (weather != null) {
        currentWeather.value = weather;
        currentLocation.value = weather.fullLocation;
        print('Weather data received for: ${weather.fullLocation}');
      } else {
        errorMessage.value = 'City not found. Please try again.';
        throw Exception('No weather data received');
      }
    } catch (e) {
      errorMessage.value =
          'Unable to find weather data for "$cityName". Please check the spelling and try again.';
      print('Error getting weather by city: $e');
      rethrow; // Re-throw to allow UI to handle the error
    } finally {
      isLoading.value = false;
    }
  }

  // Get weather by coordinates (for map location picker)
  Future<void> getWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final weather = await WeatherService.getWeatherByCoordinates(
        latitude,
        longitude,
      );

      if (weather != null) {
        currentWeather.value = weather;
        currentLocation.value = weather.fullLocation;
      } else {
        errorMessage.value = 'Unable to fetch weather data for this location';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error getting weather by coordinates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh weather data
  Future<void> refreshWeather() async {
    if (currentWeather.value != null) {
      await getCurrentLocationWeather();
    }
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // Clear search query
  void clearSearch() {
    searchQuery.value = '';
  }

  // Get weather icon URL
  String getWeatherIconUrl() {
    return currentWeather.value?.weatherIconUrl ?? '';
  }

  // Get formatted temperature
  String getFormattedTemperature() {
    return currentWeather.value?.temperatureString ?? '--°C';
  }

  // Get weather description
  String getWeatherDescription() {
    return currentWeather.value?.weatherDescription ?? 'Unknown';
  }

  // Get weather main
  String getWeatherMain() {
    return currentWeather.value?.weatherMain ?? 'Unknown';
  }
}
