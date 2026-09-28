import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/controllers/provider/search_provider.dart';
import 'package:fastfeast/models/restaurants_model.dart';

void main() {
  group('SearchProvider Tests', () {
    late SearchProvider searchProvider;
    late List<RestaurantDetailModel> mockRestaurants;

    setUp(() {
      searchProvider = SearchProvider();
      mockRestaurants = [
        RestaurantDetailModel(
          id: 'r1',
          name: 'Burger King',
          image: '',
          rating: 4.5,
          address: 'Main St',
          cuisineType: 'Fast Food',
          isAvailable: true,
          searchKeywords: {'fastfood': true, 'burger': true},
        ),
        RestaurantDetailModel(
          id: 'r2',
          name: 'Pizza Hut',
          image: '',
          rating: 4.2,
          address: '2nd Ave',
          cuisineType: 'Italian',
          isAvailable: true,
          searchKeywords: {'pizza': true, 'cheese': true},
        ),
        RestaurantDetailModel(
          id: 'r3',
          name: 'Taco Bell',
          image: '',
          rating: 4.0,
          address: '3rd St',
          cuisineType: 'Mexican',
          isAvailable: true,
          searchKeywords: {'taco': true, 'mexican': true},
        ),
      ];
    });

    test('filteredResults should be empty initially or when query is empty', () {
      expect(searchProvider.filteredResults, isEmpty);

      searchProvider.updateQuery('', mockRestaurants);
      expect(searchProvider.filteredResults, isEmpty);
    });

    test('should filter restaurants by name case-insensitively', () {
      searchProvider.updateQuery('burger', mockRestaurants);

      expect(searchProvider.filteredResults.length, equals(1));
      expect(searchProvider.filteredResults.first.name, equals('Burger King'));
    });

    test('should filter restaurants by searchKeywords', () {
      searchProvider.updateQuery('pizza', mockRestaurants);

      expect(searchProvider.filteredResults.length, equals(1));
      expect(searchProvider.filteredResults.first.name, equals('Pizza Hut'));
    });

    test('should return empty list when no matches found', () {
      searchProvider.updateQuery('sushi', mockRestaurants);

      expect(searchProvider.filteredResults, isEmpty);
    });
  });
}
