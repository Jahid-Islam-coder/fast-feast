import '../repositories/restaurant_repository.dart';

class GetNearbyRestaurantsUseCase {
  final RestaurantRepository repository;

  GetNearbyRestaurantsUseCase(this.repository);

  Stream<dynamic> call(double lat, double lng, double radius) {
    return repository.getNearbyRestaurantsStream(lat, lng, radius);
  }
}
