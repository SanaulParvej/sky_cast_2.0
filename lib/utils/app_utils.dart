import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, HH:mm').format(dateTime);
  }

  static String getWeekday(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getMonth(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  static String getDay(DateTime date) {
    return DateFormat('d').format(date);
  }

  static String getYear(DateTime date) {
    return DateFormat('y').format(date);
  }

  static String formatSunriseSunset(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('HH:mm').format(dateTime);
  }
}

class WeatherUtils {
  static String getWeatherEmoji(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      case 'haze':
        return '🌫️';
      case 'smoke':
        return '💨';
      case 'dust':
        return '🌪️';
      case 'sand':
        return '🌪️';
      case 'ash':
        return '🌋';
      case 'squall':
        return '💨';
      case 'tornado':
        return '🌪️';
      default:
        return '🌤️';
    }
  }

  static String getWindDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'N';
    if (degrees >= 22.5 && degrees < 67.5) return 'NE';
    if (degrees >= 67.5 && degrees < 112.5) return 'E';
    if (degrees >= 112.5 && degrees < 157.5) return 'SE';
    if (degrees >= 157.5 && degrees < 202.5) return 'S';
    if (degrees >= 202.5 && degrees < 247.5) return 'SW';
    if (degrees >= 247.5 && degrees < 292.5) return 'W';
    if (degrees >= 292.5 && degrees < 337.5) return 'NW';
    return 'N';
  }

  static String getTemperatureDescription(double temp) {
    if (temp < 0) return 'Freezing';
    if (temp < 10) return 'Cold';
    if (temp < 20) return 'Cool';
    if (temp < 30) return 'Warm';
    if (temp < 40) return 'Hot';
    return 'Very Hot';
  }

  static String getHumidityDescription(double humidity) {
    if (humidity < 30) return 'Dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 80) return 'Humid';
    return 'Very Humid';
  }

  static String getPressureDescription(double pressure) {
    if (pressure < 1000) return 'Low';
    if (pressure < 1020) return 'Normal';
    return 'High';
  }
}

class ValidationUtils {
  static bool isValidCityName(String cityName) {
    return cityName.trim().isNotEmpty && 
           cityName.length >= 2 && 
           RegExp(r'^[a-zA-Z\s]+$').hasMatch(cityName.trim());
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }
}
