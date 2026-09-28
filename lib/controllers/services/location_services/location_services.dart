import 'package:geolocator/geolocator.dart';

// helper class to request location permission and get current position

class LocationServices {
  static Future<Position?> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 100,
    );

    final Position currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    return currentPosition;
  }
}
