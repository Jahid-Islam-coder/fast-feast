import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetAllRestaurantsUseCase {
  final RestaurantRepository repository;

  GetAllRestaurantsUseCase(this.repository);

  Future<List<RestaurantEntity>> call() {
    return repository.getAllRestaurants();
  }
}
