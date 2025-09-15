class WeatherModel {
  final String location;
  final String country;
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final double windSpeed;
  final double humidity;
  final double pressure;
  final double visibility;
  final int sunrise;
  final int sunset;
  final DateTime lastUpdated;

  WeatherModel({
    required this.location,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? 'Unknown',
      temperature: (json['main']['temp'] ?? 0.0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0.0).toDouble(),
      minTemp: (json['main']['temp_min'] ?? 0.0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0.0).toDouble(),
      weatherMain: json['weather'][0]['main'] ?? 'Unknown',
      weatherDescription: json['weather'][0]['description'] ?? 'Unknown',
      weatherIcon: json['weather'][0]['icon'] ?? '01d',
      windSpeed: (json['wind']['speed'] ?? 0.0).toDouble(),
      humidity: (json['main']['humidity'] ?? 0.0).toDouble(),
      pressure: (json['main']['pressure'] ?? 0.0).toDouble(),
      visibility: (json['visibility'] ?? 0.0).toDouble() / 1000, // Convert to km
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      lastUpdated: DateTime.now(),
    );
  }

  String get fullLocation => '$location, $country';
  
  String get temperatureString => '${temperature.toStringAsFixed(1)}°C';
  String get feelsLikeString => '${feelsLike.toStringAsFixed(1)}°C';
  String get minTempString => '${minTemp.toStringAsFixed(1)}°C';
  String get maxTempString => '${maxTemp.toStringAsFixed(1)}°C';
  String get windSpeedString => '${windSpeed.toStringAsFixed(1)} km/h';
  String get humidityString => '${humidity.toStringAsFixed(0)}%';
  String get pressureString => '${pressure.toStringAsFixed(0)} hPa';
  String get visibilityString => '${visibility.toStringAsFixed(1)} km';

  String get weatherIconUrl => 'https://openweathermap.org/img/wn/$weatherIcon@2x.png';
}
