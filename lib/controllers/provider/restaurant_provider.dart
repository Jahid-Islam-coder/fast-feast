import 'dart:async';
import 'package:fastfeast/models/restaurants_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import '../services/restaurants_services/restaurant_services.dart';

class RestaurantProvider extends ChangeNotifier {
  final List<RestaurantDetailModel> _allNearbyRestaurants = [];
  List<RestaurantDetailModel> _filteredRestaurants = [];
  bool _isLoading = false;
  String _selectedCategory = '';
  StreamSubscription? _nearbySubscription;

  List<RestaurantDetailModel> get restaurants => _selectedCategory.isEmpty ? _allNearbyRestaurants : _filteredRestaurants;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearRestaurants() {
    _allNearbyRestaurants.clear();
    _filteredRestaurants.clear();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _nearbySubscription?.cancel();
    super.dispose();
  }

  // filter restaurants by category
  void setCategory(String category) {
    _selectedCategory = category;
    _filterRestaurants();
    notifyListeners();
  }

  void _filterRestaurants() {
    if (_selectedCategory.isEmpty) {
      _filteredRestaurants = List.from(_allNearbyRestaurants);
    } else {
      _filteredRestaurants = _allNearbyRestaurants.where((restaurant) {
        // check categories map first
        bool hasCategory = false;
        if (restaurant.categories != null) {
          hasCategory = restaurant.categories!.containsKey(_selectedCategory.toLowerCase());
        }
        
        // fallback to cuisine type
        bool matchesCuisine = restaurant.cuisineType?.toLowerCase() == _selectedCategory.toLowerCase();
        
        // fallback to search keywords
        bool matchesKeywords = false;
        if (restaurant.searchKeywords != null) {
          matchesKeywords = restaurant.searchKeywords!.containsKey(_selectedCategory.toLowerCase());
        }

        return hasCategory || matchesCuisine || matchesKeywords;
      }).toList();
    }
  }

  // query geofire for nearby restaurants
  void fetchNearbyRestaurants(BuildContext context, double lat, double lng) {
    _nearbySubscription?.cancel();
    
    clearRestaurants();
    setLoading(true);

    const double radius = 50;

    Future.delayed(const Duration(seconds: 10), () {
      if (_isLoading) {
        setLoading(false);
      }
    });

    _nearbySubscription = RestaurantServices.getNearbyRestaurantsStream(lat, lng, radius).listen((event) {
      if (event != null) {
        var callback = event['callBack'];
        String restaurantId = event['key'];

        switch (callback) {
          case Geofire.onKeyEntered:
            addRestaurants(restaurantId);
            break;
            
          case Geofire.onGeoQueryReady:
            setLoading(false);
            break;
        }
      }
    }, onError: (error) {
      debugPrint("Geofire error: $error");
      setLoading(false);
    });
  }

  Future<void> addRestaurants(String restaurantId) async {
    if (_allNearbyRestaurants.any((res) => res.id == restaurantId)) return;

    try {
      final restaurantData = await RestaurantServices.getRestaurantDetails(restaurantId);

      if (restaurantData != null) {
        if (!_allNearbyRestaurants.any((res) => res.id == restaurantId)) {
          _allNearbyRestaurants.add(restaurantData);
          _filterRestaurants(); // Update filtered list as new restaurants arrive
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error adding restaurant: $e');
    }
  }
}
