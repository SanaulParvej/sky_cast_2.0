import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart'; // Import geolocator package

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Your actual OpenWeatherMap API key
  final String _apiKey = 'e2082ee185cdd39a3b380b4a571acf99';

  // State variables to hold weather data
  bool _isLoading = true;
  String _location = 'Loading...';
  String _date = '';
  String _time = '';
  double _temperature = 0.0;
  String _weatherDescription = '';
  String _weatherMain = '';
  double _windSpeed = 0.0;
  double _humidity = 0.0;
  double _pressure = 0.0;
  double _maxTemp = 0.0;
  double _minTemp = 0.0;
  String _error = '';

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Initial data load for current location
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to get current location and fetch weather
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Check for location service and permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Location services are disabled.';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permissions are denied.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permissions are permanently denied, we cannot request permissions.';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Fetch weather using the coordinates
      _fetchWeatherData(
        lat: position.latitude.toString(),
        lon: position.longitude.toString(),
      );

    } catch (e) {
      setState(() {
        _error = 'Error getting location: ${e.toString()}';
        _isLoading = false;
      });
      print('Location Error: $e');
    }
  }

  // Function to fetch weather data from API (by city name or coordinates)
  Future<void> _fetchWeatherData({String? city, String? lat, String? lon}) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    String url;
    if (city != null) {
      url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
    } else if (lat != null && lon != null) {
      url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    } else {
      setState(() {
        _error = 'No location provided.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final now = DateTime.now();

        setState(() {
          _location = data['name'] + ', ' + data['sys']['country'];
          _date = _formatDate(now);
          _time = _formatTime(now);
          _temperature = data['main']['temp'];
          _weatherMain = data['weather'][0]['main'];
          _weatherDescription = data['weather'][0]['description'];
          _windSpeed = data['wind']['speed'];
          _humidity = data['main']['humidity'].toDouble();
          _pressure = data['main']['pressure'].toDouble();
          _maxTemp = data['main']['temp_max'];
          _minTemp = data['main']['temp_min'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _location = 'City not found';
          _isLoading = false;
        });
        print('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching data: ${e.toString()}';
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Helper functions for date and time formatting
  String _formatDate(DateTime date) {
    return '${_getWeekday(date.weekday)}, ${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _formatTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  String _getMonth(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }

  // Helper function to build a single detail card
  Widget _buildDetailCard(IconData icon, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: const Color(0xFFB3E0E6)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Light greyish-blue background
      appBar: AppBar(
        title: const Text(
          'Sky_Cast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _getCurrentLocation, // Call the new function
            icon: const Icon(Icons.my_location, color: Colors.black),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFB3E0E6)))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (city) {
                    if (city.isNotEmpty) {
                      _fetchWeatherData(city: city);
                    }
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),

              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Main Weather Card
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3E0E6), // A light bluish-green
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _date,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _location,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '${_temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        _weatherMain,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Icon(
                        Icons.cloud,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        _weatherDescription,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Details Section Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Details Cards
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildDetailCard(Icons.air, '${_windSpeed.toStringAsFixed(1)} km/h', 'Wind'),
                  _buildDetailCard(Icons.thermostat_outlined, '${_maxTemp.toStringAsFixed(1)} °C', 'Max'),
                  _buildDetailCard(Icons.thermostat_outlined, '${_minTemp.toStringAsFixed(1)} °C', 'Min'),
                  _buildDetailCard(Icons.opacity, '${_humidity.toStringAsFixed(0)} %', 'Humidity'),
                  _buildDetailCard(Icons.compress, '${_pressure.toStringAsFixed(0)} hPa', 'Pressure'),
                  //_buildDetailCard(Icons.water_level, 'N/A', 'Sea-Level'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
