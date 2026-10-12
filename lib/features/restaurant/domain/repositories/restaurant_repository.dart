import '../entities/restaurant_entity.dart';
import '../entities/food_entity.dart';

abstract class RestaurantRepository {
  Stream<dynamic> getNearbyRestaurantsStream(double lat, double lng, double radius);
  Future<RestaurantEntity?> getRestaurantDetails(String restaurantId);
  Future<List<FoodEntity>> getRestaurantMenu(String restaurantId);
  Future<void> updateRating(String restaurantId, double rating);
  Future<List<String>> getRestaurantIdsByCategory(String category);
}
