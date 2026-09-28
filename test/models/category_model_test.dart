import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/models/categories.dart';

void main() {
  group('CategoryModel Tests', () {
    test('should correctly instantiate CategoryModel', () {
      final category = CategoryModel(
        id: 'cat1',
        name: 'Burger',
        imageUrl: 'http://example.com/burger.png',
        description: 'Delicious burgers',
      );

      expect(category.id, equals('cat1'));
      expect(category.name, equals('Burger'));
      expect(category.imageUrl, equals('http://example.com/burger.png'));
      expect(category.description, equals('Delicious burgers'));
    });

    test('toMap should convert CategoryModel to Map correctly', () {
      final category = CategoryModel(
        id: 'cat1',
        name: 'Burger',
        imageUrl: 'http://example.com/burger.png',
        description: 'Delicious burgers',
      );

      final map = category.toMap();

      expect(map['id'], equals('cat1'));
      expect(map['name'], equals('Burger'));
      expect(map['imageUrl'], equals('http://example.com/burger.png'));
      expect(map['description'], equals('Delicious burgers'));
    });

    test('fromMap should create CategoryModel from Map correctly', () {
      final map = {
        'id': 'cat2',
        'name': 'Pizza',
        'imageUrl': 'http://example.com/pizza.png',
        'description': 'Cheesy pizza',
      };

      final category = CategoryModel.fromMap(map);

      expect(category.id, equals('cat2'));
      expect(category.name, equals('Pizza'));
      expect(category.imageUrl, equals('http://example.com/pizza.png'));
      expect(category.description, equals('Cheesy pizza'));
    });

    test('fromMap should handle null description', () {
      final map = {
        'id': 'cat3',
        'name': 'Drinks',
        'imageUrl': 'http://example.com/drinks.png',
        'description': null,
      };

      final category = CategoryModel.fromMap(map);

      expect(category.id, equals('cat3'));
      expect(category.description, isNull);
    });

    test('toJson and fromJson should serialize and deserialize correctly', () {
      final category = CategoryModel(
        id: 'cat4',
        name: 'Pasta',
        imageUrl: 'http://example.com/pasta.png',
      );

      final jsonString = category.toJson();
      final categoryFromJson = CategoryModel.fromJson(jsonString);

      expect(categoryFromJson.id, equals(category.id));
      expect(categoryFromJson.name, equals(category.name));
      expect(categoryFromJson.imageUrl, equals(category.imageUrl));
      expect(categoryFromJson.description, equals(category.description));
    });
  });
}
