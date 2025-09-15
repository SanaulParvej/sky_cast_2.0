import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'e2082ee185cdd39a3b380b4a571acf99';

  // Get weather by city name
  static Future<WeatherModel?> getWeatherByCity(String cityName) async {
    try {
      final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get weather by coordinates
  static Future<WeatherModel?> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get weather icon URL
  static String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // Validate city name
  static bool isValidCityName(String cityName) {
    return cityName.trim().isNotEmpty && cityName.length >= 2;
  }
}
