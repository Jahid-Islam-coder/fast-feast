import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  LatLng? _pickedLocation;
  String _address = "";
  bool _isLoading = false;

  LatLng? get pickedLocation => _pickedLocation;
  String get address => _address;
  bool get isLoading => _isLoading;

  Future<void> setPickedLocation(LatLng location) async {
    _pickedLocation = location;
    notifyListeners();
    await getAddressFromLatLng(location);
  }

  Future<LatLng?> getCoordinatesFromAddress(String addressStr) async {
    final trimmed = addressStr.trim();
    if (trimmed.isEmpty) return null;

    // 1. Try geocoding direct address string
    try {
      List<Location> locations = await locationFromAddress(trimmed);
      if (locations.isNotEmpty) {
        final loc = LatLng(locations.first.latitude, locations.first.longitude);
        _pickedLocation = loc;
        _address = trimmed;
        notifyListeners();
        return loc;
      }
    } catch (e) {
      debugPrint("Direct geocoding failed for '$trimmed': $e");
    }

    // 2. Clean unit/suite identifiers (e.g. "#100", "Apt 2B", "Suite 300", "Unit A") and retry
    String cleaned = trimmed
        .replaceAll(RegExp(r'#\d+[\w-]*', caseSensitive: false), '')
        .replaceAll(RegExp(r'\b(apt|suite|ste|unit|bldg|building|floor|fl)\b\s*\w+', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (cleaned.isNotEmpty && cleaned != trimmed) {
      try {
        List<Location> locations = await locationFromAddress(cleaned);
        if (locations.isNotEmpty) {
          final loc = LatLng(locations.first.latitude, locations.first.longitude);
          _pickedLocation = loc;
          _address = trimmed;
          notifyListeners();
          return loc;
        }
      } catch (e) {
        debugPrint("Cleaned geocoding failed for '$cleaned': $e");
      }
    }

    // 3. Fallback: Try trailing address parts (e.g., city, state, postal code)
    try {
      final parts = trimmed.split(',');
      if (parts.length > 1) {
        final fallbackAddress = parts.sublist(1).join(',').trim();
        if (fallbackAddress.isNotEmpty) {
          List<Location> locations = await locationFromAddress(fallbackAddress);
          if (locations.isNotEmpty) {
            final loc = LatLng(locations.first.latitude, locations.first.longitude);
            _pickedLocation = loc;
            _address = trimmed;
            notifyListeners();
            return loc;
          }
        }
      }
    } catch (e) {
      debugPrint("Fallback geocoding failed: $e");
    }

    return _pickedLocation;
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> addressParts = [];
        if (place.street != null && place.street!.trim().isNotEmpty) {
          addressParts.add(place.street!.trim());
        }
        if (place.subLocality != null && place.subLocality!.trim().isNotEmpty) {
          addressParts.add(place.subLocality!.trim());
        }
        if (place.locality != null && place.locality!.trim().isNotEmpty) {
          addressParts.add(place.locality!.trim());
        }
        if (place.postalCode != null && place.postalCode!.trim().isNotEmpty) {
          addressParts.add(place.postalCode!.trim());
        }
        if (place.country != null && place.country!.trim().isNotEmpty) {
          addressParts.add(place.country!.trim());
        }

        _address = addressParts.isNotEmpty
            ? addressParts.join(", ")
            : "${position.latitude}, ${position.longitude}";
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error geocoding: $e");
      _address = "${position.latitude}, ${position.longitude}";
      notifyListeners();
    }
  }

  Future<bool> determinePosition({BuildContext? context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context != null && context.mounted) {
          serviceEnabled = await _promptEnableLocationService(context);
        }
        if (!serviceEnabled) {
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location permission denied")),
            );
          }
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context != null && context.mounted) {
          _promptOpenAppSettings(context);
        }
        _isLoading = false;
        notifyListeners();
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _pickedLocation = LatLng(position.latitude, position.longitude);
      await getAddressFromLatLng(_pickedLocation!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Location error: $e");
      if (_pickedLocation != null) {
        await getAddressFromLatLng(_pickedLocation!);
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> _promptEnableLocationService(BuildContext context) async {
    bool? allowed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Location Services Disabled"),
        content: const Text("Please turn on location to get your current position."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8a2ae4),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Allow", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (allowed == true) {
      await Geolocator.openLocationSettings();
      // check if user turned location on after opening settings
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (await Geolocator.isLocationServiceEnabled()) {
          return true;
        }
      }
      return await Geolocator.isLocationServiceEnabled();
    }
    return false;
  }

  void _promptOpenAppSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Location Permission Required"),
        content: const Text("Location permissions are permanently denied. Please enable them in app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8a2ae4),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openAppSettings();
            },
            child: const Text("Open Settings", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
