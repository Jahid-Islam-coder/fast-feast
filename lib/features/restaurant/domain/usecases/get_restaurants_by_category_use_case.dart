import '../repositories/restaurant_repository.dart';

class GetRestaurantsByCategoryUseCase {
  final RestaurantRepository repository;

  GetRestaurantsByCategoryUseCase(this.repository);

  Future<List<String>> call(String category) {
    return repository.getRestaurantIdsByCategory(category);
  }
}
