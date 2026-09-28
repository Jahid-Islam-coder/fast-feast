import 'package:fastfeast/controllers/provider/restaurant_menu_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestaurantMenuProvider Caching Tests', () {
    late RestaurantMenuProvider provider;

    setUp(() {
      provider = RestaurantMenuProvider();
    });

    test('isRestaurantCached returns false initially', () {
      expect(provider.isRestaurantCached('res_123'), false);
    });

    test('clearMenuCache resets provider state correctly', () {
      provider.emptyRestaurantFoods();
      expect(provider.restaurantFoods, isEmpty);

      provider.clearMenuCache();
      expect(provider.isRestaurantCached('res_123'), false);
      expect(provider.foods, isEmpty);
      expect(provider.restaurantFoods, isEmpty);
      expect(provider.isLoading, false);
    });
  });
}
