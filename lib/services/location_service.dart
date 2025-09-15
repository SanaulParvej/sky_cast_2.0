import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission
  static Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  static Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current position with better error handling
  static Future<Position> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceDisabledException();
      }

      // Check permissions
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
        if (permission == LocationPermission.denied) {
          throw LocationPermissionDeniedException();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionDeniedForeverException();
      }

      // Get current position with timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Changed from high to medium
        timeLimit: const Duration(seconds: 15), // Increased timeout
      );
    } catch (e) {
      if (e is LocationException) {
        rethrow;
      }
      throw LocationException('Failed to get current position: $e');
    }
  }

  // Calculate distance between two points
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}

// Custom exceptions
class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  
  @override
  String toString() => message;
}

class LocationServiceDisabledException extends LocationException {
  LocationServiceDisabledException() : super('Location services are disabled');
}

class LocationPermissionDeniedException extends LocationException {
  LocationPermissionDeniedException() : super('Location permissions are denied');
}

class LocationPermissionDeniedForeverException extends LocationException {
  LocationPermissionDeniedForeverException() : super('Location permissions are permanently denied');
}
