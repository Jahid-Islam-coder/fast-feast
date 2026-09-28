import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/foods_model.dart';

void main() {
  group('FoodModel Tests', () {
    test('should instantiate FoodModel correctly', () {
      final food = FoodModel(
        id: 'f1',
        name: 'Cheeseburger',
        image: 'http://example.com/burger.jpg',
        price: 9.99,
        description: 'Juicy beef patty with cheddar cheese',
        category: 'Fast Food',
        restaurantId: 'rest123',
      );

      expect(food.id, equals('f1'));
      expect(food.name, equals('Cheeseburger'));
      expect(food.image, equals('http://example.com/burger.jpg'));
      expect(food.price, equals(9.99));
      expect(food.description, equals('Juicy beef patty with cheddar cheese'));
      expect(food.category, equals('Fast Food'));
      expect(food.restaurantId, equals('rest123'));
    });

    test('toMap should return correct map structure', () {
      final food = FoodModel(
        id: 'f1',
        name: 'Cheeseburger',
        image: 'http://example.com/burger.jpg',
        price: 9.99,
        description: 'Juicy beef patty',
        category: 'Fast Food',
      );

      final map = food.toMap();

      expect(map['id'], equals('f1'));
      expect(map['name'], equals('Cheeseburger'));
      expect(map['price'], equals(9.99));
      expect(map['category'], equals('Fast Food'));
      expect(map['restaurantId'], isNull);
    });

    test('fromMap should construct object and handle default fallbacks', () {
      final map = <String, dynamic>{
        'price': 12,
      };

      final food = FoodModel.fromMap('f2', map);

      expect(food.id, equals('f2'));
      expect(food.name, equals('No Name'));
      expect(food.image, equals(''));
      expect(food.price, equals(12.0));
      expect(food.description, equals('No Description'));
      expect(food.category, equals('No Category'));
    });

    test('toJson and fromJson should convert properly', () {
      final food = FoodModel(
        id: 'f3',
        name: 'Pepperoni Pizza',
        image: 'http://example.com/pizza.jpg',
        price: 15.50,
        description: 'Classic pepperoni pizza',
        category: 'Pizza',
        restaurantId: 'rest456',
      );

      final jsonStr = food.toJson();
      final foodFromJson = FoodModel.fromJson('f3', jsonStr);

      expect(foodFromJson.id, equals('f3'));
      expect(foodFromJson.name, equals('Pepperoni Pizza'));
      expect(foodFromJson.price, equals(15.50));
      expect(foodFromJson.restaurantId, equals('rest456'));
    });
  });
}
