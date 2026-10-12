import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantDetailsUseCase {
  final RestaurantRepository repository;

  GetRestaurantDetailsUseCase(this.repository);

  Future<RestaurantEntity?> call(String restaurantId) {
    return repository.getRestaurantDetails(restaurantId);
  }
}
