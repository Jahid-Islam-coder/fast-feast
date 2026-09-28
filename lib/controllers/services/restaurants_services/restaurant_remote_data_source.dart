import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'dart:developer';
import '../../../models/foods_model.dart';
import '../../../models/restaurants_model.dart';

class RestaurantRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  static bool _isGeofireInitialized = false;

  // listen to geofire stream for nearby spots
  Stream<dynamic> getNearbyRestaurantsStream(double lat, double lng, double radius) {
    if (!_isGeofireInitialized) {
      Geofire.initialize("RestaurantLocations");
      _isGeofireInitialized = true;
    }
    return Geofire.queryAtLocation(lat, lng, radius) ?? const Stream.empty();
  }

  // fetch restaurant info from firebase
  Future<RestaurantDetailModel?> fetchRestaurantDetails(String restaurantId) async {
    try {
      DataSnapshot snapshot = await _db.child("RestaurantDetails/$restaurantId").get();
      if (snapshot.exists) {
        return RestaurantDetailModel.fromMap(restaurantId, snapshot.value as Map);
      }
    } catch (e) {
      log("Error fetching restaurant details: $e");
    }
    return null;
  }

  // fetch menu items for a restaurant
  Future<List<FoodModel>> fetchRestaurantMenu(String restaurantId) async {
    List<FoodModel> menuItems = [];
    try {
      DataSnapshot snapshot = await _db.child("RestaurantMenus/$restaurantId").get();
      if (snapshot.exists) {
        Map itemsMap = snapshot.value as Map;
        itemsMap.forEach((key, value) {
          if (value is Map) {
            Map itemData = value as Map;
            // attach restaurantId to item
            itemData['restaurantId'] = restaurantId;
            menuItems.add(FoodModel.fromMap(key.toString(), itemData));
          }
        });
      }
    } catch (e) {
      log("Error fetching menu items: $e");
    }
    return menuItems;
  }

  // recalculate and update restaurant rating
  Future<void> updateRestaurantRating(String restaurantId, double newRating) async {
    try {
      DataSnapshot snapshot = await _db.child("RestaurantDetails/$restaurantId").get();
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        double currentRating = data['rating']?.toDouble() ?? 0.0;
        int currentCount = data['ratingCount']?.toInt() ?? 0;

        int newCount = currentCount + 1;
        double calculatedRating = ((currentRating * currentCount) + newRating) / newCount;

        await _db.child("RestaurantDetails/$restaurantId").update({
          "rating": calculatedRating,
          "ratingCount": newCount,
        });
      }
    } catch (e) {
      log("Error updating restaurant rating: $e");
    }
  }

  // fetch restaurant ids matching category
  Future<List<String>> fetchRestaurantIdsByCategory(String category) async {
    List<String> ids = [];
    try {
      DataSnapshot snapshot = await _db.child("CategoryRestaurants/$category").get();
      if (snapshot.exists) {
        if (snapshot.value is Map) {
          Map data = snapshot.value as Map;
          data.forEach((key, value) {
            if (value == true) {
              ids.add(key.toString());
            }
          });
        }
      }
    } catch (e) {
      log("Error fetching category restaurants: $e");
    }
    return ids;
  }
}
