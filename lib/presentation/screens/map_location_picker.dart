import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

class MapLocationPicker extends StatefulWidget {
  const MapLocationPicker({super.key});

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  late GoogleMapController _mapController;
  final WeatherController weatherController = Get.find<WeatherController>();

  LatLng? _selectedLocation;
  String _selectedAddress = 'Tap on map to select location';
  bool _isLoadingAddress = false;

  // Default to a central location (you can change this)
  static const LatLng _defaultLocation = LatLng(
    23.8103,
    90.4125,
  ); // Dhaka, Bangladesh

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _confirmLocation,
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _defaultLocation,
              zoom: 10.0,
            ),
            onTap: _onMapTapped,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
          ),
          // Bottom sheet with selected location info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: const Color(0xFF4A90E2),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Selected Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_isLoadingAddress)
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF4A90E2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Finding address...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      _selectedAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A5568),
                        height: 1.4,
                      ),
                    ),
                  if (_selectedLocation != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Use This Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Instructions overlay
          if (_selectedLocation == null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: const Color(0xFF4A90E2),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tap anywhere on the map to select a location',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A5568),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

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
          infoWindow: const InfoWindow(
            title: 'Selected Location',
            snippet: 'Tap "Use This Location" to confirm',
          ),
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

    // Show loading
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // Get weather for the selected location
      await weatherController.getWeatherByCoordinates(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );

      // Close loading dialog
      Get.back();

      // Go back to home screen
      Get.back();

      // Show success message
      Get.snackbar(
        'Location Updated',
        'Weather data updated for selected location',
        backgroundColor: const Color(0xFF4A90E2),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      // Close loading dialog
      Get.back();

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
}
