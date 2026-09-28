import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/restaurants_model.dart';

void main() {
  group('RestaurantDetailModel Tests', () {
    test('should instantiate RestaurantDetailModel correctly', () {
      final restaurant = RestaurantDetailModel(
        id: 'r1',
        name: 'Burger King',
        image: 'http://example.com/bk.png',
        rating: 4.5,
        ratingCount: 120,
        address: '123 Main St',
        cuisineType: 'Fast Food',
        isAvailable: true,
        categories: {'burger': true},
        searchKeywords: {'burger': true, 'king': true},
      );

      expect(restaurant.id, equals('r1'));
      expect(restaurant.name, equals('Burger King'));
      expect(restaurant.rating, equals(4.5));
      expect(restaurant.ratingCount, equals(120));
      expect(restaurant.address, equals('123 Main St'));
      expect(restaurant.isAvailable, isTrue);
    });

    test('toMap should convert RestaurantDetailModel to Map properly', () {
      final restaurant = RestaurantDetailModel(
        id: 'r1',
        name: 'Burger King',
        image: 'http://example.com/bk.png',
        rating: 4.5,
        ratingCount: 100,
        address: '123 Main St',
        cuisineType: 'Fast Food',
        isAvailable: true,
      );

      final map = restaurant.toMap();

      expect(map['id'], equals('r1'));
      expect(map['name'], equals('Burger King'));
      expect(map['rating'], equals(4.5));
      expect(map['ratingCount'], equals(100));
      expect(map['isAvailable'], isTrue);
    });

    test('fromMap should construct object with missing/null values using fallbacks', () {
      final map = <String, dynamic>{};

      final restaurant = RestaurantDetailModel.fromMap('r2', map);

      expect(restaurant.id, equals('r2'));
      expect(restaurant.name, equals('No Name'));
      expect(restaurant.image, equals(''));
      expect(restaurant.rating, equals(0.0));
      expect(restaurant.ratingCount, equals(0));
      expect(restaurant.address, equals('No Address'));
      expect(restaurant.cuisineType, equals('No Cuisine Type'));
      expect(restaurant.isAvailable, isFalse);
    });
  });
}
