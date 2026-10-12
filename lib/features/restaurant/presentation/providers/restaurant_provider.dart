import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/usecases/get_nearby_restaurants_use_case.dart';
import '../../domain/usecases/get_restaurant_details_use_case.dart';

class RestaurantProvider extends ChangeNotifier {
  final GetNearbyRestaurantsUseCase? getNearbyRestaurantsUseCase;
  final GetRestaurantDetailsUseCase? getRestaurantDetailsUseCase;

  final List<RestaurantEntity> _allNearbyRestaurants = [];
  List<RestaurantEntity> _filteredRestaurants = [];
  bool _isLoading = false;
  String _selectedCategory = '';
  StreamSubscription? _nearbySubscription;

  List<RestaurantEntity> get restaurants => _selectedCategory.isEmpty ? _allNearbyRestaurants : _filteredRestaurants;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  RestaurantProvider({
    this.getNearbyRestaurantsUseCase,
    this.getRestaurantDetailsUseCase,
  });

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
        bool hasCategory = false;
        if (restaurant.categories != null) {
          hasCategory = restaurant.categories!.containsKey(_selectedCategory.toLowerCase());
        }
        bool matchesCuisine = restaurant.cuisineType?.toLowerCase() == _selectedCategory.toLowerCase();
        bool matchesKeywords = false;
        if (restaurant.searchKeywords != null) {
          matchesKeywords = restaurant.searchKeywords!.containsKey(_selectedCategory.toLowerCase());
        }
        return hasCategory || matchesCuisine || matchesKeywords;
      }).toList();
    }
  }

  void fetchNearbyRestaurants(BuildContext context, double lat, double lng) {
    if (getNearbyRestaurantsUseCase == null) return;
    _nearbySubscription?.cancel();
    clearRestaurants();
    setLoading(true);

    const double radius = 50;

    Future.delayed(const Duration(seconds: 10), () {
      if (_isLoading) {
        setLoading(false);
      }
    });

    _nearbySubscription = getNearbyRestaurantsUseCase!(lat, lng, radius).listen((event) {
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
    if (getRestaurantDetailsUseCase == null) return;
    if (_allNearbyRestaurants.any((res) => res.id == restaurantId)) return;

    try {
      final restaurantData = await getRestaurantDetailsUseCase!(restaurantId);

      if (restaurantData != null) {
        if (!_allNearbyRestaurants.any((res) => res.id == restaurantId)) {
          _allNearbyRestaurants.add(restaurantData);
          _filterRestaurants();
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error adding restaurant: $e');
    }
  }
}
