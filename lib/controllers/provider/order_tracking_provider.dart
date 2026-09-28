import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingProvider with ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  
  LatLng? _deliveryLocation;
  LatLng? _restaurantLocation;
  LatLng? _userLocation;
  
  StreamSubscription<DatabaseEvent>? _deliveryLocationSubscription;
  
  LatLng? get deliveryLocation => _deliveryLocation;
  LatLng? get restaurantLocation => _restaurantLocation;
  LatLng? get userLocation => _userLocation;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> initializeTracking(String orderId, String restaurantId, LatLng userLoc) async {
    _isLoading = true;
    _userLocation = userLoc;
    notifyListeners();

    try {
      // fetch restaurant coords
      final snapshot = await _db.child("RestaurantLocations/$restaurantId/l").get();
      if (snapshot.exists) {
        final List<dynamic> locList = snapshot.value as List<dynamic>;
        _restaurantLocation = LatLng(
          (locList[0] as num).toDouble(),
          (locList[1] as num).toDouble(),
        );
      }

      // listen for rider location updates
      startTracking(orderId);
      
      _updateMarkers();
    } catch (e) {
      debugPrint("Error initializing tracking: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startTracking(String orderId) {
    // stream rider's live position
    _deliveryLocationSubscription?.cancel();
    _deliveryLocationSubscription = _db
        .child("orders/$orderId/delivery_location")
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        _deliveryLocation = LatLng(
          (data['latitude'] as num).toDouble(),
          (data['longitude'] as num).toDouble(),
        );
        _updateMarkers();
        notifyListeners();
      }
    });
  }

  void _updateMarkers() {
    _markers.clear();
    _polylines.clear();
    
    if (_restaurantLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("restaurant"),
          position: _restaurantLocation!,
          infoWindow: const InfoWindow(title: "Restaurant"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }
    
    if (_userLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("user"),
          position: _userLocation!,
          infoWindow: const InfoWindow(title: "Your Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    
    if (_deliveryLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("delivery"),
          position: _deliveryLocation!,
          infoWindow: const InfoWindow(title: "Delivery Partner"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      
      if (_userLocation != null) {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: [_deliveryLocation!, _userLocation!],
            color: const Color(0xFF8a2ae4),
            width: 5,
          )
        );
      }
    } else if (_restaurantLocation != null && _userLocation != null) {
      // if delivery hasn't started yet, show route from restaurant to user
      _polylines.add(
          Polyline(
            polylineId: const PolylineId("route_initial"),
            points: [_restaurantLocation!, _userLocation!],
            color: Colors.grey,
            width: 3,
            patterns: [PatternItem.dash(10), PatternItem.gap(10)],
          )
      );
    }
  }

  @override
  void dispose() {
    _deliveryLocationSubscription?.cancel();
    super.dispose();
  }
}
