import 'package:flutter_test/flutter_test.dart';
import 'package:fastfeast/controllers/provider/category_provider.dart';

void main() {
  group('CategoryController Tests', () {
    test('initial values should be empty strings', () {
      final controller = CategoryController();
      expect(controller.categoryValue, isEmpty);
      expect(controller.titleValue, isEmpty);
    });

    test('updateCategory should update value and notify listeners when value changes', () {
      final controller = CategoryController();
      int notifyCount = 0;

      controller.addListener(() {
        notifyCount++;
      });

      controller.updateCategory = 'Burger';
      expect(controller.categoryValue, equals('Burger'));
      expect(notifyCount, equals(1));

      // Setting same value should not notify listeners again
      controller.updateCategory = 'Burger';
      expect(notifyCount, equals(1));
    });

    test('updateTitle should update value and notify listeners when value changes', () {
      final controller = CategoryController();
      int notifyCount = 0;

      controller.addListener(() {
        notifyCount++;
      });

      controller.updateTitle = 'Fast Food';
      expect(controller.titleValue, equals('Fast Food'));
      expect(notifyCount, equals(1));

      // Setting same value should not notify listeners again
      controller.updateTitle = 'Fast Food';
      expect(notifyCount, equals(1));
    });
  });
}
