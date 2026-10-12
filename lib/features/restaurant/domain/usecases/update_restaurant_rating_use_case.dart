import '../repositories/restaurant_repository.dart';

class UpdateRestaurantRatingUseCase {
  final RestaurantRepository repository;

  UpdateRestaurantRatingUseCase(this.repository);

  Future<void> call(String restaurantId, double rating) {
    return repository.updateRating(restaurantId, rating);
  }
}
