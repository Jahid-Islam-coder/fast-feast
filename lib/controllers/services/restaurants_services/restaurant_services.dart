import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';
import 'restaurant_remote_data_source.dart';
import '../../../models/foods_model.dart';
import '../../../models/restaurants_model.dart';
import '../../provider/restaurant_provider.dart';
import '../../provider/restaurant_menu_provider.dart';

class RestaurantServices {
  static final RestaurantRemoteDataSource _dataSource = RestaurantRemoteDataSource();

  static Stream<dynamic> getNearbyRestaurantsStream(double lat, double lng, double radius) {
    return _dataSource.getNearbyRestaurantsStream(lat, lng, radius);
  }

  static Future<RestaurantDetailModel?> getRestaurantDetails(String restaurantId) async {
    return await _dataSource.fetchRestaurantDetails(restaurantId);
  }

  static Future<List<FoodModel>> getRestaurantMenu(String restaurantId) async {
    return await _dataSource.fetchRestaurantMenu(restaurantId);
  }

  static Future<void> updateRating(String restaurantId, double rating) async {
    await _dataSource.updateRestaurantRating(restaurantId, rating);
  }

  static Future<List<String>> getRestaurantIdsByCategory(String category) async {
    return await _dataSource.fetchRestaurantIdsByCategory(category);
  }
}
