import '../datasources/restaurant_remote_data_source.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl(this.remoteDataSource);

  @override
  Stream<dynamic> getNearbyRestaurantsStream(double lat, double lng, double radius) {
    return remoteDataSource.getNearbyRestaurantsStream(lat, lng, radius);
  }

  @override
  Future<RestaurantEntity?> getRestaurantDetails(String restaurantId) async {
    return await remoteDataSource.fetchRestaurantDetails(restaurantId);
  }

  @override
  Future<List<FoodEntity>> getRestaurantMenu(String restaurantId) async {
    return await remoteDataSource.fetchRestaurantMenu(restaurantId);
  }

  @override
  Future<void> updateRating(String restaurantId, double rating) async {
    await remoteDataSource.updateRestaurantRating(restaurantId, rating);
  }

  @override
  Future<List<String>> getRestaurantIdsByCategory(String category) async {
    return await remoteDataSource.fetchRestaurantIdsByCategory(category);
  }
}
