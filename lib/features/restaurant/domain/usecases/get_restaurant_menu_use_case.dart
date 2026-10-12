import '../entities/food_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantMenuUseCase {
  final RestaurantRepository repository;

  GetRestaurantMenuUseCase(this.repository);

  Future<List<FoodEntity>> call(String restaurantId) {
    return repository.getRestaurantMenu(restaurantId);
  }
}
